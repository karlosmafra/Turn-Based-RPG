if keyboard_check_pressed(vk_escape) && room != rm_battle
{
	global.paused = !global.paused
	selected[current_menu] = 0
}

if global.paused
{
	navigate_menu()
}