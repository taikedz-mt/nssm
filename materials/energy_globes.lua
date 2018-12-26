-- Eat energy for a stats boost

local life_energy_ratings = {}
local coefficients = {
    gravity = 1.4,
    speed = 1.8
}

local players_boost_check = 0
local players_boosted = {}

local function stack_boost(playername, duration)
    local time_remaining = players_boosted[playername]

    if time_remaining then
        time_remaining = time_remaining + duration
    else
        time_remaining = duration
    end

    players_boosted[playername] = time_remaining
    return time_remaining
end

local function drain_boost(playername, duration)
    local time_remaining = players_boosted[playername]

    if not time_remaining then return 0 end

    time_remaining = time_remaining - duration

    if time_remaining <= 0 then
        players_boosted[playername] = nil
        return 0
    end

    players_boosted[playername] = time_remaining

    return time_remaining
end

local function set_player_boost(user, duration, power)
    local antigravity = power or 1.8
    local phys = user:get_physics_override()

    user:set_physics_override({speed = 2, gravity = 0.5})
    local remaining = stack_boost(user:get_player_name(), duration)

    minetest.chat_send_player(user:get_player_name(), "You have "..(math.floor(remaining*10)/10).."s of boost")

    local userpos = user:get_pos()
    minetest.sound_play("nssm_energy_powerup", {
        pos = userpos,
        max_hear_distance = 20,
        gain = 1,
    })
end

minetest.register_globalstep(function(dtime)
    local playername, data, remaining

    players_boost_check = players_boost_check + dtime
    local reduce_time = 0
    if players_boost_check > 0.5 then
        reduce_time = players_boost_check
        players_boost_check = 0
    end

    -- Power down players with boosts whose time is run out
    for playername, data in pairs(players_boosted) do
        remaining = drain_boost(playername, reduce_time)
        if remaining <= 0 then
            local player = minetest.get_player_by_name(playername)
            player:set_physics_override({speed = 1, gravity = 1})
        end
    end

end)

local function eat_energy(itemstack, user, pointedthing)

    local nutrition = life_energy_ratings[itemstack:get_name()].nutrition
    local duration = life_energy_ratings[itemstack:get_name()].duration

    local hp = user:get_hp()
    hp = hp + nutrition
    if hp > 20 then hp = 20 end
    user:set_hp(hp)

    set_player_boost(user, duration)

    itemstack:take_item()

    return itemstack
end

-- Define energies

local function register_energy(name, descr, nodesize, nutrition, duration)
    life_energy_ratings["nssm:"..name] = {nutrition = nutrition, duration = duration}
    local ns = nodesize
    local div = 64

    --[[
    minetest.register_craftitem("nssm:"..name, {
        description = descr,
        image = name..".png",
        on_use = eat_energy,
    })
    --]]

    minetest.register_node("nssm:"..name, {
        description = descr,
        tiles = {
            {
                name="venomous_gas_animated2.png",
                animation={
                    type="vertical_frames",
                    aspect_w=64,
                    aspect_h=64,
                    length=3.0
                }
            }
        },
        --[[
        tiles = {
            {
                name = "default_water_source_animated.png^[colorize:yellow:100",
                animation = {
                    type = "vertical_frames",
                    aspect_w = 16,
                    aspect_h = 16,
                    length = 2.0,
                },
            },
        }, --]]

        wield_image = name..".png",
        inventory_image = name..".png",
        drawtype = "nodebox",
        node_box = {
            type = "fixed",
            fixed = {
                {-ns / div, -ns / div, -ns / div, ns / div, ns / div, ns / div},
            },
        },
        paramtype = "light",
        light_source = nodesize,
        sunlight_propagates = true,
        is_ground_content = false,
        groups = {dig_immediate = 3},
        pointable = false,
        drop = "",
        buildable_to = true,
        on_use = eat_energy,
        walkable = false,
        -- TODO add node timer so it disappears after N seconds ...
    })
end

local function register_energy_craft(smaller,bigger)
    minetest.register_craft({
        output = bigger,
        recipe = {
            {smaller,smaller,smaller},
            {smaller,smaller,smaller},
            {smaller,smaller,smaller},
        }
    })

    minetest.register_craft({
        output = smaller.." 9",
        type = "shapeless",
        recipe = {bigger}
    })
end

register_energy('life_energy', 'Life Energy', 6, 2, 1)
register_energy('energy_globe', 'Energy Sphere', 9, 5, 2.5)
register_energy('great_energy_globe', 'Great Energy Sphere', 12, 12, 5)
register_energy('superior_energy_globe', 'Awesome Energy Sphere', 15, 18, 10)

register_energy_craft("nssm:life_energy", "nssm:energy_globe")
register_energy_craft("nssm:energy_globe", "nssm:great_energy_globe")
register_energy_craft("nssm:great_energy_globe", "nssm:superior_energy_globe")
