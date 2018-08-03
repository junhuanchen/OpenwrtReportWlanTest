
local hashids = (loadfile "hashids.lua")()

local h = hashids.new("rtrpsalt", 24);
local id = h:encode(8, 0, 39, 182, 4, 161);

-- local numbers = h:decode(id);

print(id)
