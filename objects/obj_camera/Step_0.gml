if follow != noone
{
	xx = follow.x
	yy = follow.y
}

x = lerp(x, xx, 0.08)
y = lerp(y, yy, 0.08)

camera_set_view_pos(view_camera[0], x - cam_width/2, y - cam_height/2)
