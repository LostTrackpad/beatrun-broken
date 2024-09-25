-- This file has lots of strings that needs to be localized.

local buttonhints = CreateClientConVar("Beatrun_HUDButtonHints", "1", true, false, "Show button hints on the bottom-right of your display when enabled.", 0, 1)

local function GetFormattedKey(bind)
	string = input.LookupBinding(bind)

	if string == "MOUSE1" then string = "LMB"      -- Don't localize LMB and RMB. Maybe.
	elseif string == "MOUSE2" then string = "RMB"
	elseif string == "MOUSE3" then string = "Wheel Click" end

	if string then
		return string.upper(string)
	else
		return "UNBOUND"
	end
end

surface.CreateFont("BeatrunButtons", {
	shadow = true,
	blursize = 0,
	underline = false,
	rotary = false,
	strikeout = false,
	additive = false,
	antialias = false,
	extended = false,
	scanlines = 2,
	font = "x14y24pxHeadUpDaisy",
	italic = false,
	outline = false,
	symbol = false,
	weight = 500,
	size = ScreenScale(7)
})

surface.CreateFont("BeatrunButtonsSmall", {
	shadow = true,
	blursize = 0,
	underline = false,
	rotary = false,
	strikeout = false,
	additive = false,
	antialias = false,
	extended = false,
	scanlines = 2,
	font = "x14y24pxHeadUpDaisy",
	italic = false,
	outline = false,
	symbol = false,
	weight = 500,
	size = ScreenScale(6)
})

