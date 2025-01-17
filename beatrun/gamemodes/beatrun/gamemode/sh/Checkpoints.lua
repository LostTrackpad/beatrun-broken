Checkpoints = Checkpoints or {}
CheckpointNumber = CheckpointNumber or 1
local Checkpoints = Checkpoints
Course_StartTime = 0
Course_GoTime = 0
Course_EndTime = 0
Course_ID = Course_ID or ""
Course_Name = Course_Name or ""
local cptimes = {}
local lastcptime = 0
local pbtimes = nil
local pbtotal = 0
local color_positive = Color(0, 255, 0, 255)
local color_negative = Color(255, 0, 0, 255)
local color_neutral = Color(200, 200, 200, 255)
local timetext = ""
local timealpha = 1000
local timecolor = color_neutral

if CLIENT then
	CreateClientConVar("Beatrun_ShowSpeedometer", 1, true, true, language.GetPhrase("#beatrun.convars.showspeedometer"), 0, 1)
	CreateClientConVar("Beatrun_HUDStats", "0", true, false, "", 0, 1)
end

if SERVER then
	util.AddNetworkString("Checkpoint_Hit")
	util.AddNetworkString("Checkpoint_Finish")
else
	surface.CreateFont("BeatrunHUD", {
		shadow = true,
		blursize = 0,
		underline = false,
		rotary = false,
		strikeout = false,
		additive = false,
		antialias = true,
		extended = false,
		scanlines = 0,
		font = "Roboto",
		italic = false,
		outline = false,
		symbol = false,
		size = 32,
		weight = 2000
	})
end

function LoadCheckpoints()
	table.Empty(Checkpoints)

	if SERVER then
		for _, v in pairs(player.GetAll()) do
			v:SetNW2Int("CPNum", 1)
		end
	end

	if CLIENT then
		timer.Simple(1, function()
			for _, v in pairs(ents.FindByClass("tt_cp")) do
				if IsValid(v) and v.GetCPNum then
					Checkpoints[v:GetCPNum()] = v
				end
			end
		end)
	else
		for _, v in pairs(ents.FindByClass("tt_cp")) do
			Checkpoints[v:GetCPNum()] = v
		end
	end
end

if CLIENT then
	CreateClientConVar("Beatrun_FastStart", "0", true, true, language.GetPhrase("beatrun.convars.faststart"), 0, 1)

	net.Receive("Checkpoint_Hit", function()
		local timetaken = CurTime() - lastcptime
		local vspb = nil

		if pbtimes then
			vspb = timetaken - (pbtimes[CheckpointNumber] or 0)
		end

		table.insert(cptimes, timetaken)

		lastcptime = CurTime()
		CheckpointNumber = net.ReadUInt(8)

		if blinded then
			LocalPlayer():EmitSound("good.wav", 75, 75)
		end

		if not pbtimes or vspb == 0 then
			LocalPlayer():EmitSound("A_TT_CP_Neutral.wav")

			timecolor = color_neutral
			timetext = string.FormattedTime(math.abs(timetaken), "%02i:%02i:%02i")
		elseif vspb < 0 then
			LocalPlayer():EmitSound("A_TT_CP_Positive.wav")

			timecolor = color_positive
			timetext = "-" .. string.FormattedTime(math.abs(vspb), "%02i:%02i:%02i")
		else
			LocalPlayer():EmitSound("A_TT_CP_Negative.wav")

			timecolor = color_negative
			timetext = "+" .. string.FormattedTime(math.abs(vspb), "%02i:%02i:%02i")
		end

		LocalPlayer():AddXP(5)

		timealpha = 1000

		print(timetaken, vspb)
	end)

	net.Receive("Checkpoint_Finish", function()
		table.insert(cptimes, CurTime() - lastcptime)

		local totaltime = CurTime() - Course_StartTime
		local timestr = totaltime - pbtotal

		LocalPlayer():AddXP(math.min(10 * CheckpointNumber, 100))

		CheckpointNumber = -1
		Course_EndTime = totaltime

		if blinded then
			LocalPlayer():EmitSound("reset.wav", 75, 75)
		end

		if pbtotal == 0 or totaltime < pbtotal then
			timetext = "-" .. string.FormattedTime(math.abs(timestr), "%02i:%02i:%02i")
			timecolor = color_positive

			LocalPlayer():EmitSound("A_TT_Finish_Positive.wav")
			SaveCheckpointTime()
			SaveReplayData()
		else
			timetext = "+" .. string.FormattedTime(math.abs(timestr), "%02i:%02i:%02i")
			timecolor = color_negative

			LocalPlayer():EmitSound("A_TT_Finish_Negative.wav")
		end

		net.Start("Checkpoint_Finish")
			net.WriteFloat(totaltime)
			if !LocalPlayer().InReplay then
				notification.AddLegacy("Replay saved as ".."beatrun/replays/" .. game.GetMap() .. "/"..Course_Name .."/" os.date("%H-%M-%S_%d-%m-%Y", os.time()) .. ".txt", 0, 3)
			end
		net.SendToServer()

		timealpha = 1000
	end)
