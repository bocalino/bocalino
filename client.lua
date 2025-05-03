RegisterNetEvent("ghst:spawnVipCar", function(model)
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)

    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(100)
    end

    local vehicle = CreateVehicle(model, coords.x + 2.0, coords.y, coords.z, GetEntityHeading(playerPed), true, false)
    SetPedIntoVehicle(playerPed, vehicle, -1)
    SetVehicleNumberPlateText(vehicle, "GHSTVIP")
    SetEntityAsMissionEntity(vehicle, true, true)
end)
