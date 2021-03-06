include("shared.lua")

include("cl_music.lua")
include("cl_message.lua")
include("cl_thirdperson.lua")
include("cl_hud.lua")

VIRUS = {}

VIRUS.config = {
	roundTime = 110 -- 180 by default
}

VIRUS.currentRound = {
	   number = 1,
	   playerList = {},
	   noOfPlayers = 0,
	   noOfInfected = 0,
	   timeLeft = 0
}

function GM:PlayerBindPress(ply, bind, pressed)
	if !pressed then return false end

	if (bind == "+zoom") then
		return true
	end

	if (bind == "+speed") then
		return true
	end

	if (bind == "+jump") then
		return true
	end

	if (bind == "+duck") then
		return true
	end

	if (bind == "+menu") then
		RunConsoleCommand("lastinv")
		return true
	end
end

function GM:GetFallDamage( ply, speed )
	return false
end

function GM:HUDWeaponPickedUp( Weapon )
	return false
end

function GM:PlayerCanPickupItem( ply, item )
	return false
end

function GM:Think()
	if LocalPlayer():GetNWInt("Virus") == 1 then
		local Objects = ents.FindInSphere(LocalPlayer():GetPos(), 30) -- TODO: This radius was originally 20. Reconsider it if the detection radius is too forgiving.
		for _, ply in pairs(Objects) do
			if ply:IsPlayer() && ply:GetNWInt("Virus") != 1 then
				net.Start("Virus hitDetection")
					net.WriteEntity(ply)
				net.SendToServer()
			end
		end
	end
end

hook.Add("Think", "Virus infectedGlow", function() -- TODO We need to make this visible to other players. Sprite system?
	local infectedglow = DynamicLight(LocalPlayer():EntIndex())

	if infectedglow and LocalPlayer():GetNWInt("Virus") == 1 then
		infectedglow.pos = LocalPlayer():GetShootPos()
		infectedglow.r = 70
		infectedglow.g = 255
		infectedglow.b = 70
		infectedglow.brightness = 8
		infectedglow.Decay = 100
		infectedglow.Size = 90
		infectedglow.DieTime = CurTime() + 1
	end
end)

net.Receive("Virus updateCurrentRound", function()
	VIRUS.currentRound.number = net.ReadInt(10)
end)
