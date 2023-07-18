local Vector = Vector
local Angle = Angle
local input_IsKeyDown = input.IsKeyDown
local LocalPlayer = LocalPlayer
local concommand_Add = concommand.Add

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
    view.zfar = 4096

    ply:SetEyeAngles(view.angles)

    return view
end

function GM:Think()
    if ( input_IsKeyDown(KEY_W) ) then
        LocalPlayer():ConCommand("+forward")
    elseif ( input_IsKeyDown(KEY_S) ) then
        LocalPlayer():ConCommand("+back")
    else
        LocalPlayer():ConCommand("-forward")
        LocalPlayer():ConCommand("-back")
    end

    if ( input_IsKeyDown(KEY_A) ) then
        LocalPlayer():ConCommand("+moveleft")
    elseif ( input_IsKeyDown(KEY_D) ) then
        LocalPlayer():ConCommand("+moveright")
    else
        LocalPlayer():ConCommand("-moveleft")
        LocalPlayer():ConCommand("-moveright")
    end
end

// Create a console command to toggle the camera control on and off
concommand_Add("toggle_camera", function()
    cameraEnabled = not cameraEnabled
end)