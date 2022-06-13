local QBCore = exports['qb-core']:GetCoreObject()

local notifIn = false
local notifOut = true
local closestZone = 1
local OzelGuvenliBolge = false
local PlayerData = {}

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
	PlayerData = QBCore.Functions.GetPlayerData()
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
	PlayerData.job = JobInfo
end)

RegisterNetEvent('QBCore:Client:OnGangUpdate', function(GangInfo) -- this code is useless script just works with jobs but why not
	PlayerData.gang = GangInfo
end)

local zones = {  
	{ ['x'] = 309.89, ['y'] = -590.75, ['z'] = 43.0, ['r'] = 60.0 }, -- pillbox
	{ ['x'] = 1710.09, ['y'] = 2586.59, ['z'] = 45.09, ['r'] = 100.0 }, -- prison

}

CreateThread(function()
	while true do
		Wait(1000)
		if PlayerData.job then
			local playerPed = PlayerPedId()
			local x, y, z = table.unpack(GetEntityCoords(playerPed, true))
			local minDistance = 100
			for i = 1, #zones, 1 do
				dist = Vdist(zones[i].x, zones[i].y, zones[i].z, x, y, z)
				if dist < minDistance then
					minDistance = dist
					closestZone = i
					if PlayerData.job and PlayerData.job.name == "police" or PlayerData.job.name == "ambulance" then
						OzelGuvenliBolge = true
					else
						OzelGuvenliBolge = false
					end
				end
			end
		end
	end
end)

CreateThread(function()
	while true do
		Wait(1000)
		if PlayerData.job then
			local player = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(player, true))
			local dist = Vdist(zones[closestZone].x, zones[closestZone].y, zones[closestZone].z, x, y, z)
			if OzelGuvenliBolge then
				if dist <= zones[closestZone].r then
					if not notifIn then
						if PlayerData.job.name == "police" then
							isismi = "Police"
							QBCore.Functions.Notify(Lang:t('info.safezone_job', {isismi = isismi}), 'police')
						elseif PlayerData.job.name == "ambulance" then
							isismi = "EMS"
							QBCore.Functions.Notify(Lang:t('info.safezone_job', {isismi = isismi}), 'ambulance')
						end
						notifIn = true
						notifOut = false
					end
				else
					if not notifOut then
						NetworkSetFriendlyFireOption(true)
						QBCore.Functions.Notify(Lang:t('error.left_zone'), 'error')
						notifOut = true
						notifIn = false
					end
				end
			else
				if dist <= zones[closestZone].r then  
					if not notifIn then																			
						SetCurrentPedWeapon(player,`WEAPON_UNARMED`,true)
						QBCore.Functions.Notify(Lang:t('success.enter_zone'), 'success')
						notifIn = true
						notifOut = false
					end
				else
					if not notifOut then
						NetworkSetFriendlyFireOption(true)
						QBCore.Functions.Notify(Lang:t('error.left_zone'), 'error')
						notifOut = true
						notifIn = false
					end
				end
			end
		end
	end
end)

CreateThread(function()
	while true do
		local time = 1000
		if notifIn and not OzelGuvenliBolge then
			time = 1
			DisableControlAction(2, 37, true)
			DisablePlayerFiring(player,true)
			DisableControlAction(0, 106, true)
			DisableControlAction(0, 140, true)
			DisableControlAction(0, 80, true)
			if IsDisabledControlJustPressed(0, 157) or IsDisabledControlJustPressed(0, 158) or IsDisabledControlJustPressed(0, 160) or IsDisabledControlJustPressed(0, 164) or IsDisabledControlJustPressed(0, 165) then
				Wait(time)
				SetCurrentPedWeapon(player,`WEAPON_UNARMED`,true)
				--QBCore.Functions.Notify(Lang:t('error.cant_use'), 'error')
			end

			if IsDisabledControlJustPressed(2, 37) then --if Tab is pressed, send error message
				SetCurrentPedWeapon(player,`WEAPON_UNARMED`,true)
				--QBCore.Functions.Notify(Lang:t('error.cant_use'), 'error')
			end
			if IsDisabledControlJustPressed(0, 106) then --if LeftClick is pressed, send error message
				SetCurrentPedWeapon(player,`WEAPON_UNARMED`,true)
				QBCore.Functions.Notify(Lang:t('error.cant_do'), 'error')
			end
		end
		Wait(time)
	end
end)