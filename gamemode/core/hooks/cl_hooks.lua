// Client-side hooks

function GM:HUDPaint()
    local ply = LocalPlayer()
    if ( !IsValid(ply) ) then return end
end

function GM:LoadFonts()
    surface.CreateFont("minervaPlayerCard.Large", {
        font = "Arial",
        size = 32,
        weight = 800
    })

    surface.CreateFont("minervaPlayerCard.Medium", {
        font = "Arial",
        size = 24,
        weight = 800
    })

    surface.CreateFont("minervaPlayerCard.Small", {
        font = "Arial",
        size = 16,
        weight = 800
    })

    surface.CreateFont("minervaTitle", {
        font = "Arial",
        size = 64,
        weight = 800
    })

    surface.CreateFont("minervaSmall", {
        font = "Arial",
        size = 16,
        weight = 800
    })

    // I dislike overriding the default font, but it's necessary for the time being
    surface.CreateFont("DermaDefault", {
        font = "Arial",
        size = 16,
        weight = 800
    })
end

function GM:CalcView(ply, origin, angles, fov)
    local mapData = minerva.maps:Get()
    if ( mapData and mapData.SetupCamera and IsValid(minerva.gui.setup) ) then
        local camera = mapData.SetupCamera

        local view = {}
        view.origin = camera.Origin
        view.angles = camera.Angles
        view.fov = camera.FOV

        return view
    end
end

function GM:ForceDermaSkin()
    return "Minerva"
end