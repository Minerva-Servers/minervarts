local cameraEnabled = cameraEnabled or true
function GM:CalcView(ply, pos, angles, fov)
    if not ( cameraEnabled ) then
        return
    end

    // Set the player's view to a top-down perspective
    local view = {}
    view.origin = Vector(pos.x, pos.y, pos.z)
    view.angles = Angle(60, 130, 0)
    view.fov = fov
    view.znear = 10
    view.zfar = 3000

    return view
end

function GM:InputMouseApply(cmd, x, y, ang)
    cmd:SetViewAngles(Angle(0, 130, 0))
end

// Create a console command to toggle the camera control on and off
concommand.Add("toggle_camera", function()
    cameraEnabled = not cameraEnabled
end)

gui.EnableScreenClicker(true)