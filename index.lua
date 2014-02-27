--[[
  -- @File:         index.lua
  -- @Aim:           
  -- @Author:       Foyon
  -- @Created Time: 2013-12-27 10:57:29
]]--

ngx.header.content_type = "text/plain"
ngx.req.read_body()


local args              = ngx.req.get_uri_args() 
local requestheader     = ngx.req.get_headers()
local contenttype       = requestheader["content-type"] 
                          or requestheader["Content-Type"]
contenttype  = string.sub(contenttype, 1, 20) 


local cjson  = require "cjson"
local redis  = require "resty.redis"
local extern = require "core.extern"
local config = require "config.config_dev" --|dev,pro same to the config file
local postdata, data  

--全局hand-table
local cycle = {} 
cycle.ENVIRONMENT = 'dev'  -- dev | pro
cycle.CJSON       = cjson
cycle.REDIS       = redis
cycle.CONFIG      = config
cycle.DEBUG       = false   -- ture or false

if contenttype == "multipart/form-data;" then
    local body_data = ngx.req.get_body_data()
    local datatmp = string.match(body_data, "(%{.*%})")
    postdata = cjson.decode(datatmp)
    data = datatmp
else  --默认当作    application/x-www-form-urlencoded处理
    local Pargs = ngx.req.get_post_args()

    for k,v in pairs(Pargs) do
        postdata = cjson.decode(k)
        data = v
    end
end

local filename = string.lower(postdata.class)
local funcname = string.lower(postdata.method)
local msgid = postdata.msgid

local request               = {}
      request.uid           = args.uid
      request.gameid        = args.gameid
      request.exp           = args.exp
      request.promoterid    = args.promoterid
      request.platform      = args.platform
      request.protocol      = args.protocol or "json"
      request.postdata      = postdata

cycle.REQUEST = request

local controller = 'controllers.'..filename
local req, err = pcall(require, controller) 


if not req then
    local basecontroller = 'components.controller'
    local baseclass = require(basecontroller).ctor(self, cycle)
    baseclass:showError({code = baseclass.JJ_PARAM_ERROR,
                         msg  = err})
    return
end

local req, err = require(controller).ctor(self, cycle)
local run, err = pcall(req[funcname], req)

if not run then
    req:showError({code = req.JJ_PARAM_ERROR, msg = err})
end

return