end

if SERVER then
	net.Receive("Checkpoint_Finish", function(len, ply)
		local pb = net.ReadFloat() or 0
		local svtime = CurTime() - ply.Course_StartTime

		if math.abs(svtime - pb) > 5 then
			pb = svtime
		end

		if ply:GetNW2Int("CPNum", 1) == -1 and (ply:GetNW2Float("PBTime") == 0 or pb < ply:GetNW2Float("PBTime")) then
			ply:SetNW2Float("PBTime", pb)
		end
	end)
end

local finishcolor = Color(45, 45, 175, 100)

function FinishCourse(ply)
	ply:ScreenFade(SCREENFADE.IN, finishcolor, 0, 4)
	ply:SetLaggedMovementValue(0.1)
	ply:DrawViewModel(false)

	net.Start("Checkpoint_Finish")
	net.Send(ply)

	ply:SetNW2Int("CPNum", -1)

	timer.Simple(4, function()
		ply:SetLaggedMovementValue(1)
		ply:DrawViewModel(true)
	end)
end

local countdown = 0
local countdownalpha = 255

local countdowntext = {
	"#beatrun.checkpoints.countdown1",
	"#beatrun.checkpoints.countdown2",
	"#beatrun.checkpoints.countdown3"
}

local function StartCountdown()
	local CT = CurTime()
	local faststartmult = LocalPlayer():GetInfoNum("Beatrun_FastStart", 0) > 0 and 0.5 or 1

	if Course_GoTime <= CT then
		Course_GoTime = CT + 1 * faststartmult
		countdown = countdown + 1

		if countdown >= 3 then
			LocalPlayer():EmitSound("A_TT_CD_02.wav")
			hook.Remove("Think", "StartCountdown")
			hook.Remove("StartCommand", "StartFreeze")
		else
			LocalPlayer():EmitSound("A_TT_CD_01.wav")
		end
	end
end

local function StartCountdownHUD()
	local text = countdowntext[countdown] or ""

	surface.SetFont("DermaLarge")
	surface.SetTextColor(255, 255, 255, countdownalpha)

	local w, _ = surface.GetTextSize(text)

	surface.SetTextPos(ScrW() * 0.5 - w * 0.5, ScrH() * 0.3)
	surface.DrawText(text)

	if countdown >= 3 then
		countdownalpha = countdownalpha - FrameTime() * 250

		if countdownalpha <= 0 then
			hook.Remove("HUDPaint", "StartCountdownHUD")
		end
	end
end

