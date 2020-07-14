/*-------------------------------------------------------------------------------------------------------------------------
	Allow a player to spawn NPCs
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "NPC"
PLUGIN.Description = "Allow a player to spawn NPCs."
PLUGIN.Author = "bellum128"
PLUGIN.Privileges = { "Spawn NPC" }

function PLUGIN:PlayerSpawnNPC(ply)
	if (SERVER and !ply:EV_HasPrivilege( "Spawn NPC" ) ) then
		evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
		return false
	end
end

evolve:RegisterPlugin( PLUGIN )
