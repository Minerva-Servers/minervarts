AddCSLuaFile()

SWEP.Base = "weapon_base"

SWEP.PrintName = "Unit Selector"
SWEP.Author = "Riggs"
SWEP.Instructions = "Select units with primary fire, move them with secondary fire, and deselect all with reload."
SWEP.Slot = 1
SWEP.SlotPos = 1
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true

SWEP.Spawnable = true
SWEP.AdminOnly = true
SWEP.Category = "Minerva RTS"

SWEP.ViewModel = "models/weapons/c_toolgun.mdl"
SWEP.WorldModel = "models/weapons/w_toolgun.mdl"
SWEP.UseHands = true

SWEP.Primary.Automatic = false
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Ammo = "none"

function SWEP:Initialize()
    self:SetHoldType("revolver")

    local ply = self.Owner
    
    if ( SERVER ) then
        ply:SetNetVar("selected", {})
    end
end

function SWEP:PrimaryAttack()
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
end

function SWEP:SelectUnit()
    if ( CLIENT ) then return end

    if ( self.nextSelect and CurTime() < self.nextSelect ) then
        return
    end

    local ply = self.Owner
    local trace = ply:GetEyeTrace()
    local ent = trace.Entity

    if ( IsValid(ent) ) then
        local bCrouch = ply:KeyDown(IN_DUCK)
        local bShift = ply:KeyDown(IN_SPEED)

        ply:ViewPunch(Angle(-1, 0, 0))
        ply:EmitSound(bCrouch and "buttons/combine_button_locked.wav" or "ambient/machines/keyboard" .. math.random(1, 6) .. "_clicks.wav")

        local selected = ply:GetNetVar("selected", {})

        if ( bCrouch ) then
            selected[ent] = nil
        else
            if ( bShift ) then
                selected[ent] = true
            else
                selected = { [ent] = true }
            end
        end

        ply:SetNetVar("selected", selected)
    end

    self.nextSelect = CurTime() + 0.1
end

local airNPCs = {
    ["npc_helicopter"] = true,
    ["npc_combinegunship"] = true,
    ["npc_combinedropship"] = true,
}

function SWEP:MoveUnits()
    if ( CLIENT ) then return end

    if ( self.nextMove and CurTime() < self.nextMove ) then
        return
    end

    local ply = self.Owner
    local trace = ply:GetEyeTrace()
    local selected = ply:GetNetVar("selected", {})

    ply:ViewPunch(Angle(-1, 0, 0))
    ply:EmitSound("ambient/machines/keyboard" .. math.random(1, 6) .. "_clicks.wav")

    local bShift = ply:KeyDown(IN_SPEED)
    for k, v in pairs(selected) do
        if not ( IsValid(k) ) then
            continue
        end

        if not ( k:IsNPC() ) then
            continue
        end
        
        if ( airNPCs[k:GetClass()] ) then
            local pathTrack = ents.Create("path_track")
            pathTrack:SetPos(trace.HitPos + Vector(0, 0, 512))
            pathTrack:SetName("path_track_" .. pathTrack:EntIndex())
            pathTrack:Spawn()

            k:Fire("FlyToSpecificTrackViaPath", "path_track_" .. pathTrack:EntIndex())

            timer.Simple(1, function()
                if not ( IsValid(pathTrack) ) then
                    return
                end

                pathTrack:Remove()
            end)
        else
            k:SetLastPosition(trace.HitPos)
            k:SetSchedule(SCHED_NPC_FREEZE)
            timer.Simple(1 / 3, function()
                if not ( IsValid(k) ) then
                    return
                end

                k:SetSchedule(bShift and SCHED_FORCED_GO or SCHED_FORCED_GO_RUN)
            end)
        end

        local effectdata = EffectData()
        effectdata:SetOrigin(trace.HitPos)
        util.Effect("VortDispel", effectdata)
    end

    self.nextMove = CurTime() + 1 / 3
end

function SWEP:ResetSelection()
    if ( CLIENT ) then return end

    if ( self.nextReload and CurTime() < self.nextReload ) then
        return
    end

    local ply = self.Owner
    ply:ViewPunch(Angle(-1, 0, 0))
    ply:EmitSound("ambient/machines/keyboard" .. math.random(1, 6) .. "_clicks.wav")
    ply:SetNetVar("selected", {})

    self.nextReload = CurTime() + 1
end

function SWEP:DrawHUD()
    local ply = LocalPlayer()

    local x, y = ScrW() / 2, ScrH() / 5

    draw.SimpleText("Primary: Select unit", "BudgetLabel", x, y - 100, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    draw.SimpleText("Primary + Shift: Add to selection", "BudgetLabel", x, y - 80, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    draw.SimpleText("Primary + Crouch: Remove from selection", "BudgetLabel", x, y - 60, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    draw.SimpleText("Secondary: Move selected units (Run)", "BudgetLabel", x, y - 40, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    draw.SimpleText("Secondary + Shift: Move selected units (Walk)", "BudgetLabel", x, y - 20, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    draw.SimpleText("Reload: Deselect all units", "BudgetLabel", x, y, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

    x, y = ScrW() / 10, ScrH() / 5 - 100
    draw.SimpleText("Selected Units", "BudgetLabel", x, y, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    local selected = ply:GetNetVar("selected", {})
    local i = 0

    for k, v in pairs(selected) do
        if not ( IsValid(k) ) then
            continue
        end

        local name = k:GetNWString("ZBaseName", "")
        if ( name == "" ) then
            name = k:GetClass()
        end

        name = language.GetPhrase(name)

        i = i + 1
        draw.SimpleText(" - " .. name, "BudgetLabel", x, y + ( i * 20 ), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end
    
    local pos = gui.ScreenToVector(gui.MousePos())
    if not ( vgui.CursorVisible() ) then
        pos = ply:GetAimVector()
    end

    local trace = util.TraceLine({
        start = ply:EyePos(),
        endpos = ply:EyePos() + pos * 10000,
        filter = ply
    })

    local ent = trace.Entity
    if ( IsValid(ent) ) then
        minerva.outline.Add(ent, ColorAlpha(color_white, 100), 0)
    end

    local selected = ply:GetNetVar("selected", {})
    for k, v in pairs(selected) do
        if not ( IsValid(k) ) then
            continue
        end

        minerva.outline.Add(k, color_white, 0)
    end
end

hook.Add("Tick", "MinervaRTS.Selector", function()
    for k, v in player.Iterator() do
        local weapon = v:GetActiveWeapon()
        if not ( IsValid(weapon) ) then
            continue
        end

        if not ( weapon:GetClass() == "minerva_rts_selector" ) then
            continue
        end

        if ( v:KeyDownLast(IN_ATTACK) and not v:KeyDown(IN_ATTACK) ) then
            weapon:SelectUnit()
        end

        if ( v:KeyDownLast(IN_ATTACK2) and not v:KeyDown(IN_ATTACK2) ) then
            weapon:MoveUnits()
        end

        if ( v:KeyDownLast(IN_RELOAD) and not v:KeyDown(IN_RELOAD) ) then
            weapon:ResetSelection()
        end
    end
end)