#region Scripts da batalha

function scr_start_battle(_bg, _enemies) {
	
	obj_player.state = scr_player_turn_battle
	
	room_goto(rm_battle)
	
	// Inicia uma batalha passando os parâmetros: inimigo que iniciou o combate, a imagem de fundo
	// e um array com as informações dos inimigos a serem criados
	instance_create_layer(0, 0, "Instances", obj_battle, 
	{
		creator: id,
		prev_room: room,
		background: _bg,
		enemies: _enemies
	})
	
	// O inimigo se destrói depois de criar a batalha
	instance_destroy()
	
}
	
function scr_end_battle(_victory) {
	
	// Ganhar experiência da batalha
	if _victory
	{
		var _xp = 0
		for (var _i = 0; _i < array_length(enemy_units); _i++)
		{
			_xp += enemy_units[_i].xp_loot
		}
		
		for (var _i = 0; _i < array_length(global.party); _i++)
		{
			scr_gain_xp(global.party[_i], _xp)
		}
	}
	
	instance_destroy()
	
	with obj_player
	{
		create_camera = true
		state = scr_player_walking
		image_alpha = 1
	}
	
	room_goto(prev_room)
	
}

function scr_change_hp(_amount, _dead_or_alive, _target, _accuracy = 100, _crit_chance = 0, _crit_mod = 2) {
	// 0 - alvos mortos / 1 - alvos vivos / 2 - qualquer um // dead_or_alive
	var _fail = false
	if _dead_or_alive == 0 && hp > 0 {_fail = true}
	if _dead_or_alive == 1 && hp <= 0 {_fail = true}
	
	var _color = c_white
	
	if _fail
	{
		_amount = 0
	}
	
	// verificar se não é uma skill de cura
	if _amount < 0
	{
		// Chance de errar
		if scr_calculate_miss(_accuracy, _target.agility) == true
		{
			_amount = "MISS"
		}
		// Se não errou
		else
		{
			// Chance de critar
			if scr_calculate_critical(_crit_chance) == true
			{
				_amount *= _crit_mod
				_color = c_orange
			}
		
			// Alvo defendendo
			if _target.defending
			{
				_amount = round(_amount * 0.5)
			}
		}
	}
	// Se for skill de cura
	else
	{
		_color = c_lime
	}
	
	if !is_string(_amount)
	{
		hp = clamp(hp + _amount, 0, max_hp)
		// Alterar a vida do personagem fora da batalha
		if array_contains(obj_battle.allie_units, _target)
		{
			var _real_hp = global.characters[$ _target.name].hp
			var _real_max_hp = global.characters[$ _target.name].max_hp
			global.characters[$ _target.name].hp = clamp(_real_hp + _amount, 0, _real_max_hp)
		}
	}
	
	instance_create_depth(x, y-8, depth - 10, obj_change_hp, {amount: _amount, color: _color})
}
	
function scr_calculate_miss(_accuracy, _evade) {
	
	if irandom(100) + (_accuracy*2) - (_evade*2) < 5
	{
		return true
	}
	
	return false
	
}

function scr_calculate_critical(_chance) {
	
	if irandom(100) <= _chance
	{
		return true
	}
	
	return false
	
}
	
function scr_change_mp(_amount, _target) {
	
	if hp > 0
	{
		mp = clamp(mp + _amount, 0, max_mp)
		
		// Alterar a mana do personagem fora da batalha
		if array_contains(obj_battle.allie_units, _target)
		{
			var _real_mp = global.characters[$ _target.name].mp
			var _real_max_mp = global.characters[$ _target.name].max_mp
			global.characters[$ _target.name].mp = clamp(_real_mp + _amount, 0, _real_max_mp)
		}
	}
	
}

function scr_menu_select_action(_user, _action) {
	
	obj_menu.active = false
	with obj_battle
	{
		if _action.requires_target
		{
			with cursor
			{
				active = true
				active_user = _user
				active_action = _action
				target_all = _action.target_all
				if _action.target_all == MODE.VARIES
				{
					target_all = false
				}
				
				if _action.target_enemies
				{
					target_side = obj_battle.enemy_units
					target_index = 0
					// Filtar apenas inimigos vivos como possíveis alvos
					target_side = array_filter(target_side, function(_enemy) {
						return _enemy.hp > 0
					})
					active_target = target_side[target_index]
				} else
				{
					target_side = obj_battle.allie_units
					active_target = active_user
					var _self_index = function(_i) 
					{
						return _i == active_target
					}
					target_index = array_find_index(target_side, _self_index)
				}
				
			}
		}
		else
		{
			with obj_battle {scr_begin_action(_user, _action, -1)}
			instance_destroy(obj_menu)
		}
	}
}

#endregion

#region Estados da batalha

