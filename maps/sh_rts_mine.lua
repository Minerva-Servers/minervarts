minerva.maps:Register("rts_mine", {
    Name = "Mine",
    Description = "A small, enclosed map for close-quarters combat.",
    Author = "Riggs, Lambda Wars Development Team",

    Slots = {
        [TEAM_1] = {
            Max = 2,
            Spawns = {
                Vector(0, 0, 0)
            }
        },

        [TEAM_2] = {
            Max = 2,
            Spawns = {
                Vector(0, 0, 0)
            }
        }
    },

    Gamemodes = {
        [GAMEMODE_TDM] = true,
        [GAMEMODE_FFA] = true
    },

    SetupCamera = {
        Origin = Vector(1600, -1200, 1159),
        Angles = Angle(25, 135, 0),
        FOV = 75
    }
})

if ( CLIENT ) then return end

local camera
for k, v in ipairs(ents.FindByClass("point_camera")) do
    if ( v:GetName() == "lobby_camera" ) then
        camera = v
        break
    end
end

local pos, ang
if ( IsValid(camera) ) then
    pos = camera:GetPos()
    ang = camera:GetAngles()

    print("Found camera at " .. tostring(pos) .. " with angles " .. tostring(ang))
else
    pos = Vector(0, 0, 0)
    ang = Angle(0, 0, 0)

    print("No camera found, defaulting to " .. tostring(pos) .. " with angles " .. tostring(ang))
end