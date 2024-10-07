util.AddNetworkString("FlameEconomy.Message")

function FlameEconomy.Message(ply, message)
    net.Start("FlameEconomy.Message")
    net.WriteString(message)
    net.Send(ply)
end

local function CreateStorage()
    local Storage = ents.Create("flame_storage")
    Storage:SetPos()
    Storage:SetAngles()
    Storage:Spawn()

    FlameEconomy.Storage = Storage
end

hook.Add("PostCleanupMap", "FlameEconomy.CleanUPReset", function()
    CreateStorage()
end)

hook.Add("InitPostEntity", "FlameEconomy.SpawnStorage", function()
    CreateStorage()
end)