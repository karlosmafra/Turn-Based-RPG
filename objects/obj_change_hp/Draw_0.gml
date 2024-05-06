draw_set_font(fnt_battle_text)
draw_set_halign(fa_center)
draw_set_valign(fa_middle)

draw_set_alpha(alpha)
draw_set_color(color)

if !is_string(amount)
{
	draw_text(x, y, abs(amount))
}
else
{
	draw_text(x, y, amount)
}


draw_set_halign(fa_left)
draw_set_valign(fa_top)
draw_set_alpha(1)
draw_set_color(c_white)