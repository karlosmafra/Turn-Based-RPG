battle_state()

// Controlar o cursor de selecionar alvo
if cursor.active
{
	with cursor
	{
		confirm_delay++
		
		var _up = keyboard_check_pressed(ord("W"))
		var _down = keyboard_check_pressed(ord("S"))
		var _enter = keyboard_check_pressed(vk_enter)
		var _esc = keyboard_check_pressed(vk_escape)
		var _shift = keyboard_check_pressed(vk_shift)
		
		if !target_all
		{
			// Alternar alvo
			target_index += _down - _up
			if target_index >= array_length(target_side)
			{
				target_index = 0
			}
			if target_index < 0
			{
				target_index = array_length(target_side) - 1
			}
			active_target = target_side[target_index]
			// Alternar entre UM e TODOS
			if active_action.target_all == MODE.VARIES && _shift
			{
				target_all = true
			}
		}
		else
		{
			// Selecionar todos
			active_target = target_side
			// Alternar entre UM e TODOS
			if active_action.target_all == MODE.VARIES && _shift
			{
				target_all = false
			}
		}
		
		if _enter && confirm_delay > 3
		{
			active = false
			confirm_delay = 0
			with obj_battle {scr_begin_action(cursor.active_user, cursor.active_action, cursor.active_target)}
			instance_destroy(obj_menu)
		}
		
		if _esc && !_enter
		{
			active = false
			confirm_delay = 0
			obj_menu.active = true
		}
	}
}
