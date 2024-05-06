units = []
units_turn_order = []
units_render_order = []
current_player = noone
current_action = -1
current_target = noone
delay_time = 30
delay_counter = 0
text = ""
turn = 0
turn_count = 0
round_count = 0
battle_state = scr_choose_action

// Cursor de selecionar o alvo
cursor = 
{
	active: false,
	active_user: noone,
	active_action: -1,
	active_target: noone,
	target_side: -1,
	target_all: false,
	target_index: 0,
	confirm_delay: 0
}

// Criar party
for (var _i = 0; _i < array_length(global.party); _i++)
{
	allie_units[_i] = instance_create_layer(80 - (_i * 8), 60 + (_i * 16), "Instances", obj_unity_allie, global.party[_i])
	array_push(units, allie_units[_i])
}

// Criar inimigos
for (var _i = 0; _i < array_length(enemies); _i++)
{
	enemy_units[_i] = instance_create_layer(235 - (_i * 8), 60 + (_i * 16), "Instances", obj_unity_enemy, enemies[_i])
	array_push(units, enemy_units[_i])
}

// Definir ordem de agir
array_copy(units_turn_order, 0, units, 0, array_length(units))
array_sort(units_turn_order, function(_u1, _u2)
{
	return irandom_range(round(_u2.agility * 0.8) , round(_u2.agility * 1.2)) - irandom_range(round(_u1.agility * 0.8) , round(_u1.agility * 1.2))
})

// Definir ordem de desenhar
define_render_order = function() {
	units_render_order = []
	array_copy(units_render_order, 0, units, 0, array_length(units))
	array_sort(units_render_order, function(_u1, _u2)
	{
		return _u1.y - _u2.y
	})
}
define_render_order()
