local client_maps_no_suit = {
	["d1_trainstation_01"] = true,
	["d1_trainstation_02"] = true,
	["d1_trainstation_03"] = true,
	["d1_trainstation_04"] = true
}

local client_hidehud = {
	["CHudHealth"] = true,
	["CHudBattery"] = true,
}

local client_musthidehud = {
	["CHudChat"] = true
}

local tankNPCs = {}

local function DisplayChatMessage(message)
	chat.AddText(unpack(message))
end

local function PlayLocalSound(soundPath)
	surface.PlaySound(soundPath)
end

local function PlayUniqueLocalSound(soundName, setPitch)
	sound.Add( {
		name = "hl2cr_custom_sound",
		channel = CHAN_STATIC,
		volume = 1.0,
		level = 80,
		pitch = setPitch,
		sound = soundName
	} )

	LocalPlayer():EmitSound("hl2cr_custom_sound")
end

local start, oldXP, newXP = SysTime(), -1, -1
local barW = 400 --old 200
local animationTime = 1.0
local lastUpdate = 0
local fadeOut = 200

hook.Add( "HUDPaint", "HL2CR_XPBar", function()

	if client_maps_no_suit[game.GetMap()] or (game.GetMap() == "d1_trainstation_05" and not GetGlobalBool("HL2CR_GLOBAL_SUIT")) then return end

	if ( !IsValid( LocalPlayer() ) ) then return end

	if ( oldXP == nil and newXP == nil ) then
		oldXP = xp
		newXP = xp
	end

	if newXP == nil then return end

	if lastUpdate < CurTime() then
		if fadeOut > 0 then
			fadeOut = fadeOut - FrameTime() * 255
		end

		if !Client_Config.HideXP and fadeOut < 30 then
			fadeOut = 30
		end
	end

	local xp = LocalPlayer():GetNWInt("hl2cr_stat_exp")
	local reqXP = LocalPlayer():GetNWInt("hl2cr_stat_expreq")

	local smoothNewXP = 0

	local smoothXP = Lerp( math.Clamp((SysTime() - start) / animationTime,0,1), oldXP, newXP )

	if newXP ~= xp then
		fadeOut = 200
		oldXP = newXP
		start = SysTime()
		newXP = xp
	end

	if fadeOut <= 0 then return end
	//Empty
	draw.RoundedBox( 4, (ScrW()-barW) * 0.5, ScrH() / 1.075, barW, 45, Color(0, 0, 0, fadeOut) )

	//Fill
	draw.RoundedBox( 4, (ScrW()-barW) * 0.5, ScrH() / 1.075, math.max( 0, smoothXP ) / reqXP * barW, 45, Color(250, 174, 0, fadeOut) )

	local percentage = xp.."/"..reqXP
	--local percentage = math.Round((100 * xp) / reqXP, 1) .. "%"

	//Text
	--draw.SimpleText(translate.Get("HUD_Stat_XP") .. " " .. percentage, "hl2cr_hud_xp", ScrW() / 2.10, ScrH() / 1.05, Color(255, 200, 100, fadeOut), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

	draw.SimpleTextOutlined(translate.Get("HUD_Stat_XP") .. " " .. percentage, "hl2cr_hud_xp", ScrW() * 0.5, ScrH() / 1.05, Color(255, 200, 100, fadeOut*1.5), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0, fadeOut * 2 ) )

	if HL2CR_SkillsPoints() > 0 then
		draw.SimpleTextOutlined(HL2CR_SkillsPoints() .. translate.Get("HUD_Notice_UnspentSkills") , "hl2cr_hud_xp", ScrW() * 0.5, ScrH() / 1.105, Color(255, 0, 0, fadeOut*1.5), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1 , Color( 0, 0, 0, fadeOut * 2 ) )
	end
end )


net.Receive("HL2CR_MsgSound", function()
	PlayLocalSound(net.ReadString())
end)

net.Receive("HL2CR_MsgPitchSound", function()
	PlayUniqueLocalSound(net.ReadString(), net.ReadInt(32))
end)

net.Receive("HL2CR_ChatMessage", function()
	DisplayChatMessage( net.ReadTable() )
end)

local curXPNotify = {}
local xpTotalText = nil
local xpTotal = 0
local xPosDiv = 2.075

