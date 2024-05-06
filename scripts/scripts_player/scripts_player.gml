function scr_collision() {
	
	// Colisão

	if place_meeting(x + hspd, y, obj_block)
	{
		while !place_meeting(x + sign(hspd), y, obj_block)
		{
			x += sign(hspd)
		}
		hspd = 0
	}
	x += hspd

	if place_meeting(x, y + vspd, obj_block)
	{
		while !place_meeting(x, y + sign(vspd), obj_block)
		{
			y += sign(vspd)
		}
		vspd = 0
	}
	y += vspd
	
}

function scr_player_walking() {
	scr_collision()
	
	// Inputs

	var _left = keyboard_check(ord("A"))
	var _right = keyboard_check(ord("D"))
	var _up = keyboard_check(ord("W"))
	var _down = keyboard_check(ord("S"))
	var _attack = keyboard_check_pressed(ord("Q"))

	#region Movimentação

	var _hmove = _right - _left
	var _vmove = _down - _up

	if _hmove != 0 || _vmove != 0
	{
		spd = max_spd
		spd_dir = point_direction(x, y, x + _hmove, y + _vmove)
	}
	else
	{
		spd = 0
	}
	
	hspd = lengthdir_x(spd, spd_dir)
	vspd = lengthdir_y(spd, spd_dir)
	
	#endregion
	
	#region Troca de sprites

	var _dir = floor((spd_dir + 45)/90)
	
	if spd != 0
	{
		switch _dir
		{
			case 0:
				sprite_index = spr_pc_walk_side
				image_xscale = 1
			break
			case 1:
				sprite_index = spr_pc_walk_up
				image_xscale = 1
			break
			case 2:
				sprite_index = spr_pc_walk_side
				image_xscale = -1
			break
			case 3:
				sprite_index = spr_pc_walk_down
				image_xscale = 1
			break
		}
	}
	else
	{
		switch _dir
		{
			case 0:
				sprite_index = spr_pc_idle_side
				image_xscale = 1
			break
			case 1:
				sprite_index = spr_pc_idle_up
				image_xscale = 1
			break
			case 2:
				sprite_index = spr_pc_idle_side
				image_xscale = -1
			break
			case 3:
				sprite_index = spr_pc_idle_down
				image_xscale = 1
			break
		}
	}
	
	#endregion

	if _attack
	{
		image_index = 0
		state = scr_player_attack
	}

}
	
function scr_player_attack() {

	scr_collision()
	
	hspd = 0
	vspd = 0
	
	var _dir = floor((spd_dir + 45)/90)
	var _hitbox_sprite = -1
	
	switch _dir
	{
		case 0:
			sprite_index = spr_pc_attack_side
			image_xscale = 1
			_hitbox_sprite = spr_pc_attack_side_hb
		break
		case 1:
			sprite_index = spr_pc_attack_up
			image_xscale = 1
			_hitbox_sprite = spr_pc_attack_up_hb
		break
		case 2:
			sprite_index = spr_pc_attack_side
			image_xscale = -1
			_hitbox_sprite = spr_pc_attack_side_hb
		break
		case 3:
			sprite_index = spr_pc_attack_down
			image_xscale = 1
			_hitbox_sprite = spr_pc_attack_down_hb
		break
	}
	
	if !instance_exists(obj_attack_hitbox) && image_index < 1
	{
		instance_create_layer(x, y, layer, obj_attack_hitbox, {sprite_index: _hitbox_sprite, image_xscale: obj_player.image_xscale})
	}
	
}
	
function scr_player_turn_battle() {
	image_alpha = 0
}