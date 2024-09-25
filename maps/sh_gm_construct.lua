minerva.maps:Register("gm_construct", {
    Name = "Construct",
    Description = "A flat, open map for building.",
    Author = "Unknown",

    Slots = {
        [TEAM_1] = {
            Max = 3,
            Spawns = {
                Vector(0, 0, 0)
            }
        },

        [TEAM_2] = {
            Max = 3,
            Spawns = {
                Vector(0, 0, 0)
            }
        }
    },

    SetupCamera = {
        Origin = Vector(-3780.133545, 4546.148438, 935.208252),
        Angles = Angle(6.568642, -58.616577, -0.544500),
        FOV = 75
    },
})