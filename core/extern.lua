--[[
  -- @File:         extern.lua
  -- @Aim:          global function, all can use it before require it   
  -- @Author:       Foyon
  -- @Created Time: 2013-12-31 11:15:16
]]--

--Create an class.
--@classname | class name
--@super     | extend class,parent class
function class(classname, super)--{{{

    local superType = type(super)
    local cls

    if superType ~= "function" and superType ~= "table" then
        superType = nil
        super = nil
    end

    if superType == "function" or (super and super.__ctype == 1) then
        -- inherited from native C++ Object
        cls = {}

        if superType == "table" then
            -- copy fields from super
            for k,v in pairs(super) do cls[k] = v end
            cls.__create = super.__create
            cls.super    = super
        else
            cls.__create = super
        end

        cls.ctor    = function() end
        cls.__cname = classname
        cls.__ctype = 1

        function cls.new(...)
            local instance = cls.__create(...)
            -- copy fields from class to native object
            for k,v in pairs(cls) do instance[k] = v end
            instance.class = cls
            instance:ctor(...)
            return instance
        end

    else
        -- inherited from Lua Object
        --ngx.print("exec 2")
        if super then
            --cls = clone(super)
            --cls.super = super
            cls = {}
            setmetatable(cls, {__index = super})
            cls.super = super
        else
            cls = {ctor = function() end}
        end

        cls.__cname = classname
        cls.__ctype = 2 -- lua
        cls.__index = cls

        function cls.new(...)
            local instance = setmetatable({}, cls)
            instance.class = cls
            instance:ctor(...)
            return instance
        end
    end

    return cls
end
--}}}

--instance an object 
--@class | classname
--@param | {} or nil, construct param
--return the object
function new(class, param)--{{{
    local req = require(class).ctor(param)
    --local req = require(class)
    return req
end
--}}}

--to int
function int(sString)--{{{
    local iNum = tonumber(sString)
    iNum = ((iNum == nil) and tonumber(0)) or iNum
    return iNum
end
--}}}

--将字符串分割成数组，同php： explode
--separaor分隔符，szFullString 需要被分割的字符串
function explode(szSeparator,szFullString)  --{{{
    local nFindStartIndex = 1  
    local nSplitIndex = 1  
    local nSplitArray = {}  
    while true do  
        local nFindLastIndex 
              = string.find(szFullString, szSeparator, nFindStartIndex)  
        if not nFindLastIndex then  
            nSplitArray[nSplitIndex]
            = string.sub(szFullString, nFindStartIndex, string.len(szFullString))  
            break  
        end  
        nSplitArray[nSplitIndex] 
            = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)  
        nFindStartIndex = nFindLastIndex + string.len(szSeparator)  
        nSplitIndex = nSplitIndex + 1  
    end  
    return nSplitArray  
end  
--}}}

--将日期转换为时间戳，date(Y-m-d H:i:s)
--同php strtotime，只支持 1970-01-01 08:00:00 格式
--返回时间戳
function strtotime(sDate)--{{{
    local iTime = 0
    if 0 == string.len(sDate) then 
        return iTime
    end
    local sDateymd = string.sub(sDate, 1, 10)
    local sDatehis = string.sub(sDate, 12, -1)
    local aDateymd = FUNC.explode('-', sDateymd)
    local aDatehis = FUNC.explode(':', sDatehis)
    local Y,m,d = aDateymd[1], aDateymd[2], aDateymd[3]
    local H,i,s = aDatehis[1], aDatehis[2], aDatehis[3]
    iTime = os.time({year=Y, month=m, day=d, hour=H, min=i,sec=s})
    return iTime
end
--}}}

--bool in_array ( mixed $needle , array $haystack  )
--在 haystack 中搜索 needle，如果找到则返回 TRUE，否则返回 FALSE。 
function in_array(needle, haystack)--{{{
    local res = false
    local typeNeed = type(needle)
    local newArr = {}
    for k,v in pairs(haystack) do
        if typeNeed == "number" then
            if needle == int(v) then 
                res = true
                break
            end 
        else 
            if needle == v then
                res = true
                break
            end
        end
    end
    return res
    end
--}}}

--@_t | table, func serialize, table to string
--return string
-- unserialize use func loadstring
function serialize(_t)  --{{{
    local szRet = "{"  
    function doT2S(_i, _v)  
        --ngx.say(_v)
        if "number" == type(_i) then  
            szRet = szRet .. "[" .. _i .. "] = "  
            if "number" == type(_v) then  
                szRet = szRet .. _v .. ","  
            elseif "string" == type(_v) then  
                szRet = szRet .. '"' .. _v .. '"' .. ","  
            elseif "table" == type(_v) then  
                szRet = szRet .. serialize(_v) .. ","  
            else  
                szRet = szRet .. "nil,"  
            end  
        elseif "string" == type(_i) then  
            szRet = szRet .. '["' .. _i .. '"] = '  
            if "number" == type(_v) then  
                szRet = szRet .. _v .. ","  
            elseif "string" == type(_v) then  
                szRet = szRet .. '"' .. _v .. '"' .. ","  
            elseif "table" == type(_v) then  
                szRet = szRet .. serialize(_v) .. ","  
            else  
                szRet = szRet .. "nil,"  
            end  
        end  
    end  
    table.foreach(_t, doT2S)  
    szRet = szRet .. "}"  
    return szRet  
end  
--}}}

--------------------- 以下函数，项目暂时未启用----------------------------------


function schedule(node, callback, delay)--{{{
    local delay = CCDelayTime:create(delay)
    local callfunc = CCCallFunc:create(callback)
    local sequence = CCSequence:createWithTwoActions(delay, callfunc)
    local action = CCRepeatForever:create(sequence)
    node:runAction(action)
    return action
end
--}}}
function performWithDelay(node, callback, delay)--{{{
    local delay = CCDelayTime:create(delay)
    local callfunc = CCCallFunc:create(callback)
    local sequence = CCSequence:createWithTwoActions(delay, callfunc)
    node:runAction(sequence)
    return sequence
end
--}}}

