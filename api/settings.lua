nssm.mymapgenis = tonumber(minetest.settings:get('nssm.mymapgenis')) or 7
nssm.multimobs = tonumber(minetest.settings:get('nssm.multimobs')) or 1000

nssm.server_rainbow_staff = minetest.settings:get_bool('nssm.server_rainbow_staff', false)

nssm.inhibition_radius = tonumber(minetest.settings:get('nssm.inhibition_radius')) or 8

nssm.energy_boosts = minetest.settings:get_bool('nssm.energy_boosts')

nssm.energy_lights = minetest.settings:get_bool('nssm.energy_lights')

nssm.unswappable_nodes = minetest.settings:get('nssm.unswappable_nodes') or ""
nssm.unswappable_nodes = nssm.unswappable_nodes:split(",")

minetest.debug( "------------> "..dump(nssm.unswappable_nodes) )
