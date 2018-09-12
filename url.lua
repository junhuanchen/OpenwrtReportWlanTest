
function string_split(str, delimiter)
 if str == nil or str == '' or delimiter == nil then
  return nil
 end
 
    local result = {}
    for match in (str..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match)
    end
    return result
end

local hashids = (loadfile "hashids.lua")()

local h = hashids.new("rtrpsalt", 24);
-- local id = h:encode(0x99, 0x43, 0xd2, 0x0b, 0x51, 0x0b);

local OBJDEF = {}
function OBJDEF.get(self, macAddr, Rx, Tx, ApRSSI)

    -- print(macAddr, Rx, Tx, ApRSSI)
    
    -- print(macAddr)
    
    local mac = string_split(macAddr, ":")
    
    -- print(tonumber(mac[1], 16), tonumber(mac[2], 16), tonumber(mac[3], 16), tonumber(mac[4], 16), tonumber(mac[5], 16), tonumber(mac[6], 16))
    
    local shashKey = h:encode(tonumber(mac[1], 16), tonumber(mac[2], 16), tonumber(mac[3], 16), tonumber(mac[4], 16), tonumber(mac[5], 16), tonumber(mac[6], 16))
    
    -- print(shashKey)
    
    return string.format("http://devicereg.webduino.com.cn/device/routereport?macAddr=%s&ApRSSI=%s&Tx=%s&Rx=%shashKey=%s", string.gsub(macAddr, ":", ""), ApRSSI, Rx, Tx, shashKey)
    
end
return OBJDEF
