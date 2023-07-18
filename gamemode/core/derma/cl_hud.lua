local ScreenScale = ScreenScale
local ScrW = ScrW
local ScrH = ScrH
local draw_RoundedBox = draw.RoundedBox
local Color = Color
local string_char = string.char
local table_insert = table.insert
local draw_SimpleTextOutlined = draw.SimpleTextOutlined
local surface_SetDrawColor = surface.SetDrawColor
local surface_DrawOutlinedRect = surface.DrawOutlinedRect
local util_TraceLine = util.TraceLine
local LocalPlayer = LocalPlayer
local pairs = pairs
local Vector = Vector
local ipairs = ipairs
local IsValid = IsValid
local PrintTable = PrintTable
local minerva = minerva
local surface_SetMaterial = surface.SetMaterial
local Material = Material
local surface_DrawTexturedRect = surface.DrawTexturedRect
local net_Start = net.Start
local net_WriteEntity = net.WriteEntity
local net_WriteString = net.WriteString
local net_SendToServer = net.SendToServer
local vgui_Register = vgui.Register
local vgui_Create = vgui.Create

local PANEL = {}

function PANEL:Init()
    minerva.gui.hud = self

    local padding = ScreenScale(8)
    local abilitiesButtonScale = ScreenScale(24)
    local selectedButtonScale = ScreenScale(24)
    local abilitiesScale = ScreenScale(96)
    local minimapScale = ScreenScale(128)
    local selectedScale = ScreenScale(96)

    self:SetSize(ScrW(), ScrH())
    self:ParentToHUD()
    self:MakePopup()

    self:SetKeyboardInputEnabled(true)
    self:SetMouseInputEnabled(true)
    self:SetWorldClicker(true)

    // abilities panel
    self.abilities = {}

    self.abilitiesPanel = self:Add("DPanel")
    self.abilitiesPanel:SetPos(0, self:GetTall() - abilitiesScale)
    self.abilitiesPanel:SetSize(abilitiesScale, abilitiesScale)
    self.abilitiesPanel.Paint = function(this, width, height)
        // draw abilities panel background
        draw_RoundedBox(0, 0, 0, width, height, Color(150, 150, 150, 200))
    end
    
    // abilities grid
    self.abilitiesGrid = self.abilitiesPanel:Add("DGrid")
    self.abilitiesGrid:SetCols(4)
    self.abilitiesGrid:SetColWide(abilitiesButtonScale)
    self.abilitiesGrid:SetRowHeight(abilitiesButtonScale)

    // populate abilities grid with buttons
    for i = 1, 16 do
        local button = self.abilitiesGrid:Add("DButton")
        button:SetText(string_char(64 + i))
        button:SetSize(abilitiesButtonScale, abilitiesButtonScale)
        button.Paint = function(this, width, height)
            // draw button background
            draw_RoundedBox(0, 0, 0, width, height, Color(150, 150, 150, 200))
        end

        self.abilitiesGrid:AddItem(button)

        table_insert(self.abilities, button)
    end

    // minimap
    local minimap = self:Add("DPanel")
    minimap:SetPos(self:GetWide() - minimapScale, self:GetTall() - minimapScale)
    minimap:SetSize(minimapScale, minimapScale)
    minimap.Paint = function(this, width, height)
        // draw minimap background
        draw_RoundedBox(0, 0, 0, width, height, Color(150, 150, 150, 200))
    end

    // selected units/buildings panel
    local selected = self:Add("DScrollPanel")
    selected:SetPos(abilitiesScale + padding, self:GetTall() - selectedScale)
    selected:SetSize(self:GetWide() - padding * 2 - minimap:GetWide() - abilitiesScale, selectedScale)
    selected.Paint = function(this, width, height)
        // draw selected units/buildings panel background
        draw_RoundedBox(0, 0, 0, width, height, Color(150, 150, 150, 200))
    end
    
    // selected units/buildings grid
    local grid = selected:Add("DGrid")
    grid:SetCols(selected:GetWide() * 0.005)
    grid:SetPos(0, 0)
    grid:SetColWide(selectedButtonScale)
    grid:SetRowHeight(selectedButtonScale)

    // populate selected units/buildings grid with buttons
    for i = 1, 16 do
        local button = grid:Add("SpawnIcon")
        button:SetModel("models/kleiner.mdl")
        button:SetSize(selectedButtonScale, selectedButtonScale)
        button:SetTooltip("Kleiner Unit")
        button.Paint = function(this, width, height)
            // draw button background
            draw_RoundedBox(0, 0, 0, width, height, Color(150, 150, 150, 200))
        end

        grid:AddItem(button)
    end

    // selection circle
    self.circle = self:Add("DPanel")
    self.circle:SetSize(64, 64)
    self.circle.Paint = function(this, width, height)
        draw_SimpleTextOutlined("Selected", "DermaDefault", width / 2, height / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
        surface_SetDrawColor(255, 255, 255, 100)
        surface_DrawOutlinedRect(0, 0, width, height)
    end
    self.circle:SetVisible(false)
end

// store selected entities in a table
local selectedEntities = {}

// select unit on mouse click
function PANEL:OnMousePressed(mouseCode)
    if ( mouseCode == MOUSE_LEFT ) then
        local mousePos = self:CursorPos()
        local trace = util_TraceLine({
            start = LocalPlayer():GetShootPos(),
            endpos = LocalPlayer():GetShootPos() + LocalPlayer():GetAimVector() * 10000,
            filter = LocalPlayer(),
            mask = MASK_SHOT_HULL
        })

        if ( trace.HitNonWorld ) then
            local entity = trace.Entity
            if ( entity:IsValid() ) then
                selectedEntities = {}
                table_insert(selectedEntities, entity)
                self.circle:SetPos(mousePos - self.circle:GetWide() / 2, mousePos - self.circle:GetTall() / 2)
                self.circle:SetVisible(true)
                self:SetSelected(entity)
                entity:SetSelected(true)
            end
        end
    end
end

// clear selection on right-click
function PANEL:OnMouseReleased(mouseCode)
    if mouseCode == MOUSE_RIGHT then
        for k, v in pairs(selectedEntities) do
            v:SetSelected(false)
        end
        
        self:SetSelected(nil)
        selectedEntities = {}
        self.circle:SetVisible(false)
    end
end

// highlight selected entities with circle
function PANEL:Think()
    local selectedPos = Vector(0, 0, 0)
    local numSelected = #selectedEntities
    if ( numSelected > 0 ) then
        for k, v in ipairs(selectedEntities) do
            selectedPos = selectedPos + v:GetPos()
        end
        
        selectedPos = selectedPos / numSelected

        local screenPos = selectedPos:ToScreen()
        self.circle:SetPos(screenPos.x - self.circle:GetWide() / 2, screenPos.y - self.circle:GetTall() / 2)
        self.circle:SetVisible(true)
    else
        self.circle:SetVisible(false)
    end
end

function PANEL:SetSelected(entity)
    self.entity = entity
    
    // clear existing abilities
    for i = 1, 16 do
        self.abilities[i]:SetText("")
        self.abilities[i]:SetVisible(false)
    end

    if not ( IsValid(entity) ) then
        return
    end
    
    // get abilities from entity
    local abilities = entity:GetAbilities()
    PrintTable(abilities)

    for k, v in pairs(abilities) do
        for i = 1, 16 do
            if ( self.abilities[i] ) then
                self.abilities[i]:SetText("")
                self.abilities[i]:SetVisible(true)
                self.abilities[i].ability = k
                self.abilities[i].used = true
                self.abilities[i].PaintOver = function(this, width, height)
                    if ( minerva.abilities.Get(k) ) then
                        surface_SetDrawColor(color_white)
                        surface_SetMaterial(Material(minerva.abilities.Get(k).icon, "smooth mips"))
                        surface_DrawTexturedRect(0, 0, width, height)
                    elseif ( minerva.units.Get(k) ) then
                        surface_SetDrawColor(color_white)
                        surface_SetMaterial(Material(minerva.units.Get(k).icon, "smooth mips"))
                        surface_DrawTexturedRect(0, 0, width, height)
                    else
                        draw_RoundedBox(0, 0, 0, width, height, Color(25, 25, 25, 100))
                    end
                end
                self.abilities[i].DoClick = function(this)
                    net_Start("minervaWars.AbilityBuilding")
                        net_WriteEntity(entity)
                        net_WriteString(k)
                    net_SendToServer()
                end

                break
            end
        end
    end
end

vgui_Register("minerva.HUD", PANEL, "EditablePanel")

if ( IsValid(minerva.gui.hud) ) then
    minerva.gui.hud:Remove()
end

vgui_Create("minerva.HUD")