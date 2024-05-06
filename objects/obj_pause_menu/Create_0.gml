global.paused = false

current_menu = 0
selected[current_menu] = 0

gw = display_get_gui_width()
gh = display_get_gui_height()

#region Enums

enum MENUS
{
	main
}

enum MENU_ACTIONS 
{
	execute_script,
	open_menu
}

enum MENU_FIELDS
{
	name,
	action,
	arguments
}

#endregion


#region Desenhar opções do menu

draw_menu = function(_menu)
{
	
	// Draw diferente dependendo do menu aberto
	switch current_menu
		{
			default:
				gw = display_get_gui_width()
				gh = display_get_gui_height()
	
				for (var _i = 0; _i < array_length(_menu); _i++)
				{
					var _menu_height = string_height("I") * array_length(_menu)
					var _option = _menu[_i]
					draw_set_color(c_white)
					if _i = selected[current_menu] {draw_set_color(c_yellow)}
					draw_text(20, gh/2 - _menu_height/2 + _i*16, _option[MENU_FIELDS.name])
				}
			break
		}
	
	// Resetar draw sets
	draw_set_color(c_white)
}
#endregion


#region Selecionar opções

navigate_menu = function()
{
	var _up     = keyboard_check_pressed(ord("W"))
	var _down   = keyboard_check_pressed(ord("S"))
	var _select = keyboard_check_pressed(vk_enter)
	
	var _menu = menu_list[current_menu]
	var _sel = selected[current_menu]

	if _up || _down
	{
		selected[current_menu] += _down - _up
	}
	
	selected[current_menu] = clamp(selected[current_menu], 0, array_length(_menu)-1)
	
	// Realizar ação da opção selecionada
	if _select
	{
		switch _menu[_sel][MENU_FIELDS.action]
		{
			case MENU_ACTIONS.execute_script:
				_menu[_sel][MENU_FIELDS.arguments]()
			break
		}
	}
}

#endregion


#region Métodos

resume_game = function() 
{
	global.paused = false
}

exit_game = function()
{
	game_end()
}

#endregion


#region Lista de Menus

main_menu = 
[
	["Inventory", MENU_ACTIONS.open_menu],
	["Equipment", MENU_ACTIONS.open_menu],
	["Skills",	  MENU_ACTIONS.open_menu],
	["Resume",	  MENU_ACTIONS.execute_script, resume_game],
	["Exit game", MENU_ACTIONS.execute_script, exit_game],
]

menu_list = [main_menu]

#endregion

