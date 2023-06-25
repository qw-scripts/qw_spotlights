local utils = require 'client.utils'
ShowSpotLights = false
SpotLightData = {}

--#region Events
RegisterNetEvent("qw_spotlights:client:sync", function(data)
    SpotLightData = data
end)

RegisterNetEvent("qw_spotlights:client:newSpotlight", function() 
    utils.drawToCoords()
end)

RegisterNetEvent("qw_spotlights:client:remove", function() 
    if #SpotLightData == 0 then return end
    ShowSpotLights = not ShowSpotLights

    if not ShowSpotLights then
        lib.hideTextUI()
    else
        lib.showTextUI('[E] - Delete Closest', {
            position = "left-center",
        })
        while ShowSpotLights do
            local hit, _, coords, _, _ = lib.raycast.cam(1, 4, 10)
            
            local playerHeadCoords = GetPedBoneCoords(cache.ped, 31086, 0, 0, 0)
            DrawLine(playerHeadCoords.x, playerHeadCoords.y, playerHeadCoords.z, coords.x, coords.y, coords.z, 29, 21, 237, 255)
            DrawSphere(coords.x, coords.y, coords.z, 0.05, 29, 21, 237, 0.85)

            if hit then
                utils.drawAtClosestPoint(coords)
                if IsControlJustPressed(0, 38) then
                    local removed = utils.removeClosest(coords)
                    if removed then
                        lib.hideTextUI()
                        ShowSpotLights = false
                    end
                end
            end
        end
    end
end)
--#endregion


--#region event handlers

AddEventHandler('ox:playerLoaded', function(data)
    Wait(100)
    SpotLightData = lib.callback.await('qw_spotlights:getSpotlights', 100)
end)

--#endregion

--#region Threads
CreateThread(function()
    local wait = 1000

    while true do
        Wait(wait)
        if #SpotLightData > 0 then
            wait = 0
        else
            wait = 1000
        end
        for i = 1, #SpotLightData do
            local spotlight = SpotLightData[i]
            local color = spotlight.data.rgb
            DrawSpotLight(spotlight.initalCoords.x, spotlight.initalCoords.y, spotlight.initalCoords.z,
                spotlight.direction.x, spotlight.direction.y, spotlight.direction.z, math.floor(color.x), math.floor(color.y), math.floor(color.z), ToFloat(spotlight.data.distance),
                ToFloat(spotlight.data.brightness), ToFloat(spotlight.data.hardness), ToFloat(spotlight.data.radius), 1.0)
        end
    end
end)

CreateThread(function()
    while true do
        Wait(0)
        if ShowSpotLights then
            for i = 1, #SpotLightData do
                local spotlight = SpotLightData[i]
                DrawSphere(spotlight.initalCoords.x, spotlight.initalCoords.y, spotlight.initalCoords.z, 0.05, 29, 21, 237, 0.85)
            end
        end
    end
end)

--#endregion