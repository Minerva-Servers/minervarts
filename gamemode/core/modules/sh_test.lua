minerva.modules:Register({
    Name = "Test",
    Description = "A test module.",
    Author = "Riggs",
})

minerva.modules:AddFunction("Test", "PlayerSpawn", function(self, ply)
    print(self, ply)
end)