-- Устанавливает текущее количество денег в хранилище.
function FlameEconomy:SetMoney(ply, amount)
    hook.Run("FlameEconomy.SetMoney", ply, amount)
    FlameEconomy.Storage:SetMoneyAmount(amount)
end

-- Получает деньги, находящиеся в хранилище.
function FlameEconomy:GetMoney()
    return FlameEconomy.Storage:GetMoneyAmount()
end

-- Добавляет денежные средства в хранилище.
function FlameEconomy:AddMoney(ply, amount)
    local NewAmount = hook.Run("FlameEconomy.AddMoney", ply, amount)
    local CurrentMoney = FlameEconomy:GetMoney()
    FlameEconomy:SetMoney(CurrentMoney + NewAmount and NewAmount or amount)
end

-- Вызывает событие краха экономики.
function FlameEconomy:Default(ply)
    hook.Run("FlameEconomy.Default", ply)
    FlameEconomy:SetMoney(0)
end
