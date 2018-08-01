
JSON = (loadfile "JSON.lua")() -- one-time load of the routines

DevTable = {}

report_data = string.format("wifi_report_%s.data", os.date("%Y-%m-%d"))

report_temp = string.format("wifi_report_%s.temp", os.date("%Y-%m-%d"))

function view_table(table)
	print('view_table')
	for k, v in pairs(table) do
		print(k)
		for i, data in pairs(v) do
			print(i, data)
		end
	end
end

--[[ shell cmd return data --]]
function shell(cmd)
	print('shell', cmd)
	local t= io.popen(cmd)
	return t:read("*all")
end

--[[ get shell cmd clients data --]]
function get_iw_clients(iw_data)
	print('get_iw_clients') -- , iw_data)
	for sta in string.gmatch(iw_data, 'Station [^%.]+') do
		-- print('\n Station \n', sta, '\n View \n') 
	
		start, stop, sta_mac = string.find(sta, "Station ([^%.]+) %(on")
		start, stop, rx_bytes = string.find(sta, "rx bytes:[%s]+([%d]+)", stop)
		start, stop, tx_bytes = string.find(sta, "tx bytes:[%s]+([%d]+)", stop)
		start, stop, signal_avg = string.find(sta, "signal avg:([^%.]+)%[", stop)
	
		-- print('\n sta_mac ', sta_mac, ' addr\n') 
		-- print('\n rx_bytes ', rx_bytes, ' bytes\n') 
		-- print('\n tx_bytes ', tx_bytes, ' bytes\n') 
		-- print('\n signal avg ', signal_avg, ' dBm \n')
	
		DevTable[sta_mac] = { true, tonumber(rx_bytes), tonumber(tx_bytes), tonumber(signal_avg), os.date('%Y-%m-%d %H:%M:%S') }

	end
end

function load_dev_table()
	print('load_dev_table')
	local file = io.open(report_temp, "a+")
	local data = file:read()
	if data ~= nil
	then
		DevTable = JSON:decode(data);
	end
	file:close()
end

function save_dev_table()
	print('save_dev_table')
	local file = io.open(report_temp, "w")
	file:write(JSON:encode(DevTable))
	file:close()
end

function reset_dev_table()
	print('reset_dev_table')
	for k, v in pairs(DevTable) do
		v[1] = false
	end
end

function ouput_dev_table()
	print('ouput_dev_table')
	for k, v in pairs(DevTable) do
		if(v[1] == false) -- false is disconnect, so ouput file
		then
			file = io.open(report_data, "a")
			
			DevTable[k][1] = k
			
			file:write(JSON:encode(DevTable[k]))
			
			file:write('\n')
			
			file:close()
			
			DevTable[k] = nil
		end
	end
end

wlan_name = 'wlan0-1'

load_dev_table()

-- view_table(DevTable)

reset_dev_table()

-- view_table(DevTable)

get_iw_clients(shell(string.format('iw dev %s station dump', wlan_name)))

-- view_table(DevTable)

ouput_dev_table()

view_table(DevTable)

save_dev_table()

print(string.format('time %s\n', os.date('%X')))

