local speed = "0 mp/h"
local seatbeltOn = false
local cruiseOn = false
local radarActive = false
local bleedingPercentage = 0
local hunger = 100
local thirst = 100
local oxygen = 100
local stamina = 100
local cashAmount = 0
local isLoggedIn = false -- Set to true to debug
local Player = nil
local extraInfo = QBHud.ExtraInfo
local showHud = false

local fasttick = 300
local slowtick = 1000

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if IsPedInAnyVehicle(PlayerPedId()) and seatbeltOn then
            DisableControlAction(0, 75, true) -- Disable exit vehicle when stop
            DisableControlAction(27, 75, true) -- Disable exit vehicle when Driving
        else
            seatbeltOn = false
            Citizen.Wait(1000)
        end
    end
end)

RegisterNetEvent("QBCore:Client:OnPlayerUnload")
AddEventHandler("QBCore:Client:OnPlayerUnload", function()
    isLoggedIn = false
    showHud = false
    SendNUIMessage({action = "hudstatus", UI = showHud})
end)

RegisterNetEvent("QBCore:Client:OnPlayerLoaded")
AddEventHandler("QBCore:Client:OnPlayerLoaded", function()
    isLoggedIn = true
    showHud = true
    SendNUIMessage({action = "hudstatus", UI = showHud})
end)


function CalculateTimeToDisplay()
	hour = GetClockHours()
    minute = GetClockMinutes()
    
    local obj = {}
    
	if minute <= 9 then
		minute = "0" .. minute
    end
    
    obj.hour = hour
    obj.minute = minute

    return obj
end

Citizen.CreateThread(function()
    while true do 
        if isLoggedIn then
            QBCore.Functions.GetPlayerData(function(PlayerData)
                if PlayerData ~= nil and PlayerData.money ~= nil then
                    cashAmount = PlayerData.money["cash"]
                end
            end)

            local pos = GetEntityCoords(PlayerPedId())
            local time = CalculateTimeToDisplay()
            local street1, street2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
            local fuel = exports['LegacyFuel']:GetFuel(GetVehiclePedIsIn(PlayerPedId()))
            local radioStatus = exports["rp-radio"]:IsRadioOn()

            SendNUIMessage({
                action = "radio_status",
                radio = radioStatus
            })
        
            SendNUIMessage({
                action = "slowhudtick",
                show = IsPauseMenuActive(),
                money = cashAmount,
                playerid = GetPlayerServerId(PlayerId()),
                street1 = GetStreetNameFromHashKey(street1),
                street2 = GetStreetNameFromHashKey(street2),
                fuel = fuel,
                time = time
            })
            Citizen.Wait(slowtick)
        else
            Citizen.Wait(500)
        end
    end
end)

Citizen.CreateThread(function()
    while true do 
        if isLoggedIn then
            if QBHud.MPH then
                speed = math.ceil(GetEntitySpeed(GetVehiclePedIsIn(PlayerPedId(), false)) * 2.23694)
            else
                speed = math.ceil(GetEntitySpeed(GetVehiclePedIsIn(PlayerPedId(), false)) * 3.6)
            end

            if speed < 10 then
                speed = "00" .. speed
            elseif speed < 100 then
                speed = "0" .. speed
            end
            
            if QBHud.MPH then
                speed = speed .. " MPH"
            else
                speed = speed .. " KMH"
            end
            
            local oxygen = GetPlayerUnderwaterTimeRemaining(PlayerId()) * 10
            local stamina = 100 - GetPlayerSprintStaminaRemaining(PlayerId())
            local isTalking = NetworkIsPlayerTalking(PlayerId())
            local voicedata = LocalPlayer.state["proximity"].distance
            
            SendNUIMessage({
                action = "voice_level", 
                voicelevel = voicedata
            })
        
            SendNUIMessage({
                action = "fasthudtick",
                show = IsPauseMenuActive(),
                health = GetEntityHealth(PlayerPedId()),
                armor = GetPedArmour(PlayerPedId()),
                thirst = thirst,
                hunger = hunger,
                bleeding = bleedingPercentage,
                oxygen = oxygen,
                stamina = stamina,
                direction = GetDirectionText(GetEntityHeading(PlayerPedId())),
                speed = speed,
                talking = isTalking
            })
            Citizen.Wait(fasttick)
        else
            Citizen.Wait(500)
        end
    end
end)

