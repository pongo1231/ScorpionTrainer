local godmode, stamina

RegisterNUICallback("player", function(data, cb)
	local playerPed = GetPlayerPed(-1)
	local action = data.action
	local newstate = data.newstate

	if action == "heal" then
		SetEntityHealth(playerPed, 200)
		drawNotification("~g~Player healed.")
	elseif action == "armor" then
		SetPedArmour(playerPed, 100)
		drawNotification("~g~Added armor to Player.")
	elseif action == "suicide" then
		SetEntityHealth(playerPed, 0)
		drawNotification("~g~Killed Player.")
	elseif action == "god" then
		godmode = newstate
	elseif action == "stamina" then
		stamina = newstate
	end

	cb("ok")
end)

RegisterNUICallback("playerskin", function(data, cb)
	local model = GetHashKey(data.action)
	RequestModel(model)
	while not HasModelLoaded(model) do
		Wait(1)
	end

	SetPlayerModel(PlayerId(), model)
	drawNotification("~g~Changed Player Model.")

	cb("ok")
end)

Citizen.CreateThread(function()
	while true do
		Wait(1)

		local playerPed = GetPlayerPed(-1)
		if playerPed then
			SetEntityInvincible(playerPed, godmode)

			if stamina then
				RestorePlayerStamina(PlayerId(), 1.0)
			end
		end
	end
end)