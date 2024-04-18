net.Receive("MinervaChatText", function(len)
    local args = net.ReadTable()

    chat.AddText(unpack(args))
end)