local running = false
local fovtest = CreateClientConVar("beatrun_fovtesting", 0, true, false, "", 0, 1)

function ModifyFOV(ply, opos, oang, ofov, ...)
    local view = hook.Run("CalcView", ply, opos, oang, ofov, ...)
    
    view.fov = math.Remap(view.fov or ofov, 20, GetConVar("fov_desired"):GetInt(), 20, GetConVar("beatrun_fov"):GetInt())

    return view
end

hook.Add("PostRender", "Beatrun FoV Repeat Check", function()
    running = false
end)

hook.Add("CalcView", "Beatrun FoV Handler", function(ply, pos, ang, fov, ...)
    if !fovtest:GetBool() then return end
    if running == true then return end -- Prevent infinite loops
    running = true
    beatrunview = ModifyFOV(ply,pos,ang,fov,...) or {ply, pos, ang, fov}
    return beatrunview
end)