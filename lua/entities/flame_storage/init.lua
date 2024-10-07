AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
function ENT:Initialize()
    self:SetModel("models/props_interiors/BathTub01a.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    local physObj = self:GetPhysicsObject()
    if physObj:IsValid() then physObj:Wake() end
end

local ent_use = {
    [1] = function(ply, ent) end,
    [2] = function(ply, ent)
        if RPExtraTeams[ply:Team()].category ~= "Криминал" then
            DarkRP.notify(ply, 0, 4, "Вы не бандит!")
            return false
        end

        local count = 0
        for k, v in ipairs(player.GetAll()) do
            if v:IsWarMan() then count = count + 1 end
        end

        if count < 5 then DarkRP.notify(ply, 0, 4, "Необходимо минимум 5 военных") end
        ent:SetStatus(3)
        DarkRP.notifyAll(0, 4, "Началось ограбление военной части! Присоединяйтесь!")
    end,
    [3] = function(ply, ent) DarkRP.notify(ply, 0, 4, "Хранилище открывается, ожидайте!") end,
    [4] = function(ply, ent)
        local boxCount = ent:GetBoxCount()
        if boxCount > 0 then
            -- TODO: Функция выдачи предметов и наград.
            hook.Run("FlameEconomy.BanditTakeBox", ply)
            boxCount = boxCount - 1
            if boxCount < 1 then ent:SetStatus(5) end
        end
    end,
    [5] = function(ply, ent) DarkRP.notify(ply, 0, 4, "Ящики закончились! Уходите с военной базы.") end,
    [6] = function(ply, ent) end
}

function ENT:Use(ply)
    ent_use[self:GetStatus()]()
end

local think_status = {
    [1] = function(ent) if ent:CheckAvaible() then ent:SetStatus(2) end end,
    [2] = function(ent) if not ent:CheckAvaible() then ent:SetStatus(1) end end,
    [3] = function(ent)
        ent.StartTime = ent.StartTime or CurTime()
        if ent.StartTime > CurTime() + 120 then
            DarkRP.notifyAll(0, 4, "Хранилище военной базы было открыто бандитами!")
            ent:SetBoxCount(math.random(2, 5))
            ent:SetStatus(4)
            ent.StartTime = nil
        end
    end,
    [4] = function(ent) end,
    [5] = function(ent)
        ent.StartTime = ent.StartTime or CurTime()
        if ent.StartTime > CurTime() + 300 then ent:SetStatus(1) end
    end,
    [6] = function(ent)
        ent.StartTime = ent.StartTime or CurTime()
        if ent.StartTime > CurTime() + 300 then ent:SetStatus(1) end
    end
}

function ENT:Think()
    local status = self:GetStatus()
    think_status[status]()
end

function ENT:CanTool(ply, tr, toolname, tool, button)
    return false
end