Citizen.CreateThread(function()
    Citizen.Wait(1000)
    SendNUIMessage({
        action = "extras",
        extra = extraInfo,
    })
end)

Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(1000)
        if IsPedInAnyVehicle(PlayerPedId()) then
            DisplayRadar(true)
            SendNUIMessage({
                action = "car",
                show = true,
            })
            radarActive = true
        else
            DisplayRadar(false)
            SendNUIMessage({
                action = "car",
                show = false,
            })
            seatbeltOn = false
            cruiseOn = false

            SendNUIMessage({
                action = "seatbelt",
                seatbelt = seatbeltOn,
            })

            SendNUIMessage({
                action = "cruise",
                cruise = cruiseOn,
            })
            radarActive = false
        end
    end
end)

RegisterNetEvent("hud:client:UpdateNeeds")
AddEventHandler("hud:client:UpdateNeeds", function(newHunger, newThirst)
    hunger = newHunger
    thirst = newThirst
end)

Citizen.CreateThread(function()
    while true do
        if isLoggedIn then
            QBCore.Functions.TriggerCallback('hospital:GetPlayerBleeding', function(playerBleeding)
                if playerBleeding == 0 then
                    bleedingPercentage = 0
                elseif playerBleeding == 1 then
                    bleedingPercentage = 25
                elseif playerBleeding == 2 then
                    bleedingPercentage = 50
                elseif playerBleeding == 3 then
                    bleedingPercentage = 75
                elseif playerBleeding == 4 then
                    bleedingPercentage = 100
                end
            end)
        end

        Citizen.Wait(2500)
    end
end)

RegisterCommand('toggleseatbelt', function(source, args, rawCommand)
    if IsPedInAnyVehicle(PlayerPedId(), false) then
        local class = GetVehicleClass(GetVehiclePedIsIn(PlayerPedId()))
        if class ~= 8 and class ~= 13 and class ~= 14 then
            toggleSeatbelt(true)
        end
    end
end, false)

RegisterCommand('togglecruise', function(source, args, rawCommand)
    if IsPedInAnyVehicle(PlayerPedId(), false) and IsDriver() then
        local class = GetVehicleClass(GetVehiclePedIsIn(PlayerPedId()))
        if class ~= 8 and class ~= 13 and class ~= 14 then
            Player = PlayerPedId()
            TriggerCruiseControl()
        end
    end
end, false)

RegisterCommand('togglehud', function(source, args, rawCommand)
    if showHud then
        showHud = false
        SendNUIMessage({action = "hudstatus", UI = showHud})
    else
        showHud = true
        SendNUIMessage({action = "hudstatus", UI = showHud})
    end
end, false)

RegisterCommand('togglehudextra', function(source, args, rawCommand)
    if extraInfo then
        extraInfo = false
        SendNUIMessage({action = "extras", extra = extraInfo})
    else
        extraInfo = true
        SendNUIMessage({action = "extras", extra = extraInfo})
    end
end, false)

function toggleSeatbelt(makeSound, toggle)
    if toggle == nil then
        if seatbeltOn then
            playSound("unbuckle")
            SetFlyThroughWindscreenParams(QBHud.ejectVelocity, QBHud.unknownEjectVelocity, QBHud.unknownModifier, QBHud.minDamage)
        else
            playSound("buckle")
            SetFlyThroughWindscreenParams(10000.0, 10000.0, 17.0, 500.0);
        end
        seatbeltOn = not seatbeltOn
    else
        if toggle then
            playSound("buckle")
            SetFlyThroughWindscreenParams(10000.0, 10000.0, 17.0, 500.0);
        else
            playSound("unbuckle")
            SetFlyThroughWindscreenParams(QBHud.ejectVelocity, QBHud.unknownEjectVelocity, QBHud.unknownModifier, QBHud.minDamage)
        end
        seatbeltOn = toggle
    end

    SendNUIMessage({
        action = "seatbelt",
        seatbelt = seatbeltOn,
    })
end