net.Receive("HL2CR_Update_XP", function()
	lastUpdate = 6 + CurTime()

	local addedXP = net.ReadInt(32)
	xpTotal = xpTotal + addedXP

	local xpText = vgui.Create("DLabel", xpPopup)
	xpText:SetPos(ScrW() / xPosDiv, ScrH() - 115)
	xpText:SetText(translate.Get("HUD_Stat_XP") .. ": " .. addedXP)
	xpText:SetTextColor(Color(255, 200, 0))
	xpText:SetFont("hl2cr_hud_xp")
	xpText:SizeToContents()

	xpText:MoveTo( ScrW() / xPosDiv, ScrH() - 125, 1, 0, -1, function()
		xpText:AlphaTo( 0, 1, 1, function()
			xpTotal = 0
			xpText:Remove()
		end)
	end)
end)

local function DisplayDeathNotification(msgTbl)
	if msgTbl.Attacker == nil or msgTbl.Victim == msgTbl.Attacker then
		hook.Run("AddDeathNotice", nil, nil, "suicide", msgTbl.victim:Nick(), nil )
	else
		hook.Run("AddDeathNotice", msgTbl.attacker, nil, msgTbl.inflictor, msgTbl.victim:Nick(), nil )
	end
end

local function UpdateTankHud(ent)
	if table.HasValue(tankNPCs, ent) then return end
	table.insert(tankNPCs, ent)
end

net.Receive("HL2CR_TankNPC_Display", function()
	UpdateTankHud(net.ReadEntity())
end)

net.Receive("HL2CR_Player_NotifyKilled", function()
	DisplayDeathNotification(net.ReadTable())
end)

hook.Add( "HUDShouldDraw", "HL2CR_HideHUD", function( name )
	if client_musthidehud[name] then
		return false
	end

	if client_hidehud[name] and client_maps_no_suit[game.GetMap()] then
		return false
	elseif client_hidehud[name] and (game.GetMap() == "d1_trainstation_05" and not GetGlobalBool("HL2CR_GLOBAL_SUIT")) then
		return false
	end

	if ( name == "CHudCrosshair" and Client_Config.NewCross ) then
		return false
	end

    return true
end)

gameevent.Listen("player_disconnect")
hook.Add( "player_disconnect", "HL2CR_PlayerDisconnect", function( data )
	local name = data.name
	local steamid = data.networkid
	local id = data.userid
	local bot = data.bot
	local reason = data.reason

	chat.AddText(Color(240, 175, 0), steamid .. ": " .. name .. translate.Get("Chat_Player_Disconnect"), tostring(reason))
end)

gameevent.Listen("player_connect_client")
hook.Add( "player_connect_client", "HL2CR_PlayerConnect", function( data )
	local name = data.name
	local id = data.networkid

	if id == "STEAM_0:0:6009886" then
		surface.PlaySound("hl2cr/admin/itsrifter_join.wav")
	elseif id == "STEAM_0:1:7832469" then
		surface.PlaySound("hl2cr/admin/birdman_join.wav")
	elseif id == "STEAM_0:0:97860967" then
		surface.PlaySound("hl2cr/admin/sarin_join.wav")
	end

	chat.AddText(Color(240, 175, 0), name .. translate.Get("Chat_Player_Connect"))
end)

local isDebugging = false

concommand.Add("hl2cr_debugmode", function(ply)
	if not ply:IsAdmin() then return end

	if isDebugging then
		isDebugging = false
	else
		isDebugging = true
	end
end)

hook.Add("PostDrawHUD", "HL2CR_DebugDraw", function()
	if isDebugging == false then return end

	local trace = LocalPlayer():GetEyeTrace()
	local angle = trace.HitNormal:Angle()

	surface.SetDrawColor(Color(0, 0, 0, 255))
	surface.SetTextPos( ScrW() / 2.5, ScrH() / 1.90 )
	surface.SetFont("hl2cr_scoreboard_player")
	surface.DrawText( tostring(trace.HitPos) )
end )

local xPos = 0.75
local yPos = 65

