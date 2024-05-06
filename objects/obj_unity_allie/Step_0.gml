if hp <= 0
{
	sprite_index = sprites.dead
} 
else if sprite_index == sprites.dead 
{
	image_index = 0
	sprite_index = sprites.idle
}