function scr_choose_action() {
	
	if !instance_exists(obj_menu)
	{
		var _user = units_turn_order[turn]
		
		_user.defending = false
	
		// Se quem for agir agora está morto, pula para a etapa de checar se a batalha acabou
		if _user.hp <= 0 || !instance_exists(_user)
		{
			battle_state = scr_check_battle_end
			exit
		}
	
		// Ação do jogador
		if _user.object_index == obj_unity_allie
		{
			// Criar o menu com as ações possíveis
			var _menu_options = []
			var _submenus = {}
			
			for (var _i = 0; _i < array_length(_user.actions); _i++)
			{
				var _action = _user.actions[_i]
				var _name_and_count = _action.name
				var _avail = _user.mp >= _action.mp_cost
				if _action.submenu == -1
				{
					array_push(_menu_options, {name: _name_and_count, func: scr_menu_select_action, args: [_user, _action], avail: _avail, priority: _action.priority})
				}
				else
				{
					// Criar os submenus inserindo as opções dentro deles
					if is_undefined(_submenus[$ _action.submenu])
					{
						variable_struct_set(_submenus, _action.submenu, [{name: _name_and_count, func: scr_menu_select_action, args: [_user, _action], avail: _avail}])
					}
					else
					{
						array_push(_submenus[$ _action.submenu], {name: _name_and_count, func: scr_menu_select_action, args: [_user, _action], avail: _avail})
					}
				}
			}
			
			// Transformar struct de submenus em array pra poder percorrer ele
			var _submenus_array = variable_struct_get_names(_submenus)
			
			// Adicionar submenus no menu
			for (var _i = 0; _i < array_length(_submenus_array); _i++)
			{
				// Adicionar opção de voltar dentro de cada submenu
				array_push(_submenus[$ _submenus_array[_i]], {name: "Back", func: scr_exit_submenu, args: -1, avail: true})
				
				// Seila. Eu acho q isso acesse os submenus, o submenu específico sendo adicionado, 
				// a primeira ação do submenu, os argumentos (que é a ação em si), a prioridade dela
				var _sub_action_priority = _submenus[$ _submenus_array[_i]][0].args[1].priority
				
				array_push(_menu_options, {name: _submenus_array[_i], func: scr_enter_submenu, args: [_submenus[$ _submenus_array[_i]]], avail: _avail, priority: _sub_action_priority})
			}
			
			// Organizar as opções do menu de acordo com a prioridade (ordem no enum ORDER)
			array_sort(_menu_options, function(_o1, _o2) {
				return _o1.priority - _o2.priority
			})
			
			scr_create_menu(10, 100, _menu_options)
		}
		// Ação do inimigo decidida pelo script de AI
		else
		{
			var _chosen_action = _user.ai_script()
			scr_begin_action(_user, _chosen_action[0], _chosen_action[1])
		}
	}
}

function scr_begin_action(_user, _action, _targets) {
	
	// Definir variáveis
	current_player = _user
	current_action = _action
	current_target = _targets
	text = string_ext(_action.description, [_user.name])
	
	// Converter o target para array se tiver só um alvo
	if !is_array(current_target) {current_target = [current_target]}
	// Reiniciar delay de cada ação
	delay_counter = delay_time
	
	// Definir sprite de quem está agindo
	with _user
	{
		acting = true
		// Checar se a ação e o player tem uma animação definida
		if !is_undefined(_action[$ "user_animation"]) && !is_undefined(_user.sprites[$ _action.user_animation])
		{
			sprite_index = sprites[$ _action.user_animation]
			image_index = 0
		}
	}
	
	battle_state = scr_perform_action
}

function scr_perform_action() {
	
	if current_player.acting
	{
		// Checar se a animação acabou
		if current_player.image_index >= current_player.image_number - 1
		{
			// Voltar ao idle e parar de agir
			with (current_player)
			{
				if !defending
				{
					image_index = 0
					sprite_index = sprites.idle
				}
				acting = false
			}
			// Criar efeito visual da ação se ele existir
			if !is_undefined(current_action[$ "effect_animation"])
			{
				// Efeito em alvos individuais
				if current_action.effect_on_target == MODE.ALWAYS || current_action.effect_on_target == MODE.VARIES && array_length(current_target) <= 1
				{
					for (var _t = 0; _t < array_length(current_target); _t++)
					{
						instance_create_depth(current_target[_t].x, current_target[_t].y, current_target[_t].depth - 10, obj_animation_effect, {sprite_index: current_action.effect_animation})
					}
				}
				// Efeito na tela inteira ou lugar fixo
				else
				{
					instance_create_depth(0, 0, -100, obj_animation_effect, {sprite_index: current_action.effect_animation})
				}
			}
			// Quando o player termina a animação a ação acontece
			current_action.func(current_player, current_target)
		}
	}
	// Se o personagem e o efeito da ação já tiverem terminado a animação passa pra próxima etapa com delay
	else
	{
		if !instance_exists(obj_animation_effect)
			{
				delay_counter--
				if delay_counter <= 0
				{
					battle_state = scr_check_battle_end
				}
			}
	}
	
}

function scr_check_battle_end() {
	
	text = ""
	
	var _enemies_alive = array_filter(enemy_units, function(_enemy) {
		return _enemy.hp > 0	
	})
	
	var _allies_alive = array_filter(allie_units, function(_unit) {
		return _unit.hp > 0	
	})
	
	// Vitória
	if array_length(_enemies_alive) <= 0
	{
		scr_end_battle(1)
	}
	// Derrota
	else if array_length(_allies_alive) <= 0
	{
		 scr_end_battle(0)
	}
	// Continuar
	else
	{
		battle_state = scr_next_turn
	}
}

function scr_next_turn() {
	turn++
	turn_count++
	if turn >= array_length(units_turn_order)
	{
		turn = 0
		round_count++
	}
	battle_state = scr_choose_action
}


#endregion