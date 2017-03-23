local despawnable, showinput

local function _SetEntityAsNoLongerNeeded(entity)
	Citizen.InvokeNative(0xB736A491E64A32CF,Citizen.PointerValueIntInitialized(entity))
end

local function SpawnVehicle(model, x, y, z)
	if IsModelValid(model) then
		RequestModel(model)
		while not HasModelLoaded(model) do
			Wait(1)
		end
		local veh = CreateVehicle(model, x + 2.5, y + 2.5, z + 1, 0.0, true, true)
		if despawnable then
			_SetEntityAsNoLongerNeeded(veh)
		end

		drawNotification("~g~Vehicle spawned!")
	else
		drawNotification("~r~Invalid Model!")
	end
end

RegisterNUICallback("veh", function(data, cb)
	local playerPed = GetPlayerPed(-1)
	local playerVeh = GetVehiclePedIsIn(playerPed, false)
	local action = data.action

	if action == "fix" then
		if not playerVeh then
			drawNotification("~r~Not in a vehicle!")
			return
		end

		SetVehicleFixed(playerVeh)
		drawNotification("~g~Vehicle repaired.")
	elseif action == "clean" then
		if not playerVeh then
			drawNotification("~r~Not in a vehicle!")
			return
		end

		SetVehicleDirtLevel(playerVeh, 0.0)
		drawNotification("~g~Vehicle cleaned.")
	end

	cb("ok")
end)

RegisterNUICallback("vehspawn", function(data, cb)
	local playerPed = GetPlayerPed(-1)
	local x, y, z = table.unpack(GetEntityCoords(playerPed, true))

	if data.action == "despawn" then
		despawnable = data.newstate
		return
	elseif data.action == "input" then
		DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", "", "", "", "", 25)
		blockinput = true

		while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
			Wait(1)
		end

		local result = GetOnscreenKeyboardResult()
		if result then
			SpawnVehicle(GetHashKey(string.upper(result)), x, y, z)
		end

		blockinput = false
		return
	end

	local playerVeh = GetVehiclePedIsIn(playerPed, false)
	local vehhash = GetHashKey(data.action)

	SpawnVehicle(vehhash, x, y, z)

	cb("ok")
end)

RegisterNUICallback("vehcolor", function(data, cb)
	local playerPed = GetPlayerPed(-1)
	local playerVeh = GetVehiclePedIsIn(playerPed, false)
	local color = stringsplit(data.action, ",")
	local r = tonumber(color[1])
	local g = tonumber(color[2])
	local b = tonumber(color[3])

	if not playerVeh then
		drawNotification("~r~Not in a vehicle!")
		return
	end

	SetVehicleCustomPrimaryColour(playerVeh, r, g, b)
	SetVehicleCustomSecondaryColour(playerVeh, r, g, b)
	drawNotification("~g~Repainted vehicle!")

	cb("ok")
end)