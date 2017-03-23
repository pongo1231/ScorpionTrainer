RegisterNUICallback("weather", function(data, cb)
	local weather = data.action

	SetWeatherTypePersist(weather)
	SetWeatherTypeNowPersist(weather)
	SetWeatherTypeNow(weather)
	SetOverrideWeather(weather)

	drawNotification("~g~Weather changed to " .. weather .. ".")
	cb("ok")
end)

RegisterNUICallback("time", function(data, cb)
	local time = tonumber(data.action)

	NetworkOverrideClockTime(time, 0, 0)

	drawNotification("~g~Time changed to " .. time .. ":00.")
	cb("ok")
end)