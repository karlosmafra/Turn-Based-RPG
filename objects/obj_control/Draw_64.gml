draw_text(5, 5, "Level: " + string(global.characters.PC.level))
draw_text(5, 16, string(global.characters.PC.xp) + "/" + string(global.characters.PC.max_xp))

draw_text(5, 32, "PC Ag: " + string(global.characters.PC.agility))
draw_text(5, 44, "PC Mgk: " + string(global.characters.PC.magic))
draw_text(5, 56, "PC Atk: " + string(global.characters.PC.attack))
draw_text(5, 68, "Mage Ag: " + string(global.characters.Mage.agility))
draw_text(5, 80, "Mage Mkg: " + string(global.characters.Mage.magic))
draw_text(5, 92, "Mage Atk: " + string(global.characters.Mage.attack))