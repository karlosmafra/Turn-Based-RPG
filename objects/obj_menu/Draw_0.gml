if active
{
	draw_sprite_stretched(spr_command_box, 0, x, y, width + xmargin * 2, height + ymargin * 2)

	// Desenhar opções
	var _lh = 12
	var _scroll_push = max(0, selected - (max_options_visible - 1))

	for (var _o = 0; _o < max_options_visible; _o++)
	{
		if _o >= array_length(options) break
		draw_set_halign(fa_left)
		draw_set_valign(fa_top)
		draw_set_color(c_white)
		draw_set_alpha(1)
		// Desenhar título
		if title != -1 && _o == 0
		{
			draw_text(x + xmargin, y + ymargin, title)
		}
		var _option_drawn = options[_o + _scroll_push]
		if _option_drawn.avail == false {draw_set_color(c_grey)}
		if _o == selected - _scroll_push 
		{
			draw_set_color(c_yellow)
			if _option_drawn.avail == false
			{
				draw_set_alpha(0.7)
			}
		}
		draw_text(x + xmargin, y + ymargin + _lh * (_o  + (title != -1)), _option_drawn.name)
	}
}

draw_set_halign(fa_left)
draw_set_valign(fa_top)
draw_set_color(c_white)
draw_set_alpha(1)