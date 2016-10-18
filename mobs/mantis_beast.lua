mobs:register_mob("nssm:mantis_beast", {
	type = "monster",
	hp_max = 30,
	hp_min = 27,
	collisionbox = {-0.65, 0.00, -0.65, 0.65, 1.50, 0.65},
	visual = "mesh",
	mesh = "mantis_beast.x",
	textures = {{"mantis_beast.png"}, {"mantis_beast2.png"}},
	visual_size = {x=6, y=6},
	makes_footstep_sound = true,
	view_range = 25,
	fear_height = 4,
	walk_velocity = 2.5,
	run_velocity = 3.5,
    sounds = {
		random = "manti",
	},
	damage = 5,
	reach = 2,
	jump = true,
	drops = {
		{name = "nssm:mantis_claw",
		chance = 2,
		min = 1,
		max = 6,},
		{name = "nssm:life_energy",
		chance = 1,
		min = 2,
		max = 3,},
		{name = "nssm:mantis_skin",
		chance = 3,
		min = 1,
		max = 2,},
		{name = "nssm:mantis_meat",
		chance = 2,
		min = 1,
		max = 2,},
	},
	armor = 70,
	drawtype = "front",
	water_damage = 2,
	lava_damage = 5,
	light_damage = 0,
	on_rightclick = nil,
	attack_type = "dogfight",
	animation = {
		speed_normal = 15,
		speed_run = 20,
		stand_start = 0,
		stand_end = 60,
		walk_start = 70,
		walk_end = 110,
		run_start = 70,
		run_end = 110,
		punch_start = 140,
		punch_end = 165,
	}
})
