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
    if ( self.nextSelect and CurTime() < self.nextSelect ) then return end

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
                selected = {[ent] = true}
            end
        end

        ply:SetNetVar("selected", selected)
    end

    self.nextSelect = CurTime() + 0.1
end

function SWEP:SelectUnits(entities)
    if ( CLIENT ) then return end
    if ( self.nextSelect and CurTime() < self.nextSelect ) then return end

    local ply = self.Owner

    ply:ViewPunch(Angle(-1, 0, 0))
    ply:EmitSound("ambient/machines/keyboard" .. math.random(1, 6) .. "_clicks.wav")

    local bShift = ply:KeyDown(IN_SPEED)
    local selected = ply:GetNetVar("selected", {})
    if ( !bShift ) then selected = {} end

    for k, v in pairs(entities) do
        if ( !IsValid(v) ) then continue end

        selected[v] = true
    end

    ply:SetNetVar("selected", selected)

    self.nextSelect = CurTime() + 0.1
end

local airNPCs = {
    ["npc_helicopter"] = true,
    ["npc_combinegunship"] = true,
    ["npc_combinedropship"] = true,
}

function SWEP:MoveUnits()
    if ( CLIENT ) then return end
    if ( self.nextMove and CurTime() < self.nextMove ) then return end

    local ply = self.Owner
    local trace = ply:GetEyeTrace()
    local selected = ply:GetNetVar("selected", {})

    ply:ViewPunch(Angle(-1, 0, 0))
    ply:EmitSound("ambient/machines/keyboard" .. math.random(1, 6) .. "_clicks.wav")

    local bShift = ply:KeyDown(IN_SPEED)
    for k, v in pairs(selected) do
        if ( !IsValid(k) ) then continue end
        if ( !k:IsNPC() ) then continue end

        if ( k:GetNetVar("team", 0) != ply:Team() ) then continue end
        if ( k:GetNetVar("owner", "") != ply:SteamID64() ) then continue end
        
        if ( airNPCs[k:GetClass()] ) then
            local pathTrack = ents.Create("path_track")
            pathTrack:SetPos(trace.HitPos + Vector(0, 0, 512))
            pathTrack:SetName("path_track_" .. pathTrack:EntIndex())
            pathTrack:Spawn()

            k:Fire("FlyToSpecificTrackViaPath", "path_track_" .. pathTrack:EntIndex())

            SafeRemoveEntityDelayed(pathTrack, 1)
        else
            k:SetNetVar("destination", trace.HitPos)
            k:SetLastPosition(trace.HitPos)
            k:SetSchedule(bShift and SCHED_FORCED_GO or SCHED_FORCED_GO_RUN)
            k:SetNetVar("walking", bShift)
        end

        local effectdata = EffectData()
        effectdata:SetOrigin(trace.HitPos)
        util.Effect("VortDispel", effectdata)
    end

    self.nextMove = CurTime() + 1 / 3
end

function SWEP:ResetSelection()
    if ( CLIENT ) then return end
    if ( self.nextReload and CurTime() < self.nextReload ) then return end

    local ply = self.Owner
    ply:ViewPunch(Angle(-1, 0, 0))
    ply:EmitSound("ambient/machines/keyboard" .. math.random(1, 6) .. "_clicks.wav")
    ply:SetNetVar("selected", {})

    self.nextReload = CurTime() + 1
end

