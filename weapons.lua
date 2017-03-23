RegisterNUICallback("wepgive", function(data, cb)
	local playerPed = GetPlayerPed(-1)
	local weapon = data.action

	GiveWeaponToPed(playerPed, GetHashKey(weapon), 9999, true, true)

	cb("ok")
end)

RegisterNUICallback("wepremove", function(data, cb)
	local playerPed = GetPlayerPed(-1)
	local weapon = data.action

	RemoveWeaponFromPed(playerPed, GetHashKey(weapon))
	
	cb("ok")
end)