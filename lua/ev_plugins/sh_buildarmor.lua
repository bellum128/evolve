/*-------------------------------------------------------------------------------------------------------------------------
	TKZ Spawn Armor
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Build Armor"
PLUGIN.Description = "Enables godmode on players that haven't taken out a certain set of weapons since spawning."
PLUGIN.Author = "Freezebug, TheDoctor, bellum128"
PLUGIN.ChatCommand = "buildarmor"
PLUGIN.Usage = "[players] [1/0]"
PLUGIN.Privileges = { "Set Build Armor" }

function PLUGIN:Call( ply, args )
	if ( ply:EV_HasPrivilege( "Set Build Armor" ) ) then
		local players = evolve:FindPlayer( args, ply, true )
		local enabled = ( tonumber( args[ #args ] ) or 1 ) > 0

		for _, pl in ipairs( players ) do
			if(enabled) then
				BuildArmor.Enable(pl)
				if pl:GetMaterial() != "models/props_combine/portalball001_sheet" then
					pl:SetMaterial("models/props_combine/portalball001_sheet")
				end
			else
				BuildArmor.Disable(pl)
			end
		end

		if ( #players > 0 ) then
			if ( enabled ) then
				evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " has enabled build mode for ", evolve.colors.red, evolve:CreatePlayerList( players ), evolve.colors.white, "." )
			else
				evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " has disabled build mode for ", evolve.colors.red, evolve:CreatePlayerList( players ), evolve.colors.white, "." )
			end
		else
			evolve:Notify( ply, evolve.colors.red, evolve.constants.noplayers )
		end
	else
		evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

function PLUGIN:Menu( arg, players )
	if ( arg ) then
		table.insert( players, arg )
		RunConsoleCommand( "ev", "buildarmor", unpack( players ) )
	else
		return "Build Armor", evolve.category.actions, { { "Enable", 1 }, { "Disable", 0 } }
	end
end

if ( SERVER ) then

	BuildArmor = {}
	BuildArmor.Material = "models/props_combine/portalball001_sheet"
	BuildArmor.WhiteList = {}


	local function SaveWhitelist()
		local jas = util.TableToJSON(BuildArmor.WhiteList)
		file.Write("BA_WHITELIST.txt",jas)
	end

	function BuildArmor.SendMessage(ply,msg)
		evolve:Notify( ply, unpack(msg))
	end

	function BuildArmor.SetWhitelist(weapon,bool)
			BuildArmor.WhiteList[weapon] = bool

	end

	function BuildArmor.Enable(ply)
		ply.BuildArmorEnabled = true
		BuildArmor.SendMessage(ply, {evolve.colors.white, "Your Build Armor is now active until you pull out a weapon or damage another player."})
	end

	function BuildArmor.Disable(ply)
		ply:SetMaterial("")
		ply.BuildArmorEnabled = false
		BuildArmor.SendMessage(ply, {evolve.colors.red, "Your Build Armor has been deactivated."})
	end


	concommand.Add("ba_whitelist",function(P,C,A)
		if IsValid(P) then
			if not P:IsAdmin() then
				BuildArmor.SendMessage(P,{evolve.colors.red, "You are not permitted to edit the whitelist."})
				return
		   end
			if !A[1] then
				BuildArmor.SendMessage(P,{evolve.colors.red,"No weapon specified!"})
			end
		else
			if !A[1] then
				print("No weapon specified")
			end
		end

		local wep = string.lower(A[1])

		if BuildArmor.WhiteList[wep] then
			BuildArmor.SendMessage(P, {evolve.colors.red, wep, evolve.colors.white, " is already in the whitelist."})
			return
		end

		BuildArmor.SetWhitelist(wep, true)
		SaveWhitelist()

		BuildArmor.SendMessage(player.GetAll(),{evolve.colors.blue, P, evolve.colors.white, " has allowed ", evolve.colors.red, A[1], evolve.colors.white, " to be used in build armor."})
	end)

	concommand.Add("ba_blacklist",function(P,C,A)
		if IsValid(P) then
			if not P:IsAdmin() then
				BuildArmor.SendMessage(P,{evolve.colors.red, "You are not permitted to edit the whitelist."})
				return
		   end
			if !A[1] then
				BuildArmor.SendMessage(P,{evolve.colors.red, "No weapon specified!"})
			end
		else

			if !A[1] then
				print("No weapon specified")
			end
		end

		local wep = string.lower(A[1])

		if not BuildArmor.WhiteList[wep] then
			BuildArmor.SendMessage(P,{evolve.colors.red, wep, evolve.colors.white, " is not in the whitelist."})
			return
		end

		BuildArmor.SetWhitelist(wep, false)
		SaveWhitelist()

		BuildArmor.SendMessage(player.GetAll(), {evolve.colors.blue, P, evolve.colors.white," has disallowed ", evolve.colors.red, A[1], evolve.colors.white, " to be used in build armor."})
	end)


	local cntn = file.Read("BA_WHITELIST.txt","DATA")

	if cntn then
		BuildArmor.WhiteList = util.JSONToTable(cntn)
	end

	if !BuildArmor.WhiteList then
		BuildArmor.WhiteList = {}
	end

	for k,v in pairs(player.GetAll()) do
		BuildArmor.Enable(v)
	end


	function PLUGIN:Think()
		for i,ply in pairs(player.GetAll()) do
			if ply.BuildArmorEnabled then
					if ply:GetMaterial()!=BuildArmor.Material then
						ply:SetMaterial(BuildArmor.Material)
					end
					local badwep = true
					for k,v in pairs(BuildArmor.WhiteList) do
						if v==true then
							if IsValid(ply:GetActiveWeapon()) then
								local we = string.lower(  ply:GetActiveWeapon():GetClass())
								if we==k then
									badwep = false
								end
							end
						end
					end

					 if badwep==true then
						   BuildArmor.Disable(ply)
					 end
				if ply:InVehicle() then
					BuildArmor.Disable(ply)
				end

			end

		end

	end

	function PLUGIN:PlayerShouldTakeDamage(P,A)
		if P:IsPlayer() then
			if P.BuildArmorEnabled then
				return false
			end
		end

		if A:IsPlayer() then
			if A.BuildArmorEnabled then
				BuildArmor.Disable(A)
			end
		end

	end

	function PLUGIN:PlayerSpawn(P)
		BuildArmor.Enable(P)
	end
end

evolve:RegisterPlugin( PLUGIN )
