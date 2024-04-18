function GM:HUDPaint()
    local ply = LocalPlayer()
    if not ( IsValid(ply) ) then
        return
    end
    
    for k, v in ents.Iterator() do
        if not ( IsValid(v) ) then
            continue
        end

        if not ( v:IsNPC() ) then
            continue
        end

        minerva.outline.Add(v, color_white, 0)
    end
end