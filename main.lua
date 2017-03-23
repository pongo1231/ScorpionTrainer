local showtrainer = false

Citizen.CreateThread(function()
	while true do
		Wait(1)

		if IsControlJustReleased(1, 167) and not blockinput then -- f6
			if not showtrainer then
				showtrainer = true
				SendNUIMessage({
					showtrainer = true
				})
			else
				showtrainer = false
				SendNUIMessage({
					hidetrainer = true
				})
			end
		end

		if showtrainer and not blockinput then
			if IsControlJustReleased(1, 176) then -- enter
				SendNUIMessage({
					trainerenter = true
				})
			elseif IsControlJustReleased(1, 177) then -- back / right click
				SendNUIMessage({
					trainerback = true
				})
			end

			if IsControlJustReleased(1, 172) then -- up
				SendNUIMessage({
					trainerup = true
				})
			elseif IsControlJustReleased(1, 173) then -- down
				SendNUIMessage({
					trainerdown = true
				})
			end

			if IsControlJustReleased(1, 174) then -- left
				SendNUIMessage({
					trainerleft = true
				})
			elseif IsControlJustReleased(1, 175) then -- right
				SendNUIMessage({
					trainerright = true
				})
			end
		end
	end
end)

RegisterNUICallback("playsound", function(data, cb)
	PlaySoundFrontend(-1, data.name, "HUD_FRONTEND_DEFAULT_SOUNDSET",  true)

	cb("ok")
end)

RegisterNUICallback("trainerclose", function(data, cb)
	showtrainer = false

	cb("ok")
end)

function drawNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end

function stringsplit(inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            t[i] = str
            i = i + 1
    end
    return t
end