function CourseHUD()
	local ply = LocalPlayer()
	local vp = ply:GetViewPunchAngles()
	local vpx = vp.x
	local vpz = vp.z
	local incourse = Course_Name ~= ""
	local totaltime = CheckpointNumber ~= -1 and math.max(0, CurTime() - Course_StartTime) or Course_EndTime

	if incourse then
		local text = string.FormattedTime(totaltime, "%02i:%02i:%02i")
		local w, _ = surface.GetTextSize(text)
		surface.SetFont("BeatrunHUD")
		surface.SetTextPos(ScrW() * 0.85 - w * 0.5 + vpx, ScrH() * 0.075 + vpz)
		surface.DrawText(text)
	end

	if GetConVar("Beatrun_ShowSpeedometer"):GetBool() and GetConVar("Beatrun_HUDHidden"):GetInt() ~= 2 then
		local speed = math.Round(ply:GetVelocity():Length() * 0.06858125)

		if speed < 10 then
			speed = "0" .. speed
		end

		text = language.GetPhrase("beatrun.checkpoints.speedometer"):format(speed)

		local w, _ = surface.GetTextSize(text)
		w = w or 0

		local r, g, b, a = string.ToColor(GetConVar("Beatrun_HUDTextColor"):GetString())

		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetFont("BeatrunHUD")
		surface.SetTextColor(r, g, b, a)
		surface.SetTextPos(ScrW() * 0.85 - w * 0.5 + vpx, ScrH() * 0.85 + vpz)
		surface.DrawText(text)

		if GetConVar("Beatrun_HUDStats"):GetBool() then
			local ang1 = ply:GetAimVector()
			ang1 = math.Round(ang1:Angle()[2] % 90, 0)
			surface.SetTextPos(ScrW() * 0.85 - w * 0.5 + vpx, ScrH() * 0.88 + vpz)
			surface.DrawText(ang1)

			surface.SetTextPos(ScrW() * 0.87 - w * 0.5 + vpx, ScrH() * 0.88 + vpz)
			surface.DrawText("Angle")

			surface.SetTextPos(ScrW() * 0.85 - w * 0.5 + vpx, ScrH() * 0.90 + vpz)
			surface.DrawText(ply:GetWallrun())
			surface.SetTextPos(ScrW() * 0.87 - w * 0.5 + vpx, ScrH() * 0.90 + vpz)
			surface.DrawText("Wall stat")

			if ply:UsingRH() then
				surface.SetTextPos(ScrW() * 0.85 - w * 0.5 + vpx, ScrH() * 0.92 + vpz)
				surface.DrawText(tostring(ply:GetActiveWeapon():GetQuakeJumping()))
				surface.SetTextPos(ScrW() * 0.89 - w * 0.5 + vpx, ScrH() * 0.92 + vpz)
				surface.DrawText("Quake")
			end

			surface.SetTextPos(ScrW() * 0.85 - w * 0.5 + vpx, ScrH() * 0.94 + vpz)
			if (ply:GetWallrunTime() - CurTime()) < 0 then
				surface.DrawText("0.00")
			else
				surface.DrawText(tostring(math.Round(ply:GetWallrunTime() - CurTime(), 2)))
			end

			surface.SetTextPos(ScrW() * 0.89 - w * 0.5 + vpx, ScrH() * 0.94 + vpz)
			surface.DrawText("Wallrun Time Remains")

			surface.SetTextPos(ScrW() * 0.85 - w * 0.5 + vpx, ScrH() * 0.96 + vpz)
			surface.DrawText(tostring(CurTime() < ply:GetWallrunTime()))

			surface.SetTextPos(ScrW() * 0.89 - w * 0.5 + vpx, ScrH() * 0.96 + vpz)
			surface.DrawText("Wallrunning")
		end
	end

	if incourse and !ply.InReplay then
		cpcount = ply:GetNW2Int("CPNum", 1) - 1
		if cpcount == -2 then cpcount = table.Count(Checkpoints) - 1 end

		local text = string.FormattedTime(totaltime, "%02i:%02i:%02i")
		local w, _ = surface.GetTextSize(text)
		surface.SetFont("BeatrunHUD")
		surface.SetTextColor(text_color)
		surface.SetTextPos(ScrW() * 0.87 - w + vpx, ScrH() * 0.075 + vpz)
		surface.DrawText(text)

		text = "CHECKPOINT"
		local w, _ = surface.GetTextSize(text)
		surface.SetTextPos(ScrW() * 0.8 - w + vpx, ScrH() * 0.075 + vpz)
		surface.DrawText(text)
		if cpcount != -3 then
			text = cpcount .. "/".. table.Count(Checkpoints) - 1 .. " PASSED"
			local w, h = surface.GetTextSize(text)
			surface.SetTextPos(ScrW() * 0.8 - w + vpx, ScrH() * 0.075 + h + vpz)
			surface.DrawText(text)
		else
			text = "N/A PASSED"
			local w, h = surface.GetTextSize(text)
			surface.SetTextPos(ScrW() * 0.8 - w + vpx, ScrH() * 0.075 + h + vpz)
			surface.DrawText(text)
		end
	end

	if incourse and pbtimes and !ply.InReplay then
		local text = string.FormattedTime(pbtotal, "%02i:%02i:%02i")
		local w, h = surface.GetTextSize(text)

		pbcolor = text_color
		pbcolor.r = text_color.r * 0.6
		pbcolor.g = text_color.g * 0.6
		pbcolor.b = text_color.b * 0.6

		surface.SetFont("BeatrunHUD")
		surface.SetTextPos(ScrW() * 0.87 - w + vpx, ScrH() * 0.075 + h + vpz)
		surface.SetTextColor(pbcolor)
		surface.DrawText(text)
	end

	if incourse and ply.InReplay then
		local text = string.FormattedTime(tickcount * engine.TickInterval(), "%02i:%02i:%02i") .. " / " .. string.FormattedTime(#ply.ReplayTicks * engine.TickInterval(),  "%02i:%02i:%02i")
		local w, _ = surface.GetTextSize(text)
		surface.SetFont("BeatrunHUD")
		surface.SetTextColor(text_color)
		surface.SetTextPos(ScrW() * 0.87 - w + vpx, ScrH() * 0.075 + vpz)
		surface.DrawText(text)

		local text = "REPLAY MODE - MAY BE INACCURATE"
		local w, h = surface.GetTextSize(text)
		surface.SetTextColor(text_color)
		surface.SetTextPos(ScrW() * 0.87 - w + vpx, ScrH() * 0.075 + vpz + h)
		surface.DrawText(text)
	end

	if timealpha > 0 then
		local w, _ = surface.GetTextSize(timetext)
		w = w or 0

		timealpha = math.max(0, timealpha - FrameTime() * 250)
		timecolor.a = math.min(255, timealpha)

		surface.SetFont("BeatrunHUD")
		surface.SetTextPos(ScrW() * 0.5 - w * 0.5 + vpx, ScrH() * 0.3 + vpz)
		surface.SetTextColor(timecolor)
		surface.DrawText(timetext)
	end
end

function CheckpointOverlay()
	if Course_Name == "" then return end
	for _, v in ipairs(Checkpoints) do
		if v:GetCPNum() == LocalPlayer():GetNW2Int("CPNum", 1) then
			cam.Start3D()
			cppos = v:GetPos()
			cppos.z = cppos.z + 50
			local testtrace = {
				start = EyePos(),
				endpos = cppos,
				filter = LocalPlayer()
			}
			local cppos = cppos:ToScreen()
			local cphidden = util.TraceLine(testtrace).Hit
			cam.End3D()

			draw.DrawText(v:GetCPNum() .. "/".. table.Count(Checkpoints) - 1, "BeatrunHUD", cppos.x, cppos.y, cphidden and cp_hidden_col or color_white, TEXT_ALIGN_CENTER)
		end
	end

	color_positive.a = 255
	color_negative.a = 255
	color_neutral.a = 255
end

hook.Add("HUDPaint", "CourseHUD", CourseHUD)
hook.Add("HUDPaint", "CheckpointOverlay", CheckpointOverlay)

local function StartFreeze(ply, cmd)
	cmd:ClearButtons()
	cmd:ClearMovement()
	cmd:SetMouseX(0)
	cmd:SetMouseY(0)
end

function SaveCheckpointTime()
	local times = util.TableToJSON(cptimes)
	local dir = "beatrun/times/" .. game.GetMap() .. "/"

	file.CreateDir(dir)
	file.Write(dir .. Course_ID .. ".txt", times)
end

function LoadCheckpointTime()
	local dir = "beatrun/times/" .. game.GetMap() .. "/"
	local times = file.Read(dir .. Course_ID .. ".txt")
	times = times and util.JSONToTable(times)

	return times or nil
end

function SaveReplayData()
	local replay = util.Compress(util.TableToJSON(LocalPlayer().ReplayTicks))
	local dir = "beatrun/replays/" .. game.GetMap() .. "/"
	if not replay then return end
	file.CreateDir(dir)
	file.Write(dir .. Course_ID .. ".txt", replay)
end
function LoadReplayData()
	local dir = "beatrun/replays/" .. game.GetMap() .. "/"
	local replay = file.Read(dir .. Course_ID .. ".txt")
	replay = replay and util.JSONToTable(util.Decompress(replay))
	return replay or nil
end

function StartCourse(spawntime)
	local faststartmult = LocalPlayer():GetInfoNum("Beatrun_FastStart", 0) > 0 and 0.5 or 1

	table.Empty(cptimes)

	pbtimes = LoadCheckpointTime()
	pbtotal = 0

	if pbtimes then
		for k, v in pairs(pbtimes) do
			pbtotal = pbtotal + v
		end
	end

	CheckpointNumber = 1
	countdown = 0
	countdownalpha = 255
	Course_GoTime = spawntime
	Course_StartTime = spawntime + 2 * faststartmult
	lastcptime = Course_StartTime

	if Course_Name ~= "" then
		hook.Add("Think", "StartCountdown", StartCountdown)
		hook.Add("HUDPaint", "StartCountdownHUD", StartCountdownHUD)
		hook.Add("StartCommand", "StartFreeze", StartFreeze)
	else
		hook.Remove("Think", "StartCountdown")
		hook.Remove("HUDPaint", "StartCountdownHUD")
		hook.Remove("StartCommand", "StartFreeze")
	end
end

net.Receive("BeatrunSpawn", function()
	local spawntime = net.ReadFloat()
	local replay = net.ReadBool()

	hook.Run("BeatrunSpawn")

	LocalPlayer().InReplay = replay

	if LocalPlayer().GetInfoNum then
		StartCourse(spawntime)
	end
end)