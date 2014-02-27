--[[
  -- @File:         config_dev.lua
  -- @Aim:          config_dev class 
  -- @Author:       Foyon
  -- @Created Time: 2014-01-02 15:46:44
]]--

local config_dev = {}
config_dev.gameimg_url = 'http://127.0.0.1/img/' 
-------------------------------redis--------------------------------------------
config_dev.redis_settimeout       = 10000 --ms
config_dev.redis_keepalive        = {idle = 0,             size = 100   }
config_dev.redis_match            = {host = '127.0.0.1',     port = 6379}
config_dev.redis_community        = {host = '127.0.0.1', port = 6380}      
config_dev.redis_interface        = {host = '127.0.0.1', port = 6380}
return config_dev
