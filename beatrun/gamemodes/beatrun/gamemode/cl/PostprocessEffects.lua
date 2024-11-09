local postprocessenable = CreateClientConVar("Beatrun_PostprocessEffects", 0, true, false, "Enables silly ahh post-processing effects. EXPERIMENTAL.", 0, 1)

local function MyNeedsDepthPass()
	if !postprocessenable:GetBool() then return false end
	DOFModeHack(postprocessenable:GetBool())
    return true
end

-- Add hook so that the _rt_ResolvedFullFrameDepth texture is updated
hook.Add( "NeedsDepthPass", "MyNeedsDepthPass", MyNeedsDepthPass )

local blur_mat = Material('pp/bokehblur')
local BOKEN_FOCUS = 0
local BOKEN_FORCE = 0

cyclestate = false

hook.Add("RenderScreenspaceEffects", "funnybrdof", function()
	if !postprocessenable:GetBool() then return end
    local ply = LocalPlayer()

	render.UpdateScreenEffectTexture(1)

    if ply:GetSliding() or ply:GetClimbing() != 0 or ply:GetWallrun() == 1 or IsValid(ply:GetLadder()) then
		BOKEN_FORCE = math.Clamp(BOKEN_FORCE + 0.03 * (FrameTime() * 66), 0,2)
    else
    	BOKEN_FORCE = math.Clamp(BOKEN_FORCE - 0.03 * (FrameTime() * 66), 0,2)
    end
   
    blur_mat:SetTexture("$BASETEXTURE", render.GetScreenEffectTexture(1))
    blur_mat:SetTexture("$DEPTHTEXTURE", render.GetResolvedFullFrameDepth())
    
    blur_mat:SetFloat("$size", BOKEN_FORCE * 8)
    blur_mat:SetFloat("$focus", 0)
    blur_mat:SetFloat("$focusradius", 2 - 0.25 * 2)
    
    --render.SetMaterial(fbtexture)
    --render.DrawScreenQuadEx(0,0,960,540)
    render.SetMaterial(blur_mat)
    render.DrawScreenQuad()
    --render.DrawTextureToScreen(render.GetResolvedFullFrameDepth())
end)