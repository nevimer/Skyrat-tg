/obj/machinery/power/orb_engine
	icon = 'modular_skyrat/master_files/icons/orb.dmi'
	light_color = COLOR_FULL_TONER_BLACK
	var/animated
	var/list/gasmix
	var/power_level
	var/score
		///Our internal radio
	var/obj/item/radio/radio
	///The key our internal radio uses
	var/radio_key = /obj/item/encryptionkey/headset_eng
	var/datum/gas_mixture/absorbed_gasmix
	var/instability

/obj/machinery/power/orb_engine/Initialize(mapload)
	. = ..()
	start_animation()
	SSair.start_processing_machine(src)
	addtimer(CALLBACK(src, .proc/process_atmos), 1 SECONDS)
/obj/machinery/power/orb_engine/bullet_act(obj/projectile/projectile)
	if(projectile.damage)
		power_level += projectile.damage


	return BULLET_ACT_HIT
/obj/machinery/power/orb_engine/process_atmos()
	zap()
//	do_effects_on_mobs()
	var/turf/local_turf = get_turf(src)
	var/datum/gas_mixture/env = local_turf.return_air()
	if(power_level)
		absorbed_gasmix = env.remove(env.total_moles())
		absorbed_gasmix.assert_gases(/datum/gas/plasma, /datum/gas/oxygen)
		absorbed_gasmix.temperature = ((power_level) / THERMAL_RELEASE_MODIFIER)
		absorbed_gasmix.temperature = max(TCMB, min(absorbed_gasmix.temperature, 2500))
		absorbed_gasmix.gases[/datum/gas/plasma][MOLES] = max((power_level) / PLASMA_RELEASE_MODIFIER, 0)
		absorbed_gasmix.gases[/datum/gas/oxygen][MOLES] = max(((power_level + TCMB) - T0C) / OXYGEN_RELEASE_MODIFIER, 0)
		absorbed_gasmix.garbage_collect()
		env.merge(absorbed_gasmix)
		power_level = power_level / 12
	addtimer(CALLBACK(src, .proc/process_atmos), 1 SECONDS)
	update_animation()

/obj/machinery/power/orb_engine/proc/update_animation()

	var/filters_to_add
	var/rays_filter = filter(type="rays", size = clamp((instability/100)+1*power_level, 50, 125), color = COLOR_FULL_TONER_BLACK, factor = clamp(instability/300, 1, 30), density = clamp(instability/5, 12, 200))
	filters_to_add |= rays_filter
	if(instability) // Let's jump to a special effect if we can.
		var/icon/causality_field = new/icon('icons/obj/supermatter.dmi', "causality_field", frame = rand(1,4))
		var/causality_filter = filter(type="layer", icon = causality_field, flags = FILTER_OVERLAY)
		filters_to_add |= causality_filter

	filters |= filters_to_add

/obj/machinery/power/orb_engine/proc/start_animation()
	add_filter("rays", 1, list(type="rays", size = clamp(power_level/30, 1, 125), color = COLOR_FULL_TONER_BLACK, factor = 0.6, density = 12))
	animate(filters[1], time = 10 SECONDS, offset = 10, loop=-1)
	animate(time = 10 SECONDS, offset = 0, loop=-1)
	animate(filters[1], time = 2 SECONDS, size = 80, loop=-1, flags = ANIMATION_PARALLEL)
	animate(time = 2 SECONDS, size = 10, loop=-1, flags = ANIMATION_PARALLEL)
	animated = TRUE
/obj/machinery/power/orb_engine/proc/zap()
	for(var/obj/machinery/power/energy_accumulator/tesla_coil/coiled in orange(7))
		if(coiled.anchored)
			coiled.zap_act(200, ZAP_GENERATES_POWER)

/* /obj/machiner/power/orb_engine/proc/do_effects_on_mobs()
	if(prob(5))
		for(var/mob/living in orange(7))
//			living.hallucination += 10
	if(prob(5))
		for(var/mob/living in orange(7))
			to_chat(living, pick("Ehehe..", "Knock Knock.."))
 */
