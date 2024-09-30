local GM = {}

GM.Name = "Team Deathmatch"
GM.Description = "A team deathmatch gamemode."
GM.Author = "Riggs"

function GM:OnReloaded()
    print("Team Deathmatch has been reloaded.")
end

GAMEMODE_TDM = minerva.gamemodes:Register(GM)