// Opções do menu contém: name, func, args, avail, priority

function scr_create_menu(_x, _y, _options, _max_visible = 3, _title = -1, _width = undefined, _height = undefined){
	
	var _menu = instance_create_depth(_x, _y, -9999, obj_menu)
	
	with _menu
	{
		options = _options
	
		// Definir largura para ser a mesma da maior palavra das opções
		if _width == undefined
		{
			_width = 1
			for (var _o = 0; _o < array_length(_options); _o++)
			{
				_width = max(_width, string_width(_options[_o].name))
			}
			_width = max(_width ,string_width(_title))
		}
	
		if _height == undefined
		{
			var _lh = 12
			_height = _lh * (_max_visible + (_title != -1))
		}
	
		max_options_visible = _max_visible
		title = _title
		width = _width
		height = _height
	}
}

function scr_enter_submenu(_options) {
	
	// Guardar menus anteriores
	previous_options[submenu_level] = options
	previous_selected[submenu_level] = selected
	submenu_level++
	
	options = _options
	selected = 0
	
}

function scr_exit_submenu() {
	
	submenu_level--
	options = previous_options[submenu_level]
	selected = previous_selected[submenu_level]
	
}
