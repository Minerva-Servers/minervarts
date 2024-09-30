local GM = {}

GM.Name = "Free For All"
GM.Description = "A free for all gamemode."
GM.Author = "Riggs"

function GM:OnReloaded()
    print("Free For All has been reloaded.")
end

GAMEMODE_FFA = minerva.gamemodes:Register(GM)