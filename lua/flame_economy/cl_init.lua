net.Receive("FlameEconomy.Message", function(len)
    local ReceivedMessage = net.ReadString()
    chat.AddText(ReceivedMessage)
end)