hook.Add("PostDrawHUD", "HL2CR_TankNPCStatus", function()
	if table.IsEmpty(tankNPCs) then return end

	for i, t in ipairs(tankNPCs) do
		if !IsValid(t) or t:Health() <= 0 then
			table.remove(tankNPCs, i)
			break
		end

		local healthwidth = ScrW() * 0.24
		local healthpercent = (healthwidth / t:GetMaxHealth()) * t:Health()
		local missingpercent = healthwidth-healthpercent

		--outline part
		surface.SetDrawColor(Color(0, 0, 0, 250))
		surface.DrawOutlinedRect(ScrW() * xPos -1, ScrH() * 0.4 + yPos * i -1, healthwidth+2, 27)

		--missing part
		surface.SetDrawColor(Color(10, 10, 10, 100))
		--surface.DrawRect(ScrW() * xPos, ScrH() * 0.4 + yPos * i, t:GetMaxHealth() / 2, 25)
		surface.DrawRect(ScrW() * xPos + healthwidth, ScrH() * 0.4 + yPos * i, -missingpercent, 25)

		--health bar
		surface.SetDrawColor(Color(100, 255, 100,100))
		--surface.DrawRect(ScrW() * xPos, ScrH() * 0.4 + yPos * i, t:Health() / 2, 25)
		surface.DrawRect(ScrW() * xPos, ScrH() * 0.4 + yPos * i, healthpercent, 25)
	end
end)

hook.Add("HUDPaint", "HL2CR_Respawn_Timer", function()
	if LocalPlayer():Alive() then return end

	local resTime = LocalPlayer():GetNWInt("hl2cr_respawntimer")

	if resTime > 0 then
		draw.SimpleText(translate.Get("Respawn_Remain") .. LocalPlayer():GetNWInt("hl2cr_respawntimer"), "hl2cr_respawntimer", ScrW() / 1.15, ScrH() - 50, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	else
		draw.SimpleText(translate.Get("Respawn_Ready"), "hl2cr_respawntimer",  ScrW() / 1.15, ScrH() - 50, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

end)

hook.Add("HUDPaint", "HL2CR_DrawPetStats", function()
	for _, e in ipairs(ents.FindByClass("npc_*")) do
		if e:IsPet() then
			local pet = e

			local dist = LocalPlayer():GetPos():Distance(pet:GetPos())
			local pos = pet:GetPos()
				pos.z = pet:GetPos().z + 20 + (dist * 0.0325)

			local ScrPos = pos:ToScreen()
			if pet:GetOwner() and dist <= 250 then
				//draw.SimpleText(translate.Get("NPCLevel") .. pet:GetOwner():GetNWInt("pet_level", -1), "HL2CR_NPCStats", ScrPos.x, ScrPos.y - 35, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleText(pet:GetOwner():Nick() .. translate.Get("Pet_Owner"), "hl2cr_hud_pet", ScrPos.x, ScrPos.y, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleText(pet:GetOwner():GetNWString("hl2cr_petstat_name"), "hl2cr_hud_pet", ScrPos.x, ScrPos.y + 35, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

				//TEMPORARY
				draw.SimpleText("Health: " .. pet:Health() .. "/" .. pet:GetMaxHealth(), "hl2cr_hud_pet", ScrPos.x, ScrPos.y + 65, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleText("Level: " .. pet:GetOwner():GetNWString("hl2cr_petstat_level"), "hl2cr_hud_pet", ScrPos.x, ScrPos.y + 95, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleText("XP: " .. pet:GetOwner():GetNWString("hl2cr_petstat_xp") .. "/" .. pet:GetOwner():GetNWString("hl2cr_petstat_reqxp"), "hl2cr_hud_pet", ScrPos.x, ScrPos.y + 125, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		end
	end
end)


--Stupid fix for SWEP construction kit weapons hiding viewmodel
hook.Add( "PlayerSwitchWeapon", "WeaponSwitchExample", function( ply, oldWeapon, newWeapon )
	--local vm = ply:GetViewModel()
	if ply == LocalPlayer() then VMFix(newWeapon) end
end )

function VMFix(AW)
	local vm = LocalPlayer():GetViewModel()
	--local AW = LocalPlayer():GetActiveWeapon()

	if IsValid(vm) and IsValid(AW) then

		if (AW.ShowViewModel == nil or AW.ShowViewModel) then
			vm:SetColor(Color(255,255,255,255))
			vm:SetMaterial()
		else
			vm:SetColor(Color(255,255,255,1))
			vm:SetMaterial("vgui/hsv")
		end
	end
end
