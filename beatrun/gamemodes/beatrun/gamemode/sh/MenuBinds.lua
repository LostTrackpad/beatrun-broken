hook.Add("PlayerButtonDown", "CourseMenuBind", function(ply, button)
	if (game.SinglePlayer() or CLIENT and IsFirstTimePredicted()) and button == KEY_F4 then
		ply:ConCommand("Beatrun_CourseMenu")
	end

	if (game.SinglePlayer() or CLIENT and IsFirstTimePredicted()) and button == KEY_F3 then
		ply:ConCommand("Beatrun_GamemodesMenu")
	end
end)