{ Code, ValueSet } = require './cql-datatypes'
requestp = require "request-promise"
fs   = require 'fs'
xpath = require('xpath')
dom = require('xmldom').DOMParser
Promise = require("promise")
fs.readFile = Promise.denodeify(fs.readFile)
fs.mkdir = Promise.denodeify(fs.mkdir)

class VsacCodeService
  constructor: (user,password,ticketUrl,apiUrl, valueSets = []) ->
    @username = user
    @password= password
    @ticketUrl = ticketUrl
    @apiUrl = apiUrl
    @cache_dir
    #leave this for preloading cached valuesets
    @valueSets = {}
    @loadAttempted = []
    for i of valueSets
      @valueSets[i.oid] = retrieveValueset(i.oid,i.version)

  findValueSetsByOid: (oid) ->
    (valueSet for version, valueSet of @valueSets[oid])

  findValueSet: (oid, version) ->
    if version?
      @valueSets[oid]?[version]
    else
      results = @findValueSetsByOid(oid)
      if results.length is 0 then null else results.reduce (a, b) -> if a.version > b.version then a else b

  loadValuesets: (oids,effectiveDate)  ->
    for oid in oids
      @loadValueset(oid,effectiveDate)
  
  loadValueset: (oid,effectiveDate) ->
    self = @
    name = @cachedName(oid)
    fs.exists(name, (cached) ->
      if cached  
        self.loadCached(oid)
      else  
        self.loadFromVsac(oid,effectiveDate)
        )

  retrieveValueset: (oid,effective_date) ->
    self = @
    return new Promise( (accept,reject) ->
      self.get_ticket().then((ticket) ->
        params = {"id" : oid, "ticket" : ticket}
        params["effectiveDate"] = effective_date if effective_date
        params["includeDraft"] = 'yes' if self.include_draft
        requestp.get({url: self.apiUrl, qs : params}).then(accept).catch(reject)
        )
      ) 

  loadFromVsac: (oid,effective_date) ->
    self = @
    @retrieveValueset(oid,effective_date).done((data) ->
      codes  = self.parseXml(data)
      vs = new ValueSet(oid,effective_date,codes)
      self.valueSets[oid] = vs
      self.cache vs
      )
      
  loadCached: (oid) ->
    name = @cachedName(oid)
    self = @
    fs.exists(name, (cached) ->
      if cached
        fs.readFile(name).then((data) ->
          json = JSON.parse(data)
          self.valueSets[oid] = new ValueSet(oid,json.version, new Code(c) for c in json.codes)
          ).catch(console.log)
        )
  
  cache: (vs) ->
    self = @
    if @cache_dir 
      fs.exists(@cache_dir, (exist) ->
        if !exist
          fs.mkdir(self.cache_dir).then ->
            fs.writeFile(self.cachedName(vs.oid),JSON.stringify(vs))
        else 
          fs.writeFile(self.cachedName(vs.oid),JSON.stringify(vs))
        )

  cachedName:(oid) ->
     name = @cache_dir+"/"+oid+".js"

  parseXml: (data) ->
    console.log(data)
    doc = new dom().parseFromString(data)
    select = xpath.useNamespaces({"vs":"urn:ihe:iti:svs:2008"})
    vs_element = select("/vs:RetrieveValueSetResponse/vs:ValueSet",doc) 
    cons = select("//vs:Concept", doc)
    concepts = for c in cons
      new Code(c.getAttribute("code"),c.getAttribute("codeSystem"),c.getAttribute("codeSystemVersion"))
    # func(null,concepts)
  get_ticket: ->
    self = @
    new Promise( (accept,reject) ->
      self.get_proxy_ticket().then (pt) ->
        params =  {url: self.ticketUrl + "/" + pt ,form:{service: "http://umlsks.nlm.nih.gov"}}
        requestp.post(params).then(accept).catch(reject)
      )

  get_proxy_ticket: ->
    self = @
    params = {url: @ticketUrl , form: {username: @username ,password: @password}}
    new Promise( (accept,reject) ->
      if self.proxy_ticket
        accept(self.proxy_ticket)
      else  
        requestp.post(params).then((body) ->
          self.proxy_ticket = body 
          accept(self.proxy_ticket)
          ).catch(reject)
        )     
module.exports.CodeService = VsacCodeService