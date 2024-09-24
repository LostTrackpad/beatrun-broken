-- This file has lots of strings that needs to be localized.

local buttonhints = CreateClientConVar("Beatrun_HUDButtonHints", "1", true, false, "Show button hints on the bottom-right of your display when enabled.", 0, 1)

local function GetValidKey(bind)
	string = input.LookupBinding(bind)

	if string == "MOUSE1" then string = "LMB"      -- Don't localize LMB and RMB. Maybe.
	elseif string == "MOUSE2" then string = "RMB"
	elseif string == "MOUSE3" then string = "Wheel Click" end

	if string then
		return string
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
	local wep = ply:GetActiveWeapon()
	if !ply:Alive() or !IsValid(wep) then return end
	local text_color = string.ToColor(ply:GetInfo("Beatrun_HUDTextColor"))
	local box_color = string.ToColor(ply:GetInfo("Beatrun_HUDCornerColor"))

	local QuickturnGround = GetConVar("Beatrun_QuickturnGround"):GetBool()
	local QuickturnHandsOnly = GetConVar("Beatrun_QuickturnHandsOnly"):GetBool()
	
	local QuickturnSpecialCase = ply:GetClimbing() != 0 or ply:GetMantle() >= 4 or ply:GetWallrun() != 0 or IsValid(ply:GetLadder()) or ply:GetGrappling() or ply:GetDive() or ply:GetSliding() or IsValid(ply:GetBalanceEntity()) or IsValid(ply:GetZipline())
	-- Case-catcher (?) for when quickturn/sidestep prompt shouldn't appear.

	surface.SetFont("BeatrunButtons")
	fontheight = select(2, surface.GetTextSize("Test String")) * 1.5

	if ply:OnGround() and wep:GetClass() == "runnerhands" and not QuickturnSpecialCase then
		draw.WordBox(ScreenScaleH(2), ScrW() - ScreenScaleH(10), ScrH() - fontheight - ScreenScaleH(10) - ScreenScaleH(2), string.upper(GetValidKey("+attack2")), "BeatrunButtons", box_color, text_color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
		tw = select(1, surface.GetTextSize(string.upper(GetValidKey("+attack2")))) + ScreenScaleH(4)
		draw.DrawText("+", "BeatrunButtons", ScrW() - ScreenScaleH(10) - tw, ScrH() - ScreenScaleH(10) - fontheight, text_color, 	TEXT_ALIGN_RIGHT)
		tw = tw + select(1, surface.GetTextSize("+"))
		draw.WordBox(ScreenScaleH(2), ScrW() - ScreenScaleH(10) - tw, ScrH() - fontheight - ScreenScaleH(10) - ScreenScaleH(2), string.upper(GetValidKey("+moveright")), "BeatrunButtons", box_color, text_color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
		tw = tw + select(1, surface.GetTextSize(string.upper(GetValidKey("+moveright")))) + ScreenScaleH(4)
		draw.DrawText("/", "BeatrunButtons", ScrW() - ScreenScaleH(10) - tw, ScrH() - ScreenScaleH(10) - fontheight, text_color, 	TEXT_ALIGN_RIGHT)
		tw = tw + select(1, surface.GetTextSize("/"))
		draw.WordBox(ScreenScaleH(2), ScrW() - tw - ScreenScaleH(10), ScrH() - ScreenScaleH(10) - ScreenScaleH(2) - fontheight, string.upper(GetValidKey("+moveleft")), "BeatrunButtons", box_color, text_color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
		tw = tw + select(1, surface.GetTextSize(string.upper(GetValidKey("+moveleft"))))
		draw.DrawText("Sidestep ", "BeatrunButtons", ScrW() - ScreenScaleH(10) - tw - ScreenScaleH(4), ScrH() - fontheight - ScreenScaleH(10), 	text_color, TEXT_ALIGN_RIGHT)
	end

	if (!ply:OnGround() and !QuickturnSpecialCase and wep:GetClass() == "runnerhands") or (wep:GetClass() != "runnerhands" and not QuickturnHandsOnly and (!ply:OnGround() or QuickturnGround)) then
		if !ply:GetCrouchJump() then
			draw.WordBox(ScreenScaleH(2), ScrW() - ScreenScaleH(10), ScrH() - ScreenScaleH(10) - ScreenScaleH(2) - fontheight * 3, string.upper(GetValidKey("+duck")), "BeatrunButtons", box_color, text_color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			tw = select(1, surface.GetTextSize(string.upper(GetValidKey("+duck"))))
			draw.DrawText("Coil ", "BeatrunButtons", ScrW() - ScreenScaleH(10) - tw - ScreenScaleH(4), ScrH() - fontheight * 3 - ScreenScaleH(10), text_color, TEXT_ALIGN_RIGHT)
		end

		draw.WordBox(ScreenScaleH(2), ScrW() - ScreenScaleH(10), ScrH() - fontheight * 2 - ScreenScaleH(10) - ScreenScaleH(2), string.upper(GetValidKey("+attack2")), "BeatrunButtons", box_color, text_color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
		tw = select(1, surface.GetTextSize(string.upper(GetValidKey("+attack2")))) + ScreenScaleH(4)
		draw.DrawText("+", "BeatrunButtons", ScrW() - ScreenScaleH(10) - tw, ScrH() - ScreenScaleH(10) - fontheight * 2, text_color, 	TEXT_ALIGN_RIGHT)
		tw = tw + select(1, surface.GetTextSize("+"))
		draw.WordBox(ScreenScaleH(2), ScrW() - ScreenScaleH(10) - tw, ScrH() - fontheight * 2 - ScreenScaleH(10) - ScreenScaleH(2), string.upper(GetValidKey("+duck")), "BeatrunButtons", box_color, text_color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
		tw = tw + select(1, surface.GetTextSize(string.upper(GetValidKey("+duck")))) + ScreenScaleH(4)
		draw.DrawText("Dive ", "BeatrunButtons", ScrW() - ScreenScaleH(10) - tw - ScreenScaleH(4), ScrH() - fontheight * 2 - ScreenScaleH(10), 	text_color, TEXT_ALIGN_RIGHT)

		draw.WordBox(ScreenScaleH(2), ScrW() - ScreenScaleH(10), ScrH() - ScreenScaleH(10) - ScreenScaleH(2) - fontheight, string.upper(GetValidKey("+attack2")), "BeatrunButtons", box_color, text_color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
		tw = select(1, surface.GetTextSize(string.upper(GetValidKey("+attack2"))))
		draw.DrawText("Quickturn ", "BeatrunButtons", ScrW() - ScreenScaleH(10) - tw - ScreenScaleH(4), ScrH() - fontheight - ScreenScaleH(10), text_color, TEXT_ALIGN_RIGHT)
	elseif ply:OnGround() and QuickturnGround and !QuickturnSpecialCase and wep:GetClass() == "runnerhands" then 
		draw.WordBox(ScreenScaleH(2), ScrW() - ScreenScaleH(10), ScrH() - ScreenScaleH(10) - ScreenScaleH(2) - fontheight * 2, string.upper(GetValidKey("+attack2")), "BeatrunButtons", box_color, text_color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
		tw = select(1, surface.GetTextSize(string.upper(GetValidKey("+attack2"))))
		draw.DrawText("Quickturn ", "BeatrunButtons", ScrW() - ScreenScaleH(10) - tw - ScreenScaleH(4), ScrH() - fontheight * 2 - ScreenScaleH(10), text_color, TEXT_ALIGN_RIGHT)
	end

	if !ply:OnGround() and !ply:GetDive() and !ply:GetCrouchJump() then
		if !ply:OnGround() and ply:GetVelocity():Length2D() > 220 and ply:GetVelocity().z <= -450 and !QuickturnSpecialCase then
			draw.WordBox(ScreenScaleH(2), ScrW() - ScreenScaleH(10), ScrH() - ScreenScaleH(10) - ScreenScaleH(2) - fontheight * 4, string.upper(GetValidKey("+duck")), "BeatrunButtons", box_color, text_color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			tw = select(1, surface.GetTextSize(string.upper(GetValidKey("+duck"))))
			draw.DrawText("Safety Roll (Timed) ", "BeatrunButtons", ScrW() - ScreenScaleH(10) - tw - ScreenScaleH(4), ScrH() - fontheight * 4 - ScreenScaleH(10), text_color, TEXT_ALIGN_RIGHT)
		elseif !ply:OnGround() and ply:GetVelocity().z <= -450 and !QuickturnSpecialCase then
			draw.WordBox(ScreenScaleH(2), ScrW() - ScreenScaleH(10), ScrH() - ScreenScaleH(10) - ScreenScaleH(2) - fontheight * 4, string.upper(GetValidKey("+duck")), "BeatrunButtons", box_color, text_color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			tw = select(1, surface.GetTextSize(string.upper(GetValidKey("+duck"))))
			draw.DrawText("Safe Landing ", "BeatrunButtons", ScrW() - ScreenScaleH(10) - tw - ScreenScaleH(4), ScrH() - fontheight * 4 - ScreenScaleH(10), text_color, TEXT_ALIGN_RIGHT)
		end
		
		if ply:GetMantle() == 2 and ply:GetVelocity().z <= -450 then
			draw.WordBox(ScreenScaleH(2), ScrW() - ScreenScaleH(10), ScrH() - ScreenScaleH(10) - ScreenScaleH(2) - fontheight * 5, string.upper(GetValidKey("+jump")), "BeatrunButtons", box_color, text_color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			tw = select(1, surface.GetTextSize(string.upper(GetValidKey("+jump"))))
			draw.DrawText("Springboard (Hold) ", "BeatrunButtons", ScrW() - ScreenScaleH(10) - tw - ScreenScaleH(4), ScrH() - fontheight * 5 - ScreenScaleH(10), text_color, TEXT_ALIGN_RIGHT)
		elseif ply:GetMantle() == 2 then
			draw.WordBox(ScreenScaleH(2), ScrW() - ScreenScaleH(10), ScrH() - ScreenScaleH(10) - ScreenScaleH(2) - fontheight * 4, string.upper(GetValidKey("+jump")), "BeatrunButtons", box_color, text_color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			tw = select(1, surface.GetTextSize(string.upper(GetValidKey("+jump"))))
			draw.DrawText("Springboard (Hold) ", "BeatrunButtons", ScrW() - ScreenScaleH(10) - tw - ScreenScaleH(4), ScrH() - fontheight * 4 - ScreenScaleH(10), text_color, TEXT_ALIGN_RIGHT)
		end
	elseif !ply:OnGround() and !ply:GetDive() then
		if !ply:OnGround() and ply:GetVelocity():Length2D() > 220 and ply:GetVelocity().z <= -450 and !QuickturnSpecialCase then
			draw.WordBox(ScreenScaleH(2), ScrW() - ScreenScaleH(10), ScrH() - ScreenScaleH(10) - ScreenScaleH(2) - fontheight * 3, string.upper(GetValidKey("+duck")), "BeatrunButtons", box_color, text_color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			tw = select(1, surface.GetTextSize(string.upper(GetValidKey("+duck"))))
			draw.DrawText("Safety Roll (Timed) ", "BeatrunButtons", ScrW() - ScreenScaleH(10) - tw - ScreenScaleH(4), ScrH() - fontheight * 3 - ScreenScaleH(10), text_color, TEXT_ALIGN_RIGHT)
		elseif !ply:OnGround() and ply:GetVelocity().z <= -450 and !QuickturnSpecialCase then
			draw.WordBox(ScreenScaleH(2), ScrW() - ScreenScaleH(10), ScrH() - ScreenScaleH(10) - ScreenScaleH(2) - fontheight * 3, string.upper(GetValidKey("+duck")), "BeatrunButtons", box_color, text_color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			tw = select(1, surface.GetTextSize(string.upper(GetValidKey("+duck"))))
			draw.DrawText("Safe Landing (Timed) ", "BeatrunButtons", ScrW() - ScreenScaleH(10) - tw - ScreenScaleH(4), ScrH() - fontheight * 3 - ScreenScaleH(10), text_color, TEXT_ALIGN_RIGHT)
		end

		if ply:GetMantle() == 2 and ply:GetVelocity().z <= -450 then
			draw.WordBox(ScreenScaleH(2), ScrW() - ScreenScaleH(10), ScrH() - ScreenScaleH(10) - ScreenScaleH(2) - fontheight * 5, string.upper(GetValidKey("+jump")), "BeatrunButtons", box_color, text_color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			tw = select(1, surface.GetTextSize(string.upper(GetValidKey("+jump"))))
			draw.DrawText("Springboard (Hold) ", "BeatrunButtons", ScrW() - ScreenScaleH(10) - tw - ScreenScaleH(4), ScrH() - fontheight * 5 - ScreenScaleH(10), text_color, TEXT_ALIGN_RIGHT)
		elseif ply:GetMantle() == 2 then
			draw.WordBox(ScreenScaleH(2), ScrW() - ScreenScaleH(10), ScrH() - ScreenScaleH(10) - ScreenScaleH(2) - fontheight * 4, string.upper(GetValidKey("+jump")), "BeatrunButtons", box_color, text_color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			tw = select(1, surface.GetTextSize(string.upper(GetValidKey("+jump"))))
			draw.DrawText("Springboard (Hold) ", "BeatrunButtons", ScrW() - ScreenScaleH(10) - tw - ScreenScaleH(4), ScrH() - fontheight * 4 - ScreenScaleH(10), text_color, TEXT_ALIGN_RIGHT)
		end
	elseif ply:GetMantle() == 2 then
		draw.WordBox(ScreenScaleH(2), ScrW() - ScreenScaleH(10), ScrH() - ScreenScaleH(10) - ScreenScaleH(2) - fontheight * 3, string.upper(GetValidKey("+jump")), "BeatrunButtons", box_color, text_color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
		tw = select(1, surface.GetTextSize(string.upper(GetValidKey("+jump"))))
		draw.DrawText("Springboard (Hold) ", "BeatrunButtons", ScrW() - ScreenScaleH(10) - tw - ScreenScaleH(4), ScrH() - fontheight * 3 - ScreenScaleH(10), text_color, TEXT_ALIGN_RIGHT)
	end

	if ply:GetClimbing() != 0 then
		draw.WordBox(ScreenScaleH(2), ScrW() - ScreenScaleH(10), ScrH() - ScreenScaleH(10) - ScreenScaleH(2) - fontheight * 2, string.upper(GetValidKey("+duck")), "BeatrunButtons", box_color, text_color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
		tw = select(1, surface.GetTextSize(string.upper(GetValidKey("+duck"))))
		draw.DrawText("Drop ", "BeatrunButtons", ScrW() - ScreenScaleH(10) - tw - ScreenScaleH(4), ScrH() - fontheight * 2 - ScreenScaleH(10), text_color, TEXT_ALIGN_RIGHT)
		
		local ang = EyeAngles()
		ang = math.abs(math.AngleDifference(ang.y, ply.wallang.y))
		if ang <= 42 then
			draw.WordBox(ScreenScaleH(2), ScrW() - ScreenScaleH(10), ScrH() - ScreenScaleH(10) - ScreenScaleH(2) - fontheight, string.upper(GetValidKey("+forward")), "BeatrunButtons", box_color, text_color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			tw = select(1, surface.GetTextSize(string.upper(GetValidKey("+forward"))))
			draw.DrawText("Climb Up ", "BeatrunButtons", ScrW() - ScreenScaleH(10) - tw - ScreenScaleH(4), ScrH() - fontheight - ScreenScaleH(10), text_color, TEXT_ALIGN_RIGHT)
		else
			draw.WordBox(ScreenScaleH(2), ScrW() - ScreenScaleH(10), ScrH() - ScreenScaleH(10) - ScreenScaleH(2) - fontheight, string.upper(GetValidKey("+jump")), "BeatrunButtons", box_color, text_color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			tw = select(1, surface.GetTextSize(string.upper(GetValidKey("+jump"))))
			draw.DrawText("Jump Off ", "BeatrunButtons", ScrW() - ScreenScaleH(10) - tw - ScreenScaleH(4), ScrH() - fontheight - ScreenScaleH(10), text_color, TEXT_ALIGN_RIGHT)
		end

		tw = 0
		draw.WordBox(ScreenScaleH(2), ScrW() - ScreenScaleH(10) - tw, ScrH() - fontheight * 3 - ScreenScaleH(10) - ScreenScaleH(2), string.upper(GetValidKey("+moveright")), "BeatrunButtons", box_color, text_color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
		tw = tw + select(1, surface.GetTextSize(string.upper(GetValidKey("+moveright")))) + ScreenScaleH(4)
		draw.DrawText("/", "BeatrunButtons", ScrW() - ScreenScaleH(10) - tw, ScrH() - ScreenScaleH(10) - fontheight * 3, text_color, 	TEXT_ALIGN_RIGHT)
		tw = tw + select(1, surface.GetTextSize("/"))
		draw.WordBox(ScreenScaleH(2), ScrW() - tw - ScreenScaleH(10), ScrH() - ScreenScaleH(10) - ScreenScaleH(2) - fontheight * 3, string.upper(GetValidKey("+moveleft")), "BeatrunButtons", box_color, text_color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
		tw = tw + select(1, surface.GetTextSize(string.upper(GetValidKey("+moveleft"))))
		draw.DrawText("Move ", "BeatrunButtons", ScrW() - ScreenScaleH(10) - tw - ScreenScaleH(4), ScrH() - fontheight * 3 - ScreenScaleH(10), 	text_color, TEXT_ALIGN_RIGHT)
	end

	if ply:GetWallrun() == 1 then
		draw.WordBox(ScreenScaleH(2), ScrW() - ScreenScaleH(10), ScrH() - fontheight * 3 - ScreenScaleH(10) - ScreenScaleH(2), string.upper	(GetValidKey("+jump")), "BeatrunButtons", box_color, text_color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
		tw = select(1, surface.GetTextSize(string.upper(GetValidKey("+jump")))) + ScreenScaleH(4)
		draw.DrawText("+", "BeatrunButtons", ScrW() - ScreenScaleH(10) - tw, ScrH() - ScreenScaleH(10) - fontheight * 3, text_color, 	TEXT_ALIGN_RIGHT)
		tw = tw + select(1, surface.GetTextSize("+"))
		draw.WordBox(ScreenScaleH(2), ScrW() - ScreenScaleH(10) - tw, ScrH() - fontheight * 3 - ScreenScaleH(10) - ScreenScaleH(2), string.upper(GetValidKey("+moveright")), "BeatrunButtons", box_color, text_color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
		tw = tw + select(1, surface.GetTextSize(string.upper(GetValidKey("+moveright")))) + ScreenScaleH(4)
		draw.DrawText("/", "BeatrunButtons", ScrW() - ScreenScaleH(10) - tw, ScrH() - ScreenScaleH(10) - fontheight * 3, text_color, 	TEXT_ALIGN_RIGHT)
		tw = tw + select(1, surface.GetTextSize("/"))
		draw.WordBox(ScreenScaleH(2), ScrW() - tw - ScreenScaleH(10), ScrH() - ScreenScaleH(10) - ScreenScaleH(2) - fontheight * 3, string.upper(GetValidKey("+moveleft")), "BeatrunButtons", box_color, text_color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
		tw = tw + select(1, surface.GetTextSize(string.upper(GetValidKey("+moveleft"))))
		draw.DrawText("Side Jump ", "BeatrunButtons", ScrW() - ScreenScaleH(10) - tw - ScreenScaleH(4), ScrH() - fontheight * 3 - ScreenScaleH(10), text_color, TEXT_ALIGN_RIGHT)

		draw.WordBox(ScreenScaleH(2), ScrW() - ScreenScaleH(10), ScrH() - ScreenScaleH(10) - ScreenScaleH(2) - fontheight * 2, string.upper(GetValidKey("+duck")), "BeatrunButtons", box_color, text_color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
		tw = select(1, surface.GetTextSize(string.upper(GetValidKey("+duck"))))
		draw.DrawText("Cancel Wallclimb ", "BeatrunButtons", ScrW() - ScreenScaleH(10) - tw - ScreenScaleH(4), ScrH() - fontheight * 2 - ScreenScaleH(10), text_color, TEXT_ALIGN_RIGHT)

		draw.WordBox(ScreenScaleH(2), ScrW() - ScreenScaleH(10), ScrH() - ScreenScaleH(10) - ScreenScaleH(2) - fontheight, string.upper(GetValidKey("+attack2")), "BeatrunButtons", box_color, text_color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
		tw = select(1, surface.GetTextSize(string.upper(GetValidKey("+attack2"))))
		draw.DrawText("Quickturn (180°) ", "BeatrunButtons", ScrW() - ScreenScaleH(10) - tw - ScreenScaleH(4), ScrH() - fontheight - ScreenScaleH(10), text_color, TEXT_ALIGN_RIGHT)
	elseif ply:GetWallrun() != 0 then
		draw.WordBox(ScreenScaleH(2), ScrW() - ScreenScaleH(10), ScrH() - ScreenScaleH(10) - ScreenScaleH(2) - fontheight * 4, string.upper(GetValidKey("+attack")), "BeatrunButtons", box_color, text_color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
		tw = select(1, surface.GetTextSize(string.upper(GetValidKey("+attack"))))
		draw.DrawText("Attack (Kickglitch) ", "BeatrunButtons", ScrW() - ScreenScaleH(10) - tw - ScreenScaleH(4), ScrH() - fontheight * 4 - ScreenScaleH(10), text_color, TEXT_ALIGN_RIGHT)

		draw.WordBox(ScreenScaleH(2), ScrW() - ScreenScaleH(10), ScrH() - ScreenScaleH(10) - ScreenScaleH(2) - fontheight * 3, string.upper(GetValidKey("+jump")), "BeatrunButtons", box_color, text_color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
		tw = select(1, surface.GetTextSize(string.upper(GetValidKey("+jump"))))
		draw.DrawText("Jump Off ", "BeatrunButtons", ScrW() - ScreenScaleH(10) - tw - ScreenScaleH(4), ScrH() - fontheight * 3 - ScreenScaleH(10), text_color, TEXT_ALIGN_RIGHT)

		draw.WordBox(ScreenScaleH(2), ScrW() - ScreenScaleH(10), ScrH() - ScreenScaleH(10) - ScreenScaleH(2) - fontheight * 2, string.upper(GetValidKey("+duck")), "BeatrunButtons", box_color, text_color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
		tw = select(1, surface.GetTextSize(string.upper(GetValidKey("+duck"))))
		draw.DrawText("Cancel Wallrun ", "BeatrunButtons", ScrW() - ScreenScaleH(10) - tw - ScreenScaleH(4), ScrH() - fontheight * 2 - ScreenScaleH(10), text_color, TEXT_ALIGN_RIGHT)

		draw.WordBox(ScreenScaleH(2), ScrW() - ScreenScaleH(10), ScrH() - ScreenScaleH(10) - ScreenScaleH(2) - fontheight, string.upper(GetValidKey("+attack2")), "BeatrunButtons", box_color, text_color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
		tw = select(1, surface.GetTextSize(string.upper(GetValidKey("+attack2"))))
		draw.DrawText("Quickturn (90°) ", "BeatrunButtons", ScrW() - ScreenScaleH(10) - tw - ScreenScaleH(4), ScrH() - fontheight - ScreenScaleH(10), text_color, TEXT_ALIGN_RIGHT)
	end

	if IsValid(ply:GetLadder()) then
		local tr = ply.LadderTrace
		tr.output = ply.LadderTraceOut
		tr.start = ply:GetPos() + Vector(0, 0, 64)
		tr.endpos = tr.start + EyeAngles():Forward() * 100
		tr.filter = ply
		util.TraceLine(tr)
		local fraction = ply.LadderTraceOut.Fraction

		tw = 0
		if ((fraction or 1) <= 0.35) then
			draw.WordBox(ScreenScaleH(2), ScrW() - ScreenScaleH(10), ScrH() - ScreenScaleH(10) - ScreenScaleH(2) - fontheight * 3, string.upper(GetValidKey("+forward")), "BeatrunButtons", box_color, text_color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			tw = tw + select(1, surface.GetTextSize(string.upper(GetValidKey("+forward"))))
			draw.DrawText("Climb (Hold) ", "BeatrunButtons", ScrW() - ScreenScaleH(10) - tw - ScreenScaleH(4), ScrH() - fontheight * 3 - ScreenScaleH(10), text_color, TEXT_ALIGN_RIGHT)
		else
			draw.WordBox(ScreenScaleH(2), ScrW() - ScreenScaleH(10), ScrH() - fontheight * 3 - ScreenScaleH(10) - ScreenScaleH(2), string.upper	(GetValidKey("+jump")), "BeatrunButtons", box_color, text_color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			tw = select(1, surface.GetTextSize(string.upper(GetValidKey("+jump")))) + ScreenScaleH(4)
			draw.DrawText("+", "BeatrunButtons", ScrW() - ScreenScaleH(10) - tw, ScrH() - ScreenScaleH(10) - fontheight * 3, text_color, 	TEXT_ALIGN_RIGHT)
			tw = tw + select(1, surface.GetTextSize("+"))	
			draw.WordBox(ScreenScaleH(2), ScrW() - ScreenScaleH(10) - tw, ScrH() - ScreenScaleH(10) - ScreenScaleH(2) - fontheight * 3, string.upper(GetValidKey("+forward")), "BeatrunButtons", box_color, text_color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			tw = tw + select(1, surface.GetTextSize(string.upper(GetValidKey("+forward"))))
			draw.DrawText("Jump ", "BeatrunButtons", ScrW() - ScreenScaleH(10) - tw - ScreenScaleH(4), ScrH() - fontheight * 3 - ScreenScaleH(10), text_color, TEXT_ALIGN_RIGHT)
		end

		draw.WordBox(ScreenScaleH(2), ScrW() - ScreenScaleH(10), ScrH() - ScreenScaleH(10) - ScreenScaleH(2) - fontheight * 2, string.upper(GetValidKey("+duck")), "BeatrunButtons", box_color, text_color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
		tw = select(1, surface.GetTextSize(string.upper(GetValidKey("+duck"))))
		draw.DrawText("Drop ", "BeatrunButtons", ScrW() - ScreenScaleH(10) - tw - ScreenScaleH(4), ScrH() - fontheight * 2 - ScreenScaleH(10), text_color, TEXT_ALIGN_RIGHT)

		draw.WordBox(ScreenScaleH(2), ScrW() - ScreenScaleH(10), ScrH() - ScreenScaleH(10) - ScreenScaleH(2) - fontheight, string.upper(GetValidKey("+attack2")), "BeatrunButtons", box_color, text_color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
		tw = select(1, surface.GetTextSize(string.upper(GetValidKey("+attack2"))))
		draw.DrawText("Quickturn ", "BeatrunButtons", ScrW() - ScreenScaleH(10) - tw - ScreenScaleH(4), ScrH() - fontheight - ScreenScaleH(10), text_color, TEXT_ALIGN_RIGHT)
	end

	if ply:GetGrappling() then
		draw.WordBox(ScreenScaleH(2), ScrW() - ScreenScaleH(10), ScrH() - ScreenScaleH(10) - ScreenScaleH(2) - fontheight * 3, string.upper(GetValidKey("+attack")), "BeatrunButtons", box_color, text_color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
		tw = select(1, surface.GetTextSize(string.upper(GetValidKey("+attack"))))
		draw.DrawText("Shorten Grapple ", "BeatrunButtons", ScrW() - ScreenScaleH(10) - tw - ScreenScaleH(4), ScrH() - fontheight * 3 - ScreenScaleH(10), text_color, TEXT_ALIGN_RIGHT)

		draw.WordBox(ScreenScaleH(2), ScrW() - ScreenScaleH(10), ScrH() - ScreenScaleH(10) - ScreenScaleH(2) - fontheight * 2, string.upper(GetValidKey("+attack2")), "BeatrunButtons", box_color, text_color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
		tw = select(1, surface.GetTextSize(string.upper(GetValidKey("+attack2"))))
		draw.DrawText("Extend Grapple ", "BeatrunButtons", ScrW() - ScreenScaleH(10) - tw - ScreenScaleH(4), ScrH() - fontheight * 2 - ScreenScaleH(10), text_color, TEXT_ALIGN_RIGHT)

		draw.WordBox(ScreenScaleH(2), ScrW() - ScreenScaleH(10), ScrH() - ScreenScaleH(10) - ScreenScaleH(2) - fontheight, string.upper(GetValidKey("+jump")), "BeatrunButtons", box_color, text_color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
		tw = select(1, surface.GetTextSize(string.upper(GetValidKey("+jump"))))
		draw.DrawText("Jump Off ", "BeatrunButtons", ScrW() - ScreenScaleH(10) - tw - ScreenScaleH(4), ScrH() - fontheight - ScreenScaleH(10), text_color, TEXT_ALIGN_RIGHT)
	end

	if IsValid(ply:GetBalanceEntity()) then
		draw.WordBox(ScreenScaleH(2), ScrW() - ScreenScaleH(10), ScrH() - fontheight * 2 - ScreenScaleH(10) - ScreenScaleH(2), string.upper(GetValidKey("+moveright")), "BeatrunButtons", box_color, text_color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
		tw = select(1, surface.GetTextSize(string.upper(GetValidKey("+moveright")))) + ScreenScaleH(4)
		draw.DrawText("/", "BeatrunButtons", ScrW() - ScreenScaleH(10) - tw, ScrH() - ScreenScaleH(10) - fontheight * 2, text_color, 	TEXT_ALIGN_RIGHT)
		tw = tw + select(1, surface.GetTextSize("/"))
		draw.WordBox(ScreenScaleH(2), ScrW() - tw - ScreenScaleH(10), ScrH() - ScreenScaleH(10) - ScreenScaleH(2) - fontheight * 2, string.upper(GetValidKey("+moveleft")), "BeatrunButtons", box_color, text_color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
		tw = tw + select(1, surface.GetTextSize(string.upper(GetValidKey("+moveleft"))))
		draw.DrawText("Balance ", "BeatrunButtons", ScrW() - ScreenScaleH(10) - tw - ScreenScaleH(4), ScrH() - fontheight * 2 - ScreenScaleH(10), 	text_color, TEXT_ALIGN_RIGHT)

		draw.WordBox(ScreenScaleH(2), ScrW() - ScreenScaleH(10), ScrH() - ScreenScaleH(10) - ScreenScaleH(2) - fontheight, string.upper(GetValidKey("+attack2")), "BeatrunButtons", box_color, text_color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
		tw = select(1, surface.GetTextSize(string.upper(GetValidKey("+attack2"))))
		draw.DrawText("Turn Around ", "BeatrunButtons", ScrW() - ScreenScaleH(10) - tw - ScreenScaleH(4), ScrH() - fontheight - ScreenScaleH(10), text_color, TEXT_ALIGN_RIGHT)

		draw.WordBox(ScreenScaleH(2), ScrW() - ScreenScaleH(10), ScrH() - ScreenScaleH(10) - ScreenScaleH(2) - fontheight * 3, string.upper(GetValidKey("+forward")), "BeatrunButtons", box_color, text_color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
		tw = select(1, surface.GetTextSize(string.upper(GetValidKey("+forward"))))
		draw.DrawText("Move Forward ", "BeatrunButtons", ScrW() - ScreenScaleH(10) - tw - ScreenScaleH(4), ScrH() - fontheight * 3 - ScreenScaleH(10), text_color, TEXT_ALIGN_RIGHT)
	end

	if IsValid(ply:GetZipline()) then
		draw.WordBox(ScreenScaleH(2), ScrW() - ScreenScaleH(10), ScrH() - ScreenScaleH(10) - ScreenScaleH(2) - fontheight, string.upper(GetValidKey("+duck")), "BeatrunButtons", box_color, text_color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
		tw = select(1, surface.GetTextSize(string.upper(GetValidKey("+duck"))))
		draw.DrawText("Drop ", "BeatrunButtons", ScrW() - ScreenScaleH(10) - tw - ScreenScaleH(4), ScrH() - fontheight - ScreenScaleH(10), text_color, TEXT_ALIGN_RIGHT)
	end
end)