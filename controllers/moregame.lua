--[[
  -- @File:         moregame.lua
  -- @Aim:          更多游戏配置接口 
  -- @Author:       Foyon
  -- @Created Time: 2013-12-30 15:41:12
]]--

local controller  = require "components.controller"
local moregame = class("moregame", controller) 

function moregame:ctor(t)
    local self = controller:ctor(t)
    setmetatable(self, moregame)
    return self
end

function moregame:testself()
    self:testson()
    return self.CJSON.encode(self.CONFIG.redis_match)
end

function moregame:testson()
    ngx.say(self.CJSON.encode({foyon="test"}))
end

function moregame:test()
     
    self:showError({code=self.JJ_APP_ERROR,msg="test"})
    controller:test()
    local t = self.CONFIG.redis_match
    ngx.say(t.host)
    --self.CONFIG.redis_match = nil
    ngx.say(self:testself())
    self:commonRender({{yes=true}})
end

return moregam
