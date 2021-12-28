local QBCore = exports['qb-core']:GetCoreObject()
local LoginSafe, Cam = nil, false
local spawns = {
    [1] = {coords = vector3(282.60, -619.21, 42.020), label = "Motel & Hastane"},
	[2] = {coords = vector3(1811.14, 3677.75, 34.27), label = "Sandy Shores"},
    [3] = {coords = vector3(-1833.96, -1223.5, 13.02), label = "Santa Monica İskelesi"},
    [4] = {coords = vector3(949.94, 117.59, 80.75), label = "Diamond Casino"},
    [5] = {coords = vector3(145.62, 6563.19, 32.0), label = "Paleto Gaz İstasyonu"},
    [6] = {coords = vector3(477.981, -976.46, 27.98), label = "Mission Row PD"},
	[7] = {coords = vector3(-104.77, -1093.01, 26.12), label = "Galeri & Çekilmiş"},
	[8] = {coords = vector3(1852.95, 2585.95, 45.67), label = "Hapishane"},
}

RegisterCommand('stest', function()
	TriggerEvent('qy-spawn:opennui')
end)

RegisterNetEvent("qy-spawn:opennui")
AddEventHandler("qy-spawn:opennui", function(pos)
	DoScreenFadeIn(500)
    local playerPed = PlayerPedId()
    SendNUIMessage({ data = spawns, lastpos = pos })
    openCam()
    SetNuiFocus(true, true)
end)

RegisterNUICallback("close", function(data)
    SetNuiFocus(false, false)
    Cam = false
	DoScreenFadeOut(1000)
end)

RegisterNUICallback("spawn", function(data)
    DoScreenFadeOut(1000)
    SetNuiFocus(false, false)
    TriggerEvent("qy-spawn:client:loadplayer", data.coords)
end)

RegisterNUICallback('sonkonum', function(data, cb)
    DoScreenFadeOut(500)
    SetNuiFocus(false, false)
    QBCore.Functions.GetPlayerData(function(PlayerData) 
        TriggerEvent("qy-spawn:client:loadplayer", PlayerData.position)
    end)
end)

RegisterNetEvent("qy-spawn:client:loadplayer")
AddEventHandler("qy-spawn:client:loadplayer", function(coords)
    delCam()
    doCamera(coords.x,coords.y,coords.z)
    DoScreenFadeOut(2)

	delCam()
    SetEntityCoords(PlayerPedId(),coords.x,coords.y,coords.z)
    SetEntityHeading(PlayerPedId(),coords.w)
    SetEntityVisible(PlayerPedId(), true)
    Wait(200)

    DoScreenFadeIn(2500) -- Karakter Yükleme
    TriggerServerEvent('QBCore:Server:OnPlayerLoaded')
    TriggerEvent('QBCore:Client:OnPlayerLoaded')
	TriggerEvent('gr-ambulance:check-death')
end)

function delCam()
    ClearFocus()
	DestroyAllCams(true)
	RenderScriptCams(false, true, 1, true, true)
end

function openCam()
	LoginSafe = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
	local camCoords = {-3968.85, 2015.93, 502.22}
	SetCamRot(LoginSafe, -90.0, 0.0, 250.0, 2)
	SetCamCoord(LoginSafe, camCoords[1], camCoords[2], camCoords[3])
	StopCamShaking(LoginSafe, true)
	SetCamFov(LoginSafe, 50.0)
	SetCamActive(LoginSafe, true)
	RenderScriptCams(true, false, 0, true, true)
end

cam = 0
function doCamera(x,y,z)
	DoScreenFadeOut(1)
	if(not DoesCamExist(cam)) then
		cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
	end

	i = 3200
	SetFocusArea(x, y, z, 0.0, 0.0, 0.0)
	SetCamActive(cam,  true)
	RenderScriptCams(true,  false,  0,  true,  true)
	DoScreenFadeIn(1500)
	local camAngle = -90.0
	while i > 1 do
		local factor = i / 50
		if i < 1 then i = 1 end
		i = i - factor
		SetCamCoord(cam, x,y,z+i)
		if i < 1200 then
			DoScreenFadeIn(600)
		end
		if i < 90.0 then
			camAngle = i - i - i
		end
		SetCamRot(cam, camAngle, 0.0, 0.0)
		Citizen.Wait(2/i)
	end
end
