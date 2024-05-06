var _bgw = room_width / sprite_get_width(background)
var _bgh = room_height / sprite_get_height(background)
draw_sprite_ext(background, 0, 0, 0, _bgw, _bgh, 0, c_white, 1)

// Desenhar unidades na ordem
var _unit_with_turn = units_turn_order[turn].id
for (var _i = 0; _i < array_length(units_render_order); _i++)
{
	with units_render_order[_i]
	{
		draw_self()
	}
}

// Desenhar caixa de texto
draw_sprite_stretched(spr_command_box, 0, 0, room_height - 70, 80, 70)
draw_sprite_stretched(spr_command_box, 0, 81, room_height - 70, room_width - 81, 70)

#region Escrever nome dos stats

draw_set_color(c_grey)
draw_set_halign(fa_left)
draw_set_valign(fa_top)
draw_set_font(fnt_battle_text)

#macro COLUMN_ENEMIES 10
#macro COLUMN_NAME 90
#macro COLUMN_HP 180
#macro COLUMN_MP 250

draw_text(COLUMN_ENEMIES, 115, "Enemies")
draw_text(COLUMN_NAME, 115, "Name")
draw_text(COLUMN_HP, 115, "HP")
draw_text(COLUMN_MP, 115, "MP")

#endregion

// Desenhar nomes dos inimigos
var _drawn = 0
var _draw_limit = 3
for (var _i = 0; _i < array_length(enemy_units) && _drawn <= _draw_limit; _i++)
{
	var _enemy = enemy_units[_i]
	if _enemy.hp > 0
	{
		draw_set_color(c_white)
		if _enemy == _unit_with_turn {draw_set_color(c_yellow)}
		draw_text(COLUMN_ENEMIES, 128 + (_i * 12), _enemy.name)
	}
}

// Desenhar stats dos personagens
for (var _i = 0; _i < array_length(allie_units); _i++)
{
	var _char = allie_units[_i]
	
	draw_set_color(c_white)
	if _char.hp <= 0 {draw_set_color(c_red)}
	if _char == _unit_with_turn {draw_set_color(c_yellow)}
	draw_text(COLUMN_NAME, 128 + (_i * 12), _char.name)
	
	draw_set_color(c_white)
	if _char.hp < (_char.max_hp * 0.5) {draw_set_color(c_orange)}
	if _char.hp <= 0 {draw_set_color(c_red)}
	draw_text(COLUMN_HP, 128 + (_i * 12), string(_char.hp) + "/" + string(_char.max_hp))
	
	draw_set_color(c_white)
	if _char.mp < (_char.max_mp * 0.5) {draw_set_color(c_orange)}
	if _char.mp <= 0 {draw_set_color(c_red)}
	draw_text(COLUMN_MP, 128 + (_i * 12), string(_char.mp) + "/" + string(_char.max_mp))
	
}

// Desenhar cursor
if cursor.active && cursor.active_target != noone
{
	if !is_array(cursor.active_target)
	{
		draw_sprite(spr_cursor, 0, cursor.active_target.x, cursor.active_target.y)
	}
	else
	{
		var _alpha = sin(get_timer() * 0.000007) + 1.01
		draw_set_alpha(_alpha)
		for (var _i = 0; _i < array_length(cursor.active_target); _i++)
		{
			draw_sprite(spr_cursor, 0, cursor.active_target[_i].x, cursor.active_target[_i].y)
		}
		draw_set_alpha(1)
	}
}

// Desenhar texto de descrição da ação
if text != ""
{
	var _width = string_width(text) + 16
	draw_set_font(fnt_battle_text)
	draw_sprite_stretched(spr_command_box, 0, room_width/2 - _width/2, 10, _width, 20)
	draw_set_halign(fa_center)
	draw_set_valign(fa_middle)
	draw_set_color(c_white)
	draw_text(room_width/2, 21, text)
}

// Resetar
draw_set_color(c_white)
draw_set_halign(fa_left)
draw_set_valign(fa_top)
