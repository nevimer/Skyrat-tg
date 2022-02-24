/obj/machinery/soul_seeker
	icon = 'modular_skyrat/modules/self_actualization_device/icons/self_actualization_device.dmi'
	icon_state = "sad_closed"
	state_open = FALSE
	circuit = /obj/item/circuitboard/machine/soul_seeker
	Initialize(mapload)
		. = ..()
		soulsearch()
	proc/soulsearch()
		var/location = loc
		notify_ghosts("The Soul Seeker is active at [location]! Click on it to be reborn!")
		addtimer(CALLBACK(src, .proc/soulsearch), 5 MINUTES)
	attack_ghost(atom/user)
		. = ..()
		activate(user)
	proc/activate(atom/user)
		var/ask = tgui_alert(user, "Become reborn?? (Warning, You can no longer be revived, and you will have forgotten the round!)", "Confirm", list("Yes","No"))
		playsound(src, 'sound/machines/microwave/microwave-end.ogg', 100, FALSE)
		if(ask == "Yes")
			become_reborn(user)
	proc/become_reborn(mob/dead/observer/user)
		var/mob/living/carbon/human/reborn = new /mob/living/carbon/human(src)
		user?.client?.prefs?.safe_transfer_prefs_to(reborn)
		reborn.dna.update_dna_identity()
		reborn.ckey = user.key
		addtimer(CALLBACK(src, .proc/consequences, reborn), 5 SECONDS)
		open_machine()
		dump_inventory_contents()
	proc/consequences(mob/living/carbon/human/reborn)
		reborn.spill_organs(FALSE, FALSE, FALSE)
		for(var/X in reborn.bodyparts)
			var/obj/item/bodypart/BP = X
			BP.drop_limb()
			BP.throw_at(get_edge_target_turf(src,pick(GLOB.alldirs)),rand(1,3),5)



/datum/design/board/soul_seeker
	name = "Machine Design (Soul Seeker)"
	desc = "The circuit board for a Soul Seeker."
	id = "soul_seeker"
	build_path = /obj/item/circuitboard/machine/soul_seeker
	category = list("Medical Machinery")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/obj/item/circuitboard/machine/soul_seeker
	name = "Soul Seeker (Machine Board)"
	greyscale_colors = CIRCUIT_COLOR_MEDICAL
	build_path = /obj/machinery/soul_seeker
	req_components = list(/obj/item/stock_parts/micro_laser = 1)

