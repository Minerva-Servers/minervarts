minerva.modules:Register({
    Name = "Test",
    Description = "A test module.",
    Author = "Riggs",
})

minerva.modules:AddFunction("test", "PlayerSpawn", function(self, ply)
    print(self, ply)
end)