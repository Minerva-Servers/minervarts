local PANEL = {}

local randomSongs = {
    "music/hl2_song12_long.mp3",
    "music/hl2_song14.mp3",
    "music/hl2_song15.mp3",
    "music/hl2_song20_submix0.mp3",
    "music/hl2_song31.mp3",
    "music/hl2_song6.mp3",
}

local padding = ScreenScale(16)

function PANEL:Init()
    if ( IsValid(minerva.gui.setup) ) then
        minerva.gui.setup:Remove()
    end

    minerva.gui.setup = self

    local ply = LocalPlayer()
    if ( !IsValid(ply) ) then
        self:Remove()
        return
    end

    self.musicPath = randomSongs[math.random(1, #randomSongs)]

    self:SetSize(ScrW(), ScrH())
    self:SetPos(0, 0)

    self:DockPadding(padding * 4, padding, padding * 4, padding)

    self:Populate()

    self:MakePopup()
end

function PANEL:Populate()
    local serverTitle = self:Add("DLabel")
    serverTitle:SetFont("minervaTitle")
    serverTitle:SetText(GetHostName())
    serverTitle:SetTextColor(Color(255, 255, 255))
    serverTitle:SizeToContents()
    serverTitle:Dock(TOP)
    serverTitle:DockMargin(0, 0, 0, padding / 2)

    local playerList = self:Add("DScrollPanel")
    playerList:Dock(FILL)
    playerList:DockMargin(0, 0, padding, 0)

    self.playerList = playerList

    local rightPanel = self:Add("DPanel")
    rightPanel:SetWide(self:GetWide() / 6)
    rightPanel:Dock(RIGHT)
    rightPanel:DockPadding(padding / 2, padding / 2, padding / 2, padding / 2)
    rightPanel.Paint = function(this, width, height)
        draw.RoundedBox(8, 0, 0, width, height, Color(50, 50, 50, 150))
    end

    self.rightPanel = rightPanel

    self:PopulatePlayers()
    self:PopulateSettings()
end

function PANEL:AddPlayerCard(ply, teamID)
    local playerCard = self.playerList:Add("DPanel")
    playerCard:Dock(TOP)
    playerCard:DockMargin(padding / 4, 0, padding / 4, padding / 8)
    playerCard:SetTall(50)
    playerCard:DockPadding(10, 10, 10, 10)
    playerCard.Paint = function(this, width, height)
        draw.RoundedBox(8, 0, 0, width, height, Color(50, 50, 50, 150))
    end

    if ( IsValid(ply) ) then
        local avatar = playerCard:Add("AvatarImage")
        avatar:Dock(LEFT)
        avatar:SetSize(playerCard:GetTall() - 20, playerCard:GetTall() - 20)
        avatar:SetPlayer(ply, 32)
        avatar.Paint = function(this, width, height)
        end

        local name = playerCard:Add("DLabel")
        name:Dock(LEFT)
        name:DockMargin(5, 0, 0, 0)
        name:SetFont("minervaPlayerCard.Small")
        name:SetText(ply:Name())
        name:SetTextColor(Color(255, 255, 255))

        if ( ply == LocalPlayer() ) then
            local dropdown = playerCard:Add("DComboBox")
            dropdown:Dock(RIGHT)
            dropdown:SetWide(200)
            dropdown:SetValue("Unassigned")
            dropdown:SetContentAlignment(5)

            for k, v in ipairs(minerva.factions:GetAll()) do
                dropdown:AddChoice(v.Name, k, ply:GetFaction() == k)

                if ( ply:GetFaction() == k ) then
                    dropdown:SetTextColor(v.Color)
                end
            end

            dropdown:SetSortItems(false)

            dropdown.OnSelect = function(this, index, value, data)
                net.Start("MinervaSetup.ChangeFaction")
                    net.WriteUInt(data, 16)
                net.SendToServer()
            end

            if ( ply:Team() == TEAM_UNASSIGNED or ply:Team() == TEAM_SPECTATOR ) then
                dropdown:SetTextColor(Color(255, 255, 255))
                dropdown:SetDisabled(true)
                dropdown:SetValue("Unassigned")
            end
        else
            if ( LocalPlayer():IsAdmin() ) then
                local button = playerCard:Add("DButton")
                button:Dock(RIGHT)
                button:SetWide(200)
                button:SetText("Kick")
                button.DoClick = function()
                    Derma_Query("Are you sure you want to kick " .. ply:Name() .. "?", "Kick Player", "Yes", function()
                        Derma_StringRequest("Kick Reason", "Enter a reason for kicking " .. ply:Name() .. ".", "", function(reason)
                            net.Start("MinervaSetup.KickPlayer")
                                net.WriteUInt(ply:UserID(), 32)
                                net.WriteString(reason)
                            net.SendToServer()
                        end)
                    end, "No", function() end)
                end
            end

            local factionData = minerva.factions:Get(ply:GetFaction())
            local factionLabel = playerCard:Add("DButton")
            factionLabel:Dock(RIGHT)
            factionLabel:DockMargin(0, 0, padding / 4, 0)
            factionLabel:SetWide(200)
            factionLabel:SetFont("minervaPlayerCard.Small")
            factionLabel:SetContentAlignment(5)

            if ( factionData ) then
                factionLabel:SetText(factionData.Name)
                factionLabel:SetTextColor(factionData.Color)
            else
                factionLabel:SetText("Unassigned")
                factionLabel:SetTextColor(Color(255, 255, 255))
            end
        end
    else
        local name = playerCard:Add("DLabel")
        name:Dock(FILL)
        name:DockMargin(5, 0, 0, 0)
        name:SetFont("minervaPlayerCard.Small")
        name:SetText("Empty Slot")
        name:SetTextColor(Color(255, 255, 255))

        if ( LocalPlayer():Team() == teamID ) then return end

        local button = playerCard:Add("DButton")
        button:Dock(RIGHT)
        button:SetWide(200)
        button:SetText("Join")
        button.DoClick = function()
            net.Start("MinervaSetup.JoinTeam")
                net.WriteUInt(teamID, 16)
            net.SendToServer()
        end
    end
end

function PANEL:PopulatePlayers()
    self.playerList:Clear()

    local mapData = minerva.maps:Get()

    local teamCategories = {}
    local slots = mapData and mapData.Slots or {}
    slots[TEAM_SPECTATOR] = {}
    slots[TEAM_UNASSIGNED] = {}

    for k, v in pairs(slots) do
        teamCategories[k] = self.playerList:Add("DPanel")
        teamCategories[k]:Dock(TOP)
        teamCategories[k]:DockMargin(0, 0, 0, padding / 8)
        teamCategories[k]:SetTall(50)
        teamCategories[k].Paint = function(this, width, height)
            draw.RoundedBox(8, 0, 0, width, height, Color(50, 50, 50, 150))
        end

        local teamLabel = teamCategories[k]:Add("DLabel")
        teamLabel:Dock(FILL)
        teamLabel:DockMargin(padding / 2, 0, 0, 0)
        teamLabel:SetFont("minervaPlayerCard.Medium")
        teamLabel:SetText(team.GetName(k))
        teamLabel:SetTextColor(team.GetColor(k))

        local teamCount = teamCategories[k]:Add("DLabel")
        teamCount:Dock(RIGHT)
        teamCount:SetFont("minervaPlayerCard.Medium")
        teamCount:SetText(#team.GetPlayers(k) .. "/" .. ( v.Max or "∞" ))
        teamCount:SetTextColor(Color(255, 255, 255))

        if ( k == TEAM_SPECTATOR or k == TEAM_UNASSIGNED ) then
            for _, ply in ipairs(team.GetPlayers(k)) do
                self:AddPlayerCard(ply, k)
            end

            teamLabel:SetMouseInputEnabled(true)
            teamLabel.DoClick = function()
                net.Start("MinervaSetup.JoinTeam")
                    net.WriteUInt(k, 16)
                net.SendToServer()
            end
        else
            for i = 1, v.Max do
                local ply = team.GetPlayers(k)[i]
                self:AddPlayerCard(ply, k)
            end
        end
    end
end

function PANEL:PopulateSettings()
    self.rightPanel:Clear()

    local mapData = minerva.maps:Get()

    local mapLabel = self.rightPanel:Add("DLabel")
    mapLabel:SetFont("minervaPlayerCard.Medium")
    mapLabel:SetText("Map: " .. (mapData and mapData.Name or game.GetMap()))
    mapLabel:SetTextColor(Color(255, 255, 255))
    mapLabel:SizeToContents()
    mapLabel:Dock(TOP)
    mapLabel:DockMargin(0, 0, 0, padding / 8)

    local map = self.rightPanel:Add("DPanel")
    map:SetSize(self.rightPanel:GetWide() - padding, self.rightPanel:GetWide() - padding)
    map:Dock(TOP)
    map.Paint = function(this, width, height)
        draw.RoundedBox(8, 0, 0, width, height, Color(50, 50, 50, 150))

        local posX, posY = this:LocalToScreen(0, 0)
        local distance = 8192 * 16
        local trace = util.TraceLine({
            start = LocalPlayer():EyePos(),
            endpos = LocalPlayer():EyePos() + Vector(0, 0, distance),
            filter = LocalPlayer()
        })

        distance = trace.HitPos.z

        render.RenderView({
            origin = Vector(0, 0, distance),
            angles = Angle(90, 0, 0),
            x = posX,
            y = posY,
            w = width,
            h = height,
            drawviewmodel = false,
            drawhud = false,
            dopostprocess = false,
            drawmonitors = false,
            fov = 75,
            ortho = {
                left = -distance,
                right = distance,
                top = -distance,
                bottom = distance
            }
        })
    end

    local settingsLabel = self.rightPanel:Add("DLabel")
    settingsLabel:SetFont("minervaPlayerCard.Medium")
    settingsLabel:SetText("Settings")
    settingsLabel:SetTextColor(Color(255, 255, 255))
    settingsLabel:SizeToContents()
    settingsLabel:Dock(TOP)
    settingsLabel:DockMargin(0, padding, 0, padding / 8)

    local settings = self.rightPanel:Add("DPanel")
    settings:Dock(FILL)
    settings.Paint = function(this, width, height)
        draw.RoundedBox(8, 0, 0, width, height, Color(50, 50, 50, 150))
    end

    local settingsList = settings:Add("DScrollPanel")
    settingsList:Dock(FILL)
    settingsList:DockMargin(padding / 4, padding / 4, padding / 4, padding / 4)

    self.settingsList = settingsList
    
    self:PopulateSettingsList()
end

function PANEL:AddSetting(parent, text, value, callback, data)
    local setting = parent:Add("DPanel")
    setting:Dock(TOP)
    setting:DockMargin(0, 0, 0, padding / 8)
    setting:SetTall(50)
    setting.Paint = function(this, width, height)
        draw.RoundedBox(8, 0, 0, width, height, Color(50, 50, 50, 150))
    end

    local label = setting:Add("DLabel")
    label:Dock(LEFT)
    label:DockMargin(padding / 4, 0, padding / 4, 0)
    label:SetFont("minervaSmall")
    label:SetText(text)
    label:SetTextColor(Color(255, 255, 255))
    label:SizeToContents()

    if ( type(value) == "number" ) then
        local slider = setting:Add("DNumSlider")
        slider:Dock(FILL)

        slider:SetMin(data.min or 0)
        slider:SetMax(data.max or 100)
        slider:SetDecimals(data.decimals or 0)

        slider:SetValue(value)

        slider.OnValueChanged = function(this, value)
            if ( callback ) then
                callback(value)
            end
        end

        slider.PerformLayout = nil
        slider.Label:SetWide(0)
    elseif ( type(value) == "table" ) then
        local comboBox = setting:Add("DComboBox")
        comboBox:Dock(FILL)
        comboBox:DockMargin(padding / 2, padding / 4, padding / 2, padding / 4)

        for k, v in ipairs(value) do
            comboBox:AddChoice(v, nil, k == 1)
        end

        comboBox:SetSortItems(false)

        comboBox.OnSelect = function(this, index, value, data)
            if ( callback ) then
                callback(value)
            end
        end
    elseif ( type(value) == "string" ) then
        local valueEntry = setting:Add("DTextEntry")
        valueEntry:Dock(FILL)
        valueEntry:DockMargin(padding / 2, padding / 4, padding / 2, padding / 4)
        valueEntry:SetText(value)

        valueEntry.OnEnter = function(this)
            if ( callback ) then
                callback(this:GetValue())
            end
        end
    end

    return setting
end

function PANEL:PopulateSettingsList()
    local musicVolume = self:AddSetting(self.settingsList, "Music Volume", 10, function(value)
        if ( !tonumber(value) ) then return end

        self.music:ChangeVolume(value / 100, 1)
    end, {
        min = 0,
        max = 100,
        decimals = 0
    })

    local gamemodeType = self:AddSetting(self.settingsList, "Gamemode", {
        "Team Deathmatch",
        "Free For All",
        "Overrun",
        "Sandbox"
    })
end

function PANEL:Think()
    if ( !self.music ) then
        self.music = CreateSound(LocalPlayer(), self.musicPath)
    elseif ( !self.music:IsPlaying() ) then
        self.music:PlayEx(0.5, 100)
        self.music:ChangeVolume(0.1, 1)
    end
end

function PANEL:OnRemove()
    if ( self.music ) then
        self.music:FadeOut(1)
    end
end

function PANEL:Paint(width, height)
    surface.SetDrawColor(0, 0, 0, 50)
    surface.DrawRect(0, 0, width, height)

    minerva.util:DrawBlur(self, amount, passes)
end

vgui.Register("MinervaSetup", PANEL, "EditablePanel")

if ( IsValid(minerva.gui.setup) ) then
    minerva.gui.setup:Remove()

    timer.Simple(0.1, function()
        vgui.Create("MinervaSetup")
    end)
end

concommand.Add("minerva_setup", function()
    if ( IsValid(minerva.gui.setup) ) then
        minerva.gui.setup:Remove()
    else
        vgui.Create("MinervaSetup")
    end
end)