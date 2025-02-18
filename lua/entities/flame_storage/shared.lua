ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Хранилище"
ENT.Category = "Flame Castle | Economy"
ENT.Author = "Flame Castle"
ENT.Spawnable = true
--[[
    Хранилище представляет из одновременно хранилище для бюджета города и вооружения и устанавливается на военной базе;

    Хранилище может быть ограблено. При этом при ограблении теряется часть бюджета города;
    Некоторая часть бюджета выпадает в виде наличных денег, некоторая исчезает для вывода денежных средств с сервера;
    Помимо бюджета из хранилища могут выпасть:
    1 - Ящики с оружием;
    2 - Предметы для крафта;
    3 - RP-очки (очки для улучшения персонажа и покупки лимитированных предметов);
    4 - Глобальные события (случайное событие, распространяемое на весь сервер, например, x2 зарплата или пожар в городе);
]]
-- На карте может быть только один экземляр 
function ENT:SetupDataTables()
    --[[
        Текущий статус хранилища:
        1 - Не может быть ограблен в данный момент;
        2 - Готов к ограблению;
        3 - Находится в процессе ограбления, стадия ожидания;
        4 - Находится в процессе ограбления, стадия выдачи ящиков;
        5 - Ящики закончились, хранилище ждёт перезагрузки;
        6 - Хранилище заблокировано после неудачного ограбления;

        1-ая стадия выставляется при внешних условиях, например при нехватке игроков;
        5-ая и 6-ая стадия выставляются в зависимости от условий;

        В зависимости от стадии выводится внешняя информация о статусе ограбления для интерфейса;
    ]]
    self:NetworkVar("Int", 0, "Status")
    --[[
        Количество денежных средств в текущий момент в бюджете города;

        Пополнение денежных производиться функцией FlameEconomy.Storage.AddMoney;
    ]]
    self:NetworkVar("Int", 1, "MoneyAmount")

    -- Количество ящиков
    self:NetworkVar("Int", 2, "BoxCount")

    if SERVER then
        self:SetStatus(1)
        self:SetMoneyAmount(0)
        self:SetBoxCount(0)
    end
end