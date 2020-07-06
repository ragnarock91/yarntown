local menu = {}

local game_manager = require"scripts/game_manager"

local MAX_CURSOR_INDEX = 2
local options = {
	"Continue",
	"New Game"
}
local FADE_IN_RATE = 40

local options_x = 185
local options_y = 200

function menu:on_started()
	menu.surface = sol.surface.create()
  menu.bg = sol.surface.create("menus/title_screen_background.png")
  menu.cursor = sol.surface.create("menus/cursor.png")
  menu.continue_surface = sol.text_surface.create{font="enter_command", font_size=16}
  menu.continue_surface:set_text(options[1])
  menu.new_game_surface = sol.text_surface.create{font="enter_command", font_size=16}
  menu.new_game_surface:set_text(options[2])

  menu.cursor_index = 1

  if not sol.game.exists("save_1") then menu.continue_surface:set_color_modulation{150,150,150} end

  menu.bg:draw(menu.surface)
  menu.continue_surface:draw(menu.surface, options_x, options_y)
  menu.new_game_surface:draw(menu.surface, options_x, options_y + 16)
  menu.surface:set_opacity(0)
  menu.surface:fade_in(FADE_IN_RATE)

  menu.cursor:set_opacity(0)
  menu.cursor:fade_in(FADE_IN_RATE)
end


function menu:on_key_pressed(cmd)
	if cmd == "down" then
		sol.audio.play_sound"cursor"
		menu.cursor_index = menu.cursor_index + 1
		if menu.cursor_index > MAX_CURSOR_INDEX then menu.cursor_index = 1 end

	elseif cmd == "up" then
		sol.audio.play_sound"cursor"
		menu.cursor_index = menu.cursor_index - 1
		if menu.cursor_index < 1 then menu.cursor_index = MAX_CURSOR_INDEX end

	elseif cmd == "space" or cmd == "return" then
		menu:process_selection()

	end
end


function menu:process_selection()
	if options[menu.cursor_index] == "Continue" then
		if sol.game.exists("save_1") then
			local game = game_manager:create("save_1")
			sol.menu.stop(menu)
			game:start()
		else
			sol.audio.play_sound"wrong"
		end

	elseif options[menu.cursor_index] == "New Game" then
		sol.game.delete("save_1")
		local game = game_manager:create("save_1")
		game:start()
		sol.menu.stop(menu)

	else
		print("Cursor index = ", menu.cursor_index)
	end
end



function menu:on_draw(dst)
	menu.surface:draw(dst)
	menu.cursor:draw(dst, options_x - 14, options_y -4 + (menu.cursor_index - 1) * 16)
end

return menu