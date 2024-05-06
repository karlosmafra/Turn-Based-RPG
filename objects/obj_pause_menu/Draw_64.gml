if global.paused
{
	draw_set_color(c_black)
	draw_set_alpha(0.5)
	draw_rectangle(0, 0, gw, gh, false)
	draw_set_color(c_white)
	draw_set_alpha(1)
	
	draw_menu(menu_list[current_menu])
}