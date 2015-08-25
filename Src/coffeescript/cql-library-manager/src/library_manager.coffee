fs = require('fs')
url = require("url")
AdmZip = require('adm-zip');
path = require('path')
{Library} = require('cql-execution')
{request} = require('urllib-sync')

module.exports.LibraryManager = class LibraryManager
  constructor: (@baseUrl, @options={}) ->
    @uri = url.parse(@baseUrl) 
    @isZip = @checkZip()
    @isFile = @isZip || @uri.protocol == "file" || !@uri.protocol
    @cache = {}

  resolve: (library,version) ->
    name = "#{library}_#{version}"
    return @cache[name] if @cache[name]
    data = if @isFile then  @readFromFs(library,version) else @readFromHttp(library,version)
    json = JSON.parse(data)
    lib = new Library(json,@)
    lib.source = json
    if @options.cache_enabled
      @cache[name] = lib
    lib

  readFromFs: (library,version) ->
    name = if version then "#{library}_#{version}.json" else "#{library}.json"
    basePath = @zipDir || @baseUrl
    cql_path = path.join(basePath, name)
    if !fs.existsSync(cql_path)
      throw "CQL Library #{library} #{version} not found"
    fs.readFileSync(cql_path)
  
  readFromHttp: (library,version) ->
    fullUrl = url.resolve(@baseUrl,"#{library}/#{version}")
    res = request(@baseUrl,{
        timeout: 30000,
        headers: {"ACCEPT" : "application/json, text/json, application-x/json, json"}
      })
    res.data

  checkZip: ->
    if (@uri.protocol == "file" || !@uri.protocol) && 
                   fs.lstatSync(@baseUrl).isFile() && 
                   path.extname(@baseUrl) == ".zip" 

      zipFile = new AdmZip(@baseUrl)
      tempDir = @options.temp_dir || "./tmp"  
      @zipDir = path.join(tempDir,path.basename(@baseUrl))
      zipFile.extractAllTo(@zipDir, true);
      return true

  findAndSortVersions:(library) ->
    prefix = "#{library}_"
    possibles = fs.readdirSync(@base_dir)
    filenames = possibles.filter (x) -> x.indexOf(prefix) == 0 
    versions  = filenames.each (x) -> x.slice(0,prefix.length)?.replace(".json","")