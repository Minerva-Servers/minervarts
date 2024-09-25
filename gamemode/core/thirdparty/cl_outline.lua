local Material = Material
local CreateMaterial = CreateMaterial
local render_GetScreenEffectTexture = render.GetScreenEffectTexture
local istable = istable
local table_IsEmpty = table.IsEmpty
local table_insert = table.insert
local render_GetRenderTarget = render.GetRenderTarget
local render_CopyRenderTargetToTexture = render.CopyRenderTargetToTexture
local render_Clear = render.Clear
local render_SetStencilEnable = render.SetStencilEnable
local cam_IgnoreZ = cam.IgnoreZ
local render_SuppressEngineLighting = render.SuppressEngineLighting
local render_SetStencilWriteMask = render.SetStencilWriteMask
local render_SetStencilTestMask = render.SetStencilTestMask
local render_SetStencilCompareFunction = render.SetStencilCompareFunction
local render_SetStencilFailOperation = render.SetStencilFailOperation
local render_SetStencilZFailOperation = render.SetStencilZFailOperation
local render_SetStencilPassOperation = render.SetStencilPassOperation
local cam_Start3D = cam.Start3D
local ipairs = ipairs
local render_SetStencilReferenceValue = render.SetStencilReferenceValue
local IsValid = IsValid
local LocalPlayer = LocalPlayer
local cam_End3D = cam.End3D
local cam_Start2D = cam.Start2D
local surface_SetDrawColor = surface.SetDrawColor
local surface_DrawRect = surface.DrawRect
local ScrW = ScrW
local ScrH = ScrH
local cam_End2D = cam.End2D
local render_SetRenderTarget = render.SetRenderTarget
local render_SetMaterial = render.SetMaterial
local render_DrawScreenQuad = render.DrawScreenQuad
local render_DrawScreenQuadEx = render.DrawScreenQuadEx
local hook_Add = hook.Add
local hook_Run = hook.Run

minerva.outline = minerva.outline or {}

local List = {}
local RenderEnt = NULL

local CopyMat		= Material("pp/copy")
local OutlineMat	= CreateMaterial("OutlineMat","UnlitGeneric",{["$ignorez"] = 1,["$alphatest"] = 1})
local StoreTexture	= render_GetScreenEffectTexture(0)
local DrawTexture	= render_GetScreenEffectTexture(1)

--[[-------------------------------
	Modes:
	0 - Always draw
	1 - Draw if not visible
	2 - Draw if visible
--]]-------------------------------

OUTLINE_MODE_ALWAYS = 0
OUTLINE_MODE_NOT_VISIBLE = 1
OUTLINE_MODE_VISIBLE = 2

function minerva.outline:Render(ents,color,mode)
	if ( !istable(ents) ) then ents = {ents} end	--Support for passing Entity as first argument
	if ( table_IsEmpty(ents) ) then return end		--Do not pass empty tables
	if ( #List >= 255 ) then return end				--Maximum 255 reference values
	
	table_insert(List, {
		Ents = ents,
		Color = color,
		Mode = mode
	})
end

function RenderedEntity()
	return RenderEnt
end

local function Render()
	local scene = render_GetRenderTarget()
	render_CopyRenderTargetToTexture(StoreTexture)
	
	render_Clear(0,0,0,0,true,true)

	render_SetStencilEnable(true)
		cam_IgnoreZ(true)
		render_SuppressEngineLighting(true)
	
		render_SetStencilWriteMask(255)
		render_SetStencilTestMask(255)
		
		render_SetStencilCompareFunction(STENCIL_ALWAYS)
		render_SetStencilFailOperation(STENCIL_KEEP)
		render_SetStencilZFailOperation(STENCIL_REPLACE)
		render_SetStencilPassOperation(STENCIL_REPLACE)
		
		cam_Start3D()
			for k,v in ipairs(List) do
				render_SetStencilReferenceValue(k)
				
				for k2,v2 in ipairs(v.Ents) do
					if !IsValid(v2) then continue end
					
					local visible = LocalPlayer():IsLineOfSightClear(v2)

					if ( v2:GetNoDraw() ) then
						continue
					end

					if ( v.Mode==1 and visible ) or ( v.Mode==2 and !visible ) then continue end
					
					RenderEnt = v2
					v2:DrawModel()
					RenderEnt = NULL
				end
			end
		cam_End3D()
		
		render_SetStencilCompareFunction(STENCIL_EQUAL)
		
		cam_Start2D()
			for k,v in ipairs(List) do
				render_SetStencilReferenceValue(k)
				
				surface_SetDrawColor(v.Color)
				surface_DrawRect(0,0,ScrW(),ScrH())
			end
		cam_End2D()
		
		render_SuppressEngineLighting(false)
		cam_IgnoreZ(false)
	render_SetStencilEnable(false)
	
	render_CopyRenderTargetToTexture(DrawTexture)
	
	render_SetRenderTarget(scene)
	CopyMat:SetTexture("$basetexture",StoreTexture)
	render_SetMaterial(CopyMat)
	render_DrawScreenQuad()
	
	render_SetStencilEnable(true)
		render_SetStencilReferenceValue(0)
		render_SetStencilCompareFunction(STENCIL_EQUAL)
		
		OutlineMat:SetTexture("$basetexture",DrawTexture)
		render_SetMaterial(OutlineMat)
		
		for x=-1,1 do
			for y=-1,1 do
				if x==0 and x==0 then continue end
				
				render_DrawScreenQuadEx(x,y,ScrW(),ScrH())
			end
		end
	render_SetStencilEnable(false)
end

hook_Add("PostDrawEffects","RenderOutlines",function()
	hook_Run("PreDrawOutlines")
	
	if ( #List == 0 ) then return end
	
	Render()
	
	List = {}
end)