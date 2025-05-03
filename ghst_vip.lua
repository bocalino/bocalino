local QBCore = exports['qb-core']:GetCoreObject()

local VIPData = {}

local vipCars = {
    bronze = {"comet6"},
    silver = {"blista", "sultan"},
    gold = {"blista", "sultan", "buffalo"},
    platinum = {"blista", "sultan", "buffalo", "jugular", "paragon", "drafter"},
}

local vipPackages = {
    bronze = {cars = 1, money = 100000, coins = 10},
    silver = {cars = 2, money = 200000, coins = 20},
    gold = {cars = 3, money = 300000, coins = 30},
    platinum = {cars = 6, money = 500000, coins = 50},
}

RegisterCommand('giveghstvip', function(source, args)
    local src = source
    local targetId = tonumber(args[1])
    local vipType = tostring(args[2]):lower()

    local targetPlayer = QBCore.Functions.GetPlayer(targetId)
    if not targetPlayer then
        TriggerClientEvent("QBCore:Notify", src, "Jucătorul nu este online!", "error")
        return
    end

    local pack = vipPackages[vipType]
    if not pack then
        TriggerClientEvent("QBCore:Notify", src, "Tipul VIP este invalid!", "error")
        return
    end

    local identifier = targetPlayer.PlayerData.citizenid

    -- Salvăm local
    VIPData[identifier] = {
        vip = vipType,
        expire = os.time() + (30 * 86400)
    }

    exports.oxmysql:execute('REPLACE INTO ghst_vip_users (identifier, vip_package, expire_date, ghstcoins) VALUES (?, ?, ?, ?)',
    {identifier, vipType, os.time() + (30 * 86400), newCoins})

    -- Dăm bani
    targetPlayer.Functions.AddMoney("bank", pack.money)

    -- Dăm coins
    local currentCoins = targetPlayer.PlayerData.metadata["ghstcoins"] or 0
    local newCoins = currentCoins + pack.coins
    targetPlayer.Functions.SetMetaData("ghstcoins", newCoins)

    -- Update HUD coins (dacă folosești ghst_coinhud)
    TriggerClientEvent("ghst:updateCoinHud", targetPlayer.PlayerData.source, newCoins)

    -- Notificare
    TriggerClientEvent("QBCore:Notify", targetPlayer.PlayerData.source,
        "Ai primit pachetul VIP: " .. vipType:upper() .. " (" .. pack.coins .. " Coins & $" .. pack.money .. ")", "success"
    )
end, false)

RegisterCommand("vipcar", function(source, args)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    if not xPlayer then return end

    local cid = xPlayer.PlayerData.citizenid
    local vip = VIPData[cid]
    if not vip or os.time() > vip.expire then
        TriggerClientEvent("QBCore:Notify", src, "Nu ai un pachet VIP activ.", "error")
        return
    end

    local requestedModel = tostring(args[1]):lower()
    local allowed = false
    for _, m in pairs(vipCars[vip.vip] or {}) do
        if m == requestedModel then allowed = true break end
    end

    if not allowed then
        TriggerClientEvent("QBCore:Notify", src, "Această mașină nu e inclusă în pachetul tău VIP.", "error")
        return
    end

    TriggerClientEvent("ghst:spawnVipCar", src, requestedModel)
end)


AddEventHandler('QBCore:Server:PlayerLoaded', function(playerId)
    local Player = QBCore.Functions.GetPlayer(playerId)
    if not Player then return end
    local cid = Player.PlayerData.citizenid

    exports.oxmysql:fetch('SELECT * FROM ghst_vip_users WHERE identifier = ?', {cid}, function(result)
        if result[1] then
            VIPData[cid] = {
                vip = result[1].vip_package,
                expire = result[1].expire_date
            }
            -- Setăm și coins
            Player.Functions.SetMetaData("ghstcoins", result[1].ghstcoins or 0)
            TriggerClientEvent("ghst:updateCoinHud", playerId, result[1].ghstcoins or 0)
        end
    end)
end)
