local cameraEnabled = cameraEnabled or true
function GM:CalcView(ply, pos, angles, fov)
    if not ( cameraEnabled ) then
        return
    end

    // Set the player's view to a top-down perspective
    local view = {}
    view.origin = Vector(pos.x, pos.y, Lerp(0.1, pos.z, pos.z))
    view.angles = Angle(60, 130, 0)
    view.fov = fov
    view.znear = 100
    view.zfar = 2200

    return view
end

function GM:InputMouseApply(cmd, x, y, ang)
    cmd:SetViewAngles(Angle(0, 130, 0))
end

// Create a console command to toggle the camera control on and off
concommand.Add("toggle_camera", function()
    cameraEnabled = not cameraEnabled
end)