if active
{
	var _up = keyboard_check_pressed(ord("W"))
	var _down = keyboard_check_pressed(ord("S"))

	if _up || _down 
	{
		selected += _down - _up
		if selected >= array_length(options) {selected = 0}
		if selected < 0 {selected = array_length(options)-1}
	}

	if keyboard_check_pressed(vk_enter)
	{
		if options[selected].func != -1 && options[selected].avail == true
		{
			var _func = options[selected].func
			if options[selected].args != -1
			{
				script_execute_ext(_func, options[selected].args)
			}
			else
			{
				_func()
			}
		}
	}

	if keyboard_check_pressed(vk_escape)
	{
		if submenu_level > 0
		{
			scr_exit_submenu()
		}
	}
}
