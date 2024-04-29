local PANEL = {}

local randomSongs = {
    "music/hl2_song12_long.mp3",
    "music/hl2_song14.mp3",
    "music/hl2_song15.mp3",
    "music/hl2_song20_submix0.mp3",
    "music/hl2_song31.mp3",
    "music/hl2_song6.mp3",
}

function PANEL:Init()
    if ( IsValid(minerva.gui.setup) ) then
        minerva.gui.setup:Remove()
    end

    minerva.gui.setup = self

    local ply = LocalPlayer()
    if not ( IsValid(ply) ) then
        self:Remove()
        return
    end

    self.musicPath = randomSongs[math.random(1, #randomSongs)]

    self:SetSize(ScrW(), ScrH())
    self:Center()

    self:MakePopup()
end

function PANEL:Think()
    if not ( self.music ) then
        self.music = CreateSound(LocalPlayer(), self.musicPath)
    elseif not ( self.music:IsPlaying() ) then
        self.music:PlayEx(0.5, 100)
    else
        self.music:ChangeVolume(0.05, 1)
    end
end

function PANEL:OnRemove()
    if ( self.music ) then
        self.music:FadeOut(1)
    end
end

function PANEL:Paint(width, height)
    minerva:DrawBlur(self, amount, passes)
end

vgui.Register("MinervaSetup", PANEL, "EditablePanel")

if ( IsValid(minerva.gui.setup) ) then
    minerva.gui.setup:Remove()

    timer.Simple(0.1, function()
        vgui.Create("MinervaSetup")
    end)
end