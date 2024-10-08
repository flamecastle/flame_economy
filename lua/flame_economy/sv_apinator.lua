
--[[
    Методы хранилища и базовое управление количеством денег.
]]
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
    FlameEconomy:SetMoney(5000)
end

--[[
    Баланс сил
    
    Баланс сил - это процентная шкала для регуляции баланса заработных плат.
    На значение текущего баланса сил умножаются доходы игроков.
    Баланс сил регулируется действиями игроков:
    1. Арест игрока;
    2. Убийство игрока наемным убийцей или смерть мэра;
    3. Успешная продажа нелегальных предметов;
    4. Успешность ограбления военной базы;
    5. "Решения" принятые мэром города;
    6. Изъятие нелегала и уничтожение нелегала.
    ...

    Баланс сил влияет:
    1. На стоимость покупки игровых предметов.
    2. На получаемый доход всеми игроками сервера. 
    3. Скорость ухода и прихода денежных средств в хранилище.

    Если баланс сил находится в отрицательном состоянии, хранилище может опустеть.
    Если баланс сил находится в положительном состоянии, мэр, может закупать улучшения для города.

    Мэр НЕ может редактировать налоговую ставку вручную.
]]

local Balance = 0

-- Получает текущее значение баланса сил
function FlameEconomy:GetBalance()
    return Balance
end

-- Устанавливает текущее значение баланса сил (для внутреннего пользования)
function FlameEconomy:SetBalance(percentage)
    local Amount = FlameEconomy:GetBalance()
    local AmountLimitLeft, AmountLimitRight = FlameEconomy:GetBalanceLimit()
    local ApplyAmount = Amount + percentage

    if percentage > 0 then
        if ApplyAmount => AmountLimitRight then
            ApplyAmount = AmountLimitRight
        end
    else
        if ApplyAmount <= AmountLimitLeft then
            ApplyAmount = AmountLimitLeft
        end
    end
    
    Balance = ApplyAmount

    -- Обновление значения баланса на клиенте
    net.Start("FlameEconomy.Balance")
        net.WriteInt(Balance, 10)
    net.Broadcast()

    return Balance
end

-- Функция смещения баланса сил
function FlameEconomy:AddBalance(percentage)
    -- Модификатор процента
    percentage = hook.Run("FlameEconomy.AddBalance", percentage)
    FlameEconomy:SetBalance(percentage)
    FlameEconomy:Message(ply, "Баланс сил изменился в сторону " .. percentage > 0 and "правоохранительных органов." or "бандитов.")
end