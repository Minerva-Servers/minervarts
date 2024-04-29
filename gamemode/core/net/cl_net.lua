// Client-side networking

net.Receive("MinervaChatText", function(len)
    local args = net.ReadTable()

    chat.AddText(unpack(args))
end)

net.Receive("MinervaSetup", function(len)
    vgui.Create("MinervaSetup")
end)