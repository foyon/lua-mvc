--[[
  -- @File:         config_product.lua
  -- @Aim:          class of config，production
  -- @Author:       Foyon
  -- @Created Time: 2014-01-02 15:44:48
]]--

local config_pro = {}

config_pro.gameimg_url = 'http://img.test.cn/img/'
---------------------------------redis------------------------------------------
config_pro.redis_match = {host = '127.0.0.1', port = 6380, database = 15}
config_pro.redis_community =
    {host = '127.0.0.1', port = 6379, database = 15}
config_pro.redis_interface = 
    {host = '127.0.0.1', port = 6384, database = 15}

return config_pro
