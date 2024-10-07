-- Расчитывает скидку относительно условий из цепочки событий.
function FlameEconomy:CalculateDiscount(ply, money)
    money = hook.Run("FlameEconomy.CalculateDiscount", ply, money)
    return money
end