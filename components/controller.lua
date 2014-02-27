--[[
  -- @File:         controller.lua
  -- @Aim:          base controller class 
  -- @Author:       Foyon
  -- @Created Time: 2013-12-30 14:10:42
]]--

local controller = class("controller") 

function controller:ctor(t)--{{{
    local self           = t
    setmetatable(self, controller)

    --全局配置属性
    self.JJ_PARAM_ERROR  = 100001
    self.JJ_SERVER_ERROR = 200001
    self.JJ_APP_ERROR    = 300001

    return self
end--}}}

function controller:showError(errorArr)--{{{
    local postdata = self.REQUEST.postdata
    local result = {error  = { code = errorArr.code,msg  = errorArr.msg},
                    msgid  = postdata.msgid,
                    class  = postdata.class,
                    method = postdata.method
                   } 
     ngx.print(self.CJSON.encode(result))
end
--}}}


function controller:test()
    ngx.print('parent succes exec')
end

function controller:commonRender(dataArr, attrArr)--{{{
    local postdata = self.REQUEST.postdata
    local protocol = self.REQUEST.protocol
    local data     = dataArr or {} 
    local attr     = attrArr or {}
    local result

    if not next(data) then
        data = nil
    end

    if protocol == 'json' then
        result = {datas  = data, attr = attr, 
                  msgid  = postdata.msgid,
                  class  = postdata.class,
                  method = postdata.method
                 }
    elseif protocol == 'lua' then
        if not data then
            result = {attr   = attr,
                      msgid  = postdata.msgid,
                      class  = postdata.class,
                      method = postdata.method
                     }
                     
        else
            result = {--datas  = serialize(data),
                      datas  = data,
                      attr   = attr,
                      msgid  = postdata.msgid,
                      class  = postdata.class,
                      method = postdata.method
                     }
        end
    end

    ngx.print(self.CJSON.encode(result))
end--}}}


--redis.keepalive
--source object oRedis, time_out sec
function controller:keepAlive(redis,time_out,pool_size)--{{{
    local ok, err = redis:set_keepalive(time_out,pool_size)
end--}}}

return controller