hook.Add("HUDPaint", "BeatrunButtonPrompts", function()
	if !buttonhints:GetBool() then return end
	local ply = LocalPlayer()

	if ply.FallStatic then return end -- you're certainly dead by that point, can't even do anything

	local text_color = string.ToColor(ply:GetInfo("Beatrun_HUDTextColor"))
	local box_color = string.ToColor(ply:GetInfo("Beatrun_HUDCornerColor"))

	local RestartAtCheckpoint = GetConVar("Beatrun_CPSave"):GetBool()

	local QuickturnGround = GetConVar("Beatrun_QuickturnGround"):GetBool()
	local QuickturnHandsOnly = GetConVar("Beatrun_QuickturnHandsOnly"):GetBool()
	
	local QuickturnSpecialCase = ply:GetClimbing() != 0 or ply:GetMantle() >= 4 or ply:GetWallrun() != 0 or IsValid(ply:GetLadder()) or ply:GetGrappling() or ply:GetDive() or ply:GetSliding() or IsValid(ply:GetBalanceEntity()) or IsValid(ply:GetZipline())
	-- Case-catcher (?) for when quickturn/sidestep prompt shouldn't appear.

	local ButtonsTable = {} -- initialize/clear button table

	surface.SetFont("BeatrunButtons")
	fontheight = select(2, surface.GetTextSize("Test String")) * 1.5

	if Course_Name != "" and RestartAtCheckpoint and ply:GetNW2Int("CPNum", -1) > 1 then
		ButtonsTable[#ButtonsTable + 1] = {"Restart From Checkpoint", {GetFormattedKey("+reload")}}
		ButtonsTable[#ButtonsTable + 1] = {"Restart Course", {GetFormattedKey("+reload"), "HELDPRESS"}}
	elseif Course_Name != "" then
		ButtonsTable[#ButtonsTable + 1] = {"Restart Course", {GetFormattedKey("+reload")}}
	end

	if ply:OnGround() and ply:UsingRH() and !QuickturnSpecialCase then
		ButtonsTable[#ButtonsTable + 1] = {"Quickstep", {GetFormattedKey("+attack2"), "AND", GetFormattedKey("+moveright"), "OR", GetFormattedKey("+moveleft")}}
	end

	if (!ply:OnGround() or QuickturnGround) and (ply:UsingRH() or (ply:notUsingRH() and !QuickturnHandsOnly)) and not QuickturnSpecialCase then
		ButtonsTable[#ButtonsTable + 1] = {"Quickturn", {GetFormattedKey("+attack2")}}
	end

	if !ply:OnGround() and ply:UsingRH() and not QuickturnSpecialCase then
		if !ply:GetDive() then
			ButtonsTable[#ButtonsTable + 1] = {"Dive", {GetFormattedKey("+duck"), "AND", GetFormattedKey("+attack2")}}
		end

		if !ply:GetCrouchJump() then
			ButtonsTable[#ButtonsTable + 1] = {"Coil", {GetFormattedKey("+duck")}}
		end
	end

	if !ply:OnGround() and !ply:GetCrouchJump() and !ply:GetDive() then
		if ply:GetVelocity():Length2D() > 220 and ply:GetVelocity().z <= -350 and !QuickturnSpecialCase then
			ButtonsTable[#ButtonsTable + 1] = {"Safety Roll", {GetFormattedKey("+duck"), "TIMEDPRESS"}}
		elseif ply:GetVelocity().z <= -350 and !QuickturnSpecialCase then
			ButtonsTable[#ButtonsTable + 1] = {"Safe Landing", {GetFormattedKey("+duck"), "TIMEDPRESS"}}
		end
	end

	if ply:GetMantle() == 2 then
		ButtonsTable[#ButtonsTable + 1] = {"Springboard", {GetFormattedKey("+jump"), "HELDPRESS"}}
	end

	if ply:GetClimbing() != 0 then
		local ang = EyeAngles()
		ang = math.abs(math.AngleDifference(ang.y, ply.wallang.y))

		ButtonsTable[#ButtonsTable + 1] = {"Move", {GetFormattedKey("+moveright"), "OR", GetFormattedKey("+moveleft")}}
		ButtonsTable[#ButtonsTable + 1] = {"Drop", {GetFormattedKey("+duck")}}
		if ang <= 42 then
			ButtonsTable[#ButtonsTable + 1] = {"Climb Up", {GetFormattedKey("+forward")}}
		else
			ButtonsTable[#ButtonsTable + 1] = {"Jump Off", {GetFormattedKey("+jump"), "AND", GetFormattedKey("+forward")}}
		end
	end

	if ply:GetWallrun() == 1 then
		ButtonsTable[#ButtonsTable + 1] = {"Quickturn", {GetFormattedKey("+attack2")}}
		ButtonsTable[#ButtonsTable + 1] = {"Cancel Wallclimb", {GetFormattedKey("+duck")}}
		ButtonsTable[#ButtonsTable + 1] = {"Side Jump", {GetFormattedKey("+jump"), "AND", GetFormattedKey("+moveright"), "OR", GetFormattedKey("+moveleft")}}
	elseif ply:GetWallrun() != 0 then
		ButtonsTable[#ButtonsTable + 1] = {"Quickturn", {GetFormattedKey("+attack2")}}
		ButtonsTable[#ButtonsTable + 1] = {"Cancel Wallclimb", {GetFormattedKey("+duck")}}
		ButtonsTable[#ButtonsTable + 1] = {"Jump", {GetFormattedKey("+jump")}}
	end

	if IsValid(ply:GetLadder()) then
		local tr = ply.LadderTrace
		tr.output = ply.LadderTraceOut
		tr.start = ply:GetPos() + Vector(0, 0, 64)
		tr.endpos = tr.start + EyeAngles():Forward() * 100
		tr.filter = ply
		util.TraceLine(tr)
		local fraction = ply.LadderTraceOut.Fraction

		if ((fraction or 1) <= 0.35) then
			ButtonsTable[#ButtonsTable + 1] = {"Climb Up", {GetFormattedKey("+forward"), "HELDPRESS"}}
		else
			ButtonsTable[#ButtonsTable + 1] = {"Jump", {GetFormattedKey("+forward"), "AND", GetFormattedKey("+jump")}}
		end

		ButtonsTable[#ButtonsTable + 1] = {"Slide Down", {GetFormattedKey("+back"), "HELDPRESS"}}
		ButtonsTable[#ButtonsTable + 1] = {"Drop", {GetFormattedKey("+duck")}}
	elseif IsValid(ply:GetBalanceEntity()) then
		ButtonsTable[#ButtonsTable + 1] = {"Balance", {GetFormattedKey("+moveright"), "OR", GetFormattedKey("+moveleft")}}
		ButtonsTable[#ButtonsTable + 1] = {"Turn Around", {GetFormattedKey("+attack2")}}
		ButtonsTable[#ButtonsTable + 1] = {"Move Forward", {GetFormattedKey("+forward")}}
	elseif IsValid(ply:GetZipline()) then
		ButtonsTable[#ButtonsTable + 1] = {"Drop", {GetFormattedKey("+duck")}}
	elseif ply:GetGrappling() then
		ButtonsTable[#ButtonsTable + 1] = {"Jump", {GetFormattedKey("+jump")}}
		ButtonsTable[#ButtonsTable + 1] = {"Extend Grapple", {GetFormattedKey("+attack2")}}
		ButtonsTable[#ButtonsTable + 1] = {"Shorten Grapple", {GetFormattedKey("+attack")}}
	end

	for i=1,#ButtonsTable do
		local ButtonOrder = i
		local LineOffset = math.max(ButtonOrder - 1, 0)
		local ContainsSpecialText = false

		tw = 0
		for i=1,#ButtonsTable[ButtonOrder][2] do
			if ButtonsTable[ButtonOrder][2][i] == "TIMEDPRESS" then
				draw.DrawText("(Timed)", "BeatrunButtonsSmall", ScrW() - ScreenScaleH(10) - tw - ScreenScaleH(2), ScrH() - ScreenScaleH(10) - fontheight * (1 + LineOffset), text_color, TEXT_ALIGN_RIGHT)
				tw = tw + surface.GetTextSize("(Timed)")
				ContainsSpecialText = true
			elseif ButtonsTable[ButtonOrder][2][i] == "HELDPRESS" then
				draw.DrawText("(Hold)", "BeatrunButtonsSmall", ScrW() - ScreenScaleH(10) - tw - ScreenScaleH(2), ScrH() - ScreenScaleH(10) - fontheight * (1 + LineOffset), text_color, TEXT_ALIGN_RIGHT)
				tw = tw + surface.GetTextSize("(Hold)")
				ContainsSpecialText = true
			elseif ButtonsTable[ButtonOrder][2][i] == "OR" then
				draw.DrawText("/", "BeatrunButtons", ScrW() - ScreenScaleH(10) - tw, ScrH() - ScreenScaleH(10) - fontheight * (1 + LineOffset), text_color, TEXT_ALIGN_RIGHT)
				tw = tw + surface.GetTextSize("/")
			elseif ButtonsTable[ButtonOrder][2][i] == "AND" then
				draw.DrawText("+", "BeatrunButtons", ScrW() - ScreenScaleH(10) - tw, ScrH() - ScreenScaleH(10) - fontheight * (1 + LineOffset), text_color, TEXT_ALIGN_RIGHT)
				tw = tw + surface.GetTextSize("+")
			elseif ContainsSpecialText then
				draw.WordBox(ScreenScaleH(2), ScrW() - ScreenScaleH(10) - tw, ScrH() - fontheight * (1 + LineOffset) - ScreenScaleH(10) - ScreenScaleH(1), ButtonsTable[ButtonOrder][2][i], "BeatrunButtons", box_color, text_color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
				tw = tw + surface.GetTextSize(ButtonsTable[ButtonOrder][2][i]) + ScreenScaleH(2) * 2
			else
				draw.WordBox(ScreenScaleH(2), ScrW() - ScreenScaleH(10) - tw, ScrH() - fontheight * (1 + LineOffset) - ScreenScaleH(10) - ScreenScaleH(2), ButtonsTable[ButtonOrder][2][i], "BeatrunButtons", box_color, text_color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
				tw = tw + surface.GetTextSize(ButtonsTable[ButtonOrder][2][i]) + ScreenScaleH(2) * 2
			end
		end

		draw.DrawText(ButtonsTable[ButtonOrder][1], "BeatrunButtons", ScrW() - ScreenScaleH(10) - tw - ScreenScaleH(4), ScrH() - ScreenScaleH(10) - fontheight * (1 + LineOffset), text_color, TEXT_ALIGN_RIGHT)
	end
end)