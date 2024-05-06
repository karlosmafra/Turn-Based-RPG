if global.paused
{
	if image_speed != 0
	{
		img_spd = image_speed
	}
	image_speed = 0
	exit
}
else
{
	image_speed = img_spd
}	