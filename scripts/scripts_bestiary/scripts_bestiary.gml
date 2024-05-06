var _al = global.action_library

global.enemies = 
{
	slime:
	{
		name: "Slime",
		hp: 1,
		max_hp: 8,
		mp: 5,
		max_mp: 5,
		attack: 4,
		magic: 4,
		agility: 3,
		defending: false,
		xp_loot: 5,
		sprites: {idle: spr_slime_side, attack: spr_slime_attack},
		actions: [_al.attack, _al.heal],
		ai_script: function()
		{
			// Escolher uma ação
			var _action = actions[choose(0, 0, 1)]
			var _target = -1
			
			// Ataque
			if _action == actions[0]
			{
				// Escolher como alvo um personagem aleatório que esteja vivo
				var _possible_targets = array_filter(obj_battle.allie_units, function(_unit) {
					return _unit.hp > 0
				})
				_target = _possible_targets[irandom(array_length(_possible_targets)-1)]
			}
			
			// Cura
			if _action == actions[1]
			{
				// Escolher como alvo um personagem aleatório que esteja vivo
				var _possible_targets = array_filter(obj_battle.enemy_units, function(_unit) {
					return _unit.hp > 0
				})
				_target = _possible_targets[irandom(array_length(_possible_targets)-1)]
			}
			
			// Retorna a ação e o alvo
			return [_action, _target]
		}
	}
}