function playSound(action)
    if QBHud.playSound then
        if QBHud.playSoundForPassengers then
            local veh = GetVehiclePedIsUsing(ped)
            local maxpeds = GetVehicleMaxNumberOfPassengers(veh) - 2
            local passengers = {}
            for i = -1, maxpeds do
                if not IsVehicleSeatFree(veh, i) then
                    local ped = GetPlayerServerId( NetworkGetPlayerIndexFromPed(GetPedInVehicleSeat(veh, i)) )
                    table.insert(passengers, ped)
                end
            end
            TriggerServerEvent('seatbelt:server:PlaySound', action, json.encode(passengers))
        else
            SendNUIMessage({type = action, volume = QBHud.volume})
        end
    end
end

function TriggerCruiseControl ()
    if cruiseOn then
        cruiseOn = false
        CruisedSpeed = 0
        QBCore.Functions.Notify("Cruise Deactivated", "error")
        SendNUIMessage({
            action = "cruise",
            cruise = cruiseOn,
        })
        Wait(2000)
    else
        cruiseOn = true
        if CruisedSpeed == 0 and IsDriving() then
            if GetVehiculeSpeed() > 0 and GetVehicleCurrentGear(GetVehicle()) > 0  then
                CruisedSpeed = GetVehiculeSpeed()

                if QBHud.MPH then
                    CruisedSpeedMph = TransformToMph(CruisedSpeed)
                    QBCore.Functions.Notify("Cruise Activated: " .. CruisedSpeedMph ..  " MP/H")
                else
                    CruisedSpeedKm = TransformToKm(CruisedSpeed)
                    QBCore.Functions.Notify("Cruise Activated: " .. CruisedSpeedKm ..  " km/h") -- Uncomment me for km/h
                end
                
                SendNUIMessage({
                    action = "cruise",
                    cruise = cruiseOn,
                })

                Citizen.CreateThread(function ()
                    while CruisedSpeed > 0 and IsInVehicle() == Player do
                        Wait(0)
                        
                        if not IsTurningOrHandBraking() and GetVehiculeSpeed() < (CruisedSpeed - 1.5) then
                            CruisedSpeed = 0
                            cruiseOn = false
                            QBCore.Functions.Notify("Cruise Deactivated", "error")
                            SendNUIMessage({
                                action = "cruise",
                                cruise = cruiseOn,
                            })
                            Wait(2000)
                            break
                        end
        
                        if not IsTurningOrHandBraking() and IsVehicleOnAllWheels(GetVehicle()) and GetVehiculeSpeed() < CruisedSpeed then
                            SetVehicleForwardSpeed(GetVehicle(), CruisedSpeed)
                        end
                
                        if IsControlJustPressed(2, 72) then
                            CruisedSpeed = 0
                            cruiseOn = false
                            QBCore.Functions.Notify("Cruise Deactivated", "error")
                            SendNUIMessage({
                                action = "cruise",
                                cruise = cruiseOn,
                            })
                            Wait(2000)
                            break
                        end
                    end
                end)
            end
        end

    end
end

function IsTurningOrHandBraking ()
    return IsControlPressed(2, 76) or IsControlPressed(2, 63) or IsControlPressed(2, 64)
end
  
function IsDriving ()
    return IsPedInAnyVehicle(Player, false)
end
  
function GetVehicle ()
    return GetVehiclePedIsIn(Player, false)
end
  
function IsInVehicle ()
    return GetPedInVehicleSeat(GetVehicle(), -1)
end
  
function IsDriver ()
    return GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), false), -1) == PlayerPedId()
end
  
function GetVehiculeSpeed ()
    return GetEntitySpeed(GetVehicle())
end
  
function TransformToKm (speed)
    return math.floor(speed * 3.6 + 0.5)
end
  
function TransformToMph (speed)
    return math.floor(speed * 2.2369 + 0.5)
end

function GetDirectionText(heading)
    if ((heading >= 0 and heading < 45) or (heading >= 315 and heading < 360)) then
        return "North"
    elseif (heading >= 45 and heading < 135) then
        return "South"
    elseif (heading >=135 and heading < 225) then
        return "East"
    elseif (heading >= 225 and heading < 315) then
        return "West"
    end
end

RegisterKeyMapping('toggleseatbelt', 'Toggle Seatbelt', 'keyboard', 'G')
RegisterKeyMapping('togglecruise', 'Toggle Cruise', 'keyboard', 'Y')