function SWEP:DrawHUD()
    local ply = LocalPlayer()

    local x, y = ScrW() / 2, ScrH() / 8

    draw.SimpleText("Primary: Select unit", "BudgetLabel", x, y - 100, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    draw.SimpleText("Primary + Shift: Add to selection", "BudgetLabel", x, y - 80, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    draw.SimpleText("Primary + Crouch: Remove from selection", "BudgetLabel", x, y - 60, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    draw.SimpleText("Secondary: Move selected units (Run)", "BudgetLabel", x, y - 40, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    draw.SimpleText("Secondary + Shift: Move selected units (Walk)", "BudgetLabel", x, y - 20, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    draw.SimpleText("Reload: Deselect all units", "BudgetLabel", x, y, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

    x, y = ScrW() / 10, ScrH() / 8 - 100
    draw.SimpleText("Selected Units", "BudgetLabel", x, y, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

    local selected = ply:GetNetVar("selected", {})
    local i = 0

    for k, v in pairs(selected) do
        if ( !IsValid(k) ) then continue end

        local name = k:GetNWString("ZBaseName", "")
        if ( name == "" ) then
            name = k:GetClass()
        end

        name = language.GetPhrase(name)

        i = i + 1
        draw.SimpleText(" - " .. name, "BudgetLabel", x, y + ( i * 20 ), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end
end

hook.Add("PreDrawHalos", "MinervaRTS.Selector", function()
    local ply = LocalPlayer()
    local pos = gui.ScreenToVector(gui.MousePos())
    if ( !vgui.CursorVisible() ) then
        pos = ply:GetAimVector()
    end

    local trace = util.TraceLine({
        start = ply:EyePos(),
        endpos = ply:EyePos() + pos * 10000,
        filter = ply
    })

    local selected = ply:GetNetVar("selected", {})
    for k, v in pairs(team.GetAllTeams()) do
        local ent = trace.Entity
        if ( IsValid(ent) and ent:GetNetVar("team", 0) == k ) then
            minerva.outline:Render(ent, team.GetColor(k), OUTLINE_MODE_ALWAYS)
        end

        local halos = {}
        for k2, v2 in pairs(selected) do
            if ( !IsValid(k2) ) then continue end
            if ( k2:GetNetVar("team", 0) != k ) then continue end

            table.insert(halos, k2)
        end

        if ( #halos > 0 ) then
            halo.Add(halos, team.GetColor(k), 2, 2, 1, true, true)
        end
    end
end)

hook.Add("PostDrawTranslucentRenderables", "MinervaRTS.Selector", function()
    local ply = LocalPlayer()
    if ( !IsValid(ply) ) then return end

    local weapon = ply:GetActiveWeapon()
    if ( !IsValid(weapon) ) then return end

    if ( weapon:GetClass() != "minerva_rts_selector" ) then return end

    local dragging = weapon:GetNetVar("dragging")
    if ( dragging ) then
        local aimPos = util.TraceLine({
            start = ply:EyePos(),
            endpos = ply:EyePos() + ply:GetAimVector() * 100,
            filter = ply
        }).HitPos

        local center, min, max = minerva.util:GetBounds(dragging, aimPos)

        render.DrawWireframeBox(center, angle_zero, min, max, color_white)

        for k, v in pairs(ents.FindInBox(dragging, aimPos)) do
            if ( !IsValid(v) ) then continue end
            if ( !v:IsNPC() ) then continue end

            for k2, v2 in pairs(team.GetAllTeams()) do
                if ( v:GetNetVar("team", 0) == k2 ) then
                    minerva.outline:Render(v, team.GetColor(v2), OUTLINE_MODE_ALWAYS)
                end
            end
        end
    end
end)

local nextThink = 0
hook.Add("Tick", "MinervaRTS.Selector", function()
    for k, v in player.Iterator() do
        local weapon = v:GetActiveWeapon()
        if ( !IsValid(weapon) ) then continue end
        if ( weapon:GetClass() != "minerva_rts_selector" ) then continue end

        local traceEnt = v:GetEyeTrace().Entity
        if ( v:KeyDown(IN_ATTACK) and not weapon:GetNetVar("dragging") and not IsValid(traceEnt) ) then
            if ( SERVER ) then
                weapon:SetNetVar("dragging", v:GetEyeTrace().HitPos)
            end
        elseif ( not v:KeyDown(IN_ATTACK) and weapon:GetNetVar("dragging") ) then
            local foundEnts = {}
            local aimPos = util.TraceLine({
                start = v:EyePos(),
                endpos = v:EyePos() + v:GetAimVector() * 100,
                filter = v
            }).HitPos

            for k, v in pairs(ents.FindInBox(weapon:GetNetVar("dragging"), aimPos)) do
                if ( !v:IsNPC() ) then continue end

                table.insert(foundEnts, v)
            end

            weapon:SelectUnits(foundEnts)

            if ( SERVER ) then
                weapon:SetNetVar("dragging", nil)
            end
        elseif ( v:KeyDownLast(IN_ATTACK) and not v:KeyDown(IN_ATTACK) and IsValid(traceEnt) ) then
            weapon:SelectUnit()
        end

        if ( v:KeyDownLast(IN_ATTACK2) and not v:KeyDown(IN_ATTACK2) ) then
            weapon:MoveUnits()
        end

        if ( v:KeyDownLast(IN_RELOAD) and not v:KeyDown(IN_RELOAD) ) then
            weapon:ResetSelection()
        end
    end

    if ( CLIENT ) then return end
    if ( nextThink > CurTime() ) then return end

    for k, v in ents.Iterator() do
        if ( !v:IsNPC() ) then continue end

        local destination = v:GetNetVar("destination")
        if ( !destination ) then continue end

        local schedule = v:GetCurrentSchedule()
        if ( schedule == SCHED_FORCED_GO or schedule == SCHED_FORCED_GO_RUN ) then continue end

        local pos = v:GetPos()
        local dist = pos:DistToSqr(destination)
        if ( dist > 256 ^ 2 ) then
            v:SetSchedule(v:GetNetVar("walking") and SCHED_FORCED_GO or SCHED_FORCED_GO_RUN)
        end
    end

    nextThink = CurTime() + 0.1
end)