mobs:register_mob("nssm:silversand_dragon", {
	type = "monster",
	hp_max = 160,
	hp_min = 160,
	collisionbox = {-0.65, -0.4, -0.65, 0.65, 0.4, 0.65},
	visual = "mesh",
	mesh = "silversand_dragon.x",
	textures = {{"silversand_dragon.png"}},
	visual_size = {x=18, y=18},
	view_range = 40,
	lifetimer = 500,
	rotate = 270,
	walk_velocity = 1,
	run_velocity = 3,
	stepheight = 2.1,
	--[[sounds = {
		random = "silversand_dragon",
		distance = 45,
	},]]
	damage = 1,
	jump = false,
	drops = {
		{name = "nssm:life_energy",
		chance = 1,
		min = 70,
		max = 80,},
		{name = "nssm:sun_feather",
		chance = 1,
		min = 1,
		max = 1,},
	},
	armor = 40,
	drawtype = "front",
	water_damage = 3,
	lava_damage = 3,
	light_damage = 0,
	blood_texture="silversand_particle.png",
	blood_amount=50,
	on_rightclick = nil,
	attack_type = "dogfight",
	reach = 15,
	shoot_interval = 4,
	animation = {
		speed_normal = 25,
		speed_run = 50,
		speed_die = 20,
		stand_start = 0,
		stand_end = 60,
		walk_start = 70,
		walk_end = 110,
		run_start = 70,
		run_end = 110,
		punch_start = 80,
		punch_end = 110,
		shoot_start = 80,
		shoot_end = 110,
		die_start = 120,
		die_end = 140,
	},

	custom_attack = function(self)
		local p = self.attack:getpos()
		local s = self.object:getpos()
		local ss = {x = s.x, y = s.y +0.5, z = s.z}
		local pp = {x = p.x, y = p.y +1.5, z = p.z}
		local vel = vector.subtract(pp,ss)
		set_animation(self, "punch")

		if minetest.line_of_sight({x = p.x, y = p.y +1.5, z = p.z}, {x = s.x, y = s.y +1.5, z = s.z}) == true then
			-- play attack sound
			if self.sounds.attack then
				minetest.sound_play(self.sounds.attack, {
					object = self.object,
					max_hear_distance = self.sounds.distance
				})
			end
			-- punch player
			self.attack:punch(self.object, 1.0,  {
				full_punch_interval=1.0,
				damage_groups = {fleshy=self.damage}
			}, nil)
		end

		minetest.add_particlespawner(
			225, --amount
			0.5, --time
			ss, --minpos
			ss, --maxpos
			vector.multiply(vel, 2), --minvel
			vector.multiply(vel, 4), --maxvel
			{x=0,y=0,z=0}, --minacc
			{x=0,y=0,z=0}, --maxacc
			4, --minexptime
			5, --maxexptime
			5, --minsize
			10, --maxsize
			true, --collisiondetection
			"silversand_particle.png" --texture
		)
	end
})