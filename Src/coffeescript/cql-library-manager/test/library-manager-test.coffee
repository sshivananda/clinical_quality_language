should = require 'should'
{LibraryManager} = require '../lib/library_manager'
path = require("path")
fs = require("fs")
http    =  require('http')
mockserver  =  require('mockserver')

deleteFolderRecursive = (path)-> 
  if fs.existsSync(path) 
    fs.readdirSync(path).forEach((file,index)->
      curPath = path + "/" + file;
      if fs.lstatSync(curPath).isDirectory()
        deleteFolderRecursive(curPath)
      else 
        fs.unlinkSync(curPath);
    )
    fs.rmdirSync(path);



describe 'LibraryManager', ->

  it 'should be able to load a library from a directory', ->
    repo = new LibraryManager(__dirname)
    lib = repo.resolve("test_snippet")
    should(lib).not.be.null
    lib = repo.resolve("test","snippet")
    should(lib).not.be.null
    try
      @lib = repo.resolve("nothere")
      fail("should have thrown error")
    catch e

   
  it 'should be able to load a library from a zip file ', ->
    archive = path.join(__dirname,"cql_archive.zip")
    tempDir = path.join(__dirname,"../tmp")
    deleteFolderRecursive(tempDir)
    repo = new LibraryManager(archive,{temp_dir : tempDir})
    lib = repo.resolve("archive_snippet")
    should(lib).not.be.null
    lib = repo.resolve("archive","snippet")
    should(lib).not.be.null
    try
      @lib = repo.resolve("nothere")
      fail("should have thrown error")
    catch e
  
describe.skip "LibraryManager http access", ->
  it 'should be able to load a library from an http server', ->
    http.createServer(mockserver(path.join(__dirname,'mocks'))).listen(9001)
    repo = new LibraryManager("http://127.0.0.1:9001")
    lib = repo.resolve("test_snippet")
    should(lib).not.be.null
