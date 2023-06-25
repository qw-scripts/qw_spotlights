local utils = require 'client.utils'
local ShowSpotLights = false
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
    while true do
        local wait = #SpotLightData > 0 and 0 or 1000
            
        for i = 1, #SpotLightData do
            local spotlight = SpotLightData[i]
            local coords = spotlight.initalCoords
            local direction = spotlight.direction
            local data = spotlight.data
            local color = spotlight.data.rgb
            DrawSpotLight(coords.x, coords.y, coords.z, direction.x, direction.y, direction.z, math.floor(color.x), math.floor(color.y), math.floor(color.z), ToFloat(data.distance),
            ToFloat(data.brightness), ToFloat(data.hardness), ToFloat(data.radius), 1.0)
        end

        Wait(wait)
    end
end)

CreateThread(function()
    while true do
        Wait(0)
        if ShowSpotLights then
            for i = 1, #SpotLightData do
                local coords = SpotLightData[i].initalCoords
                DrawSphere(coords.x, coords.y, scoords.z, 0.05, 29, 21, 237, 0.85)
            end
        end
    end
end)

--#endregion
