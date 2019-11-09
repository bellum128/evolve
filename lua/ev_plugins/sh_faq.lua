/*-------------------------------------------------------------------------------------------------------------------------
	Frequently Asked Questions
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "FAQ"
PLUGIN.Description = "Frequently asked questions"
PLUGIN.Author = "bellum128"
PLUGIN.ChatCommand = "faq"
PLUGIN.Usage = "[question]"
PLUGIN.Privileges = { "FAQ" }
PLUGIN.Qs = {}

PLUGIN.Qs["build"] = function()
	evolve:Notify( Color( 255, 201, 0, 255 ), "At TKZ", evolve.colors.white, ", all players have ", evolve.colors.blue, "build invincibility", evolve.colors.white, " after spawning, until pulling out a ", evolve.colors.red, "combat weapon", evolve.colors.white , " or ", evolve.colors.red, "injuring another player." )
end
PLUGIN.Qs["fly"] = function()
	evolve:Notify( Color( 255, 201, 0, 255 ), "At TKZ", evolve.colors.white, ", guests may not ", evolve.colors.blue, "fly", evolve.colors.white, " or ", evolve.colors.blue, "noclip", evolve.colors.white , " by default. Please ask an admin if you absolutely must noclip for building." )
end
PLUGIN.Qs["noclip"] = PLUGIN.Qs["fly"]
PLUGIN.Qs["dupe"] = function()
	evolve:Notify( Color( 255, 201, 0, 255 ), "At TKZ", evolve.colors.white, ", the ", evolve.colors.blue, "duplicator", evolve.colors.white, " tool is not available, so as to prevent un-original creations. Please use ", evolve.colors.blue, "Advanced Duplicator 2", evolve.colors.white, " instead." )
end

function PLUGIN:Call( ply, args )
	if ( ply:EV_HasPrivilege( "FAQ" ) ) then
		local printFullList = ( #args == 0)

		if(!printFullList && PLUGIN.Qs[args[1]] == nil) then
			evolve:Notify( ply, evolve.colors.red, "Question not found." )
		elseif(!printFullList) then
			(PLUGIN.Qs[args[1]])()
		else
			evolve:Notify( evolve.colors.white, " " )
			evolve:Notify( Color( 255, 201, 0, 255 ), "[TKZ] Build to Kill FAQ" )
			for k, v in pairs( PLUGIN.Qs ) do
				PLUGIN.Qs[k]()
			end
		end
	else
		evolve:Notify( ply, evolve.colors.red, "Go FAQ yourself!" )
	end
end

evolve:RegisterPlugin( PLUGIN )