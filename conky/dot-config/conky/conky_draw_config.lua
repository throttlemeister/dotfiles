-- Define your visual elements here
-- For examples, and a complete list on the possible elements and their
-- properties, go to https://github.com/fisadev/conky-draw/
-- (and be sure to use the lastest version)

elements = {
	kind = "ring_graph",
	center = { x = 50, y = 50 },
	conky_value = "cpu cpu0",
	radius = 30,
	graduated = true,
	number_graduation = 40,
	angle_between_graduation = 3,
	start_angle = 0,
	end_angle = 360,
	color = 0xFF6600,
	background_color = 0xD75600,
}
