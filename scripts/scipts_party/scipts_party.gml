#region Actions

enum ORDER
{
	attack,
	magic,
	defend,
	item
}

global.action_library =
{
	attack:
	{
		name: "Attack",
		submenu: -1,
		priority: ORDER.attack,
		mp_cost: 0,
		requires_target: true,
		target_all: MODE.NEVER,
		target_enemies: MODE.ALWAYS,
		user_animation: "attack",
		effect_animation: spr_attack_effect,
		effect_on_target: MODE.ALWAYS,
		description: "{0} attacks!",
		func: function(_user, _targets) 
		{
			var _damage = irandom_range(_user.attack * 0.6, _user.attack * 0.8)
			with _targets[0]
			{
				scr_change_hp(-_damage, 1, _targets[0], _user.agility, 2)
			}
		}
	},
	
	defend:
	{
		name: "Defend",
		submenu: -1,
		priority: ORDER.defend,
		mp_cost: 0,
		requires_target: false,
		target_all: MODE.NEVER,
		target_enemies: MODE.NEVER,
		user_animation: "attack",
		description: "{0} guards!",
		func: function(_user, _targets)
		{
			with _user
			{
				defending = true
			}
		}
	},
	
	ice:
	{
		name: "Ice",
		submenu: "Magic",
		priority: ORDER.magic,
		mp_cost: 4,
		requires_target: true,
		target_all: MODE.VARIES,
		target_enemies: MODE.ALWAYS,
		user_animation: "attack",
		effect_animation: spr_attack_effect,
		effect_on_target: MODE.ALWAYS,
		description: "{0} casts ice!",
		func: function(_user, _targets)
		{
			with _user {scr_change_mp(-4, _user)}
			var _damage = irandom_range(_user.magic * 0.8, _user.magic * 1.1)
			if array_length(_targets) > 1 
			{
				_damage = irandom_range(_user.magic * 0.4, _user.magic * 0.7)
			}
			for (var _i = 0; _i < array_length(_targets); _i++)
			{
				with _targets[_i]
				{
					scr_change_hp(-_damage, 1, _targets[_i], _user.magic * 2)
				}
			}
		}
	},
	
	heal:
	{
		name: "Heal",
		submenu: "Magic",
		priority: ORDER.magic,
		mp_cost: 2,
		requires_target: true,
		target_all: MODE.NEVER,
		target_enemies: MODE.NEVER,
		user_animation: "attack",
		effect_animation: spr_attack_effect,
		effect_on_target: MODE.ALWAYS,
		description: "{0} casts heal!",
		func: function(_user, _targets)
		{
			with _user {scr_change_mp(-2, _user)}
			var _heal = irandom_range(_user.magic * 0.4, _user.magic * 0.8)
			with _targets[0]
			{
				scr_change_hp(_heal, 1, _targets[0])
			}
		}
	}
}

enum MODE
{
	NEVER,
	ALWAYS,
	VARIES
}

#endregion

#region Characters

var _al = global.action_library

global.characters = 
{
	PC:
	{
		name: "PC",
		hp: 13,
		max_hp: 13,
		mp: 6,
		max_mp: 6,
		attack: 5,
		magic: 3,
		agility: 4,
		level: 1,
		xp: 0,
		max_xp: 15,
		sp: 0,
		defending: false,
		sprites: {idle: spr_pc_idle_battle, attack: spr_pc_attack_side, cast: spr_pc_attack_side, dead: spr_player_dead},
		actions: [_al.attack, _al.defend]
	},
	
	Mage:
	{
		name: "Mage",
		hp: 10,
		max_hp: 10,
		mp: 10,
		max_mp: 10,
		attack: 4,
		magic: 6,
		agility: 4,
		level: 2,
		xp: 0,
		max_xp: 30,
		sp: 0,
		defending: false,
		sprites: {idle: spr_mage_idle_battle, attack: spr_mage_cast, cast: spr_mage_cast, dead: spr_mage_dead},
		actions: [_al.attack, _al.ice,  _al.heal, _al.defend]
	}
}

#endregion

#region Party

var _c = global.characters

global.party = [_c.PC, _c.Mage]

global.available_party = [_c.PC, _c.Mage]

#endregion

#region Level Up

global.level_stats = 
{
	xp_limit: [15, 20, 30, 45, 65],
	
	PC:
	{
		max_hp:  [0, 2, 3, 3, 4],
		max_mp:  [0, 2, 2, 2, 3],
		attack:  [0, 1, 2, 2, 2],
		magic:   [0, 1, 1, 1, 2],
		agility: [0, 1, 1, 2, 2],
		sp:		 [0, 2, 2, 3, 3]
	},
	
	Mage:
	{
		max_hp:  [0, 2, 2, 2, 3],
		max_mp:  [0, 2, 3, 3, 3],
		attack:  [0, 1, 1, 1, 2],
		magic:   [0, 2, 2, 2, 2],
		agility: [0, 1, 1, 1, 1],
		sp:		 [0, 2, 2, 3, 3]
	}
}

function scr_gain_xp(_char, _amount) {
	
	with _char
	{
		xp += _amount
	
		if xp >= max_xp
		{
			level++
			xp -= max_xp
			
			// Aplicar os efeitos de level up (aumentar os status e tal)
			var _ls = global.level_stats
			
			max_hp  += _ls[$ _char.name].max_hp[level-1]
			hp		 = clamp(hp +  _ls[$ _char.name].max_hp[level-1], 0, max_hp)
			max_mp  += _ls[$ _char.name].max_mp[level-1]
			mp		 = clamp(mp +  _ls[$ _char.name].max_mp[level-1], 0, max_mp)
			attack  += _ls[$ _char.name].attack[level-1]
			magic   += _ls[$ _char.name].magic[level-1]
			agility += _ls[$ _char.name].agility[level-1]
			sp		+= _ls[$ _char.name].sp[level-1]
			max_xp   = _ls.xp_limit[level-1] 
			
		}
	}
	
}

#endregion