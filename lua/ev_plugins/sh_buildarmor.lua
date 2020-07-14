/*-------------------------------------------------------------------------------------------------------------------------
	Force activate or deacvtivate a players spawn armor
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Build Armor"
PLUGIN.Description = "Force activate or deacvtivate a player's spawn armor."
PLUGIN.Author = "bellum128, Freezebug"
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

evolve:RegisterPlugin( PLUGIN )
