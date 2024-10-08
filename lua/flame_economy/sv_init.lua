util.AddNetworkString("FlameEconomy.Message")

function FlameEconomy:Message(ply, message)
    net.Start("FlameEconomy.Message")
    net.WriteString(message)
    if istable(ply) then
        local filter = RecipientFilter()
        
        for k, v in ipairs(ply) do
            filter:AddPlayer(v)    
        end

        net.Send(filter)
    else
        net.Send(ply)
    end
    
end

local function CreateStorage()
    local Storage = ents.Create("flame_storage")
    Storage:SetPos(SpawnStoragePos)
    Storage:SetAngles(AngleStoragePos)
    Storage:Spawn()

    FlameEconomy.Storage = Storage
end

hook.Add("PostCleanupMap", "FlameEconomy.CleanUPReset", function()
    CreateStorage()
end)

hook.Add("InitPostEntity", "FlameEconomy.SpawnStorage", function()
    CreateStorage()
end)

FlameEconomy.