/obj/item/summon_beacon
	name = "summoner beacon"
	desc = "Summons a thing. Probably shouldn't use this one, though."
	icon = 'icons/obj/device.dmi'
	icon_state = "gangtool-blue"
	inhand_icon_state = "radio"
	w_class = WEIGHT_CLASS_SMALL

	/// How many uses the beacon has left
	var/uses = 1

	/// A list of allowed areas that the atom can be spawned in
	var/list/allowed_areas = list(
		/area,
	)

	/// A list of possible atoms available to spawn
	var/list/selectable_atoms = list(
		/obj/item/summon_beacon,
	)

	/// The currently selected atom, if any
	var/atom/selected_atom = null

	/// Descriptor of what area it should work in
	var/area_string = "any"

	/// If the supply pod should stay or not
	var/supply_pod_stay = FALSE

/obj/item/summon_beacon/examine()
	. = ..()
	. += span_warning("Caution: Only works in [area_string].")
	. += span_notice("Currently selected: [selected_atom ? initial(selected_atom.name) : "None"].")

/obj/item/summon_beacon/attack_self(mob/user)
	if(!can_use_beacon(user))
		return
	if(length(selectable_atoms) == 1)
		selected_atom = selectable_atoms[1]
		return
	show_options(user)

/obj/item/summon_beacon/proc/can_use_beacon(mob/living/user)
	if(user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
		return TRUE
	else
		playsound(src, 'sound/machines/buzz-sigh.ogg', 40, TRUE)
		return FALSE

/obj/item/summon_beacon/proc/generate_display_names()
	var/list/atom_list = list()
	for(var/atom/iterated_atom as anything in selectable_atoms)
		atom_list[initial(iterated_atom.name)] = iterated_atom
	return atom_list

/obj/item/summon_beacon/proc/show_options(mob/user)
	var/list/radial_build = get_available_options()
	if(!radial_build)
		return

	selected_atom = show_radial_menu(user, src, radial_build, radius = 40, tooltips = TRUE)

/obj/item/summon_beacon/proc/get_available_options()
	var/list/options = list()
	for(var/iterating_choice in selectable_atoms)
		var/obj/our_object = iterating_choice
		var/datum/radial_menu_choice/option = new
		option.image = image(icon = initial(our_object.icon), icon_state = initial(our_object.icon_state))
		option.info = span_boldnotice("[initial(our_object.desc)]")

		options[our_object] = option

	sort_list(options)

	return options

/obj/item/summon_beacon/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(!selected_atom)
		balloon_alert(user, "no choice selected!")
		return
	var/turf/target_turf = get_turf(target)
	var/area/target_area = get_area(target)
	if(!target_turf || !target_area || !is_type_in_list(target_area, allowed_areas))
		balloon_alert(user, "can't call here!")
		return

	var/confirmed = tgui_alert(user, "Are you sure you want to call [initial(selected_atom.name)] here?", "Confirmation", list("Yes", "No"))
	if(confirmed != "Yes")
		return

	podspawn(list(
		"target" = get_turf(target),
		"path" = supply_pod_stay ? /obj/structure/closet/supplypod/podspawn/no_return : /obj/structure/closet/supplypod/podspawn,
		"style" = STYLE_CENTCOM,
		"spawn" = selected_atom,
	))

	if(ishuman(user))
		var/mob/living/carbon/human/human_user = user
		if(istype(human_user.ears, /obj/item/radio/headset))
			to_chat(user, span_notice("You hear something crackle in your ears for a moment before a voice speaks. \
				\"Please stand by for a message from Central Command.  Message as follows: \
				[span_bold("Request received. Pod inbound, please stand back from the landing site.")] \
				Message ends.\""))

	uses--
	if(!uses)
		qdel(src)
	else
		balloon_alert(user, "[uses] use[uses > 1 ? "s" : ""] left!")

// Misc stuff here

/obj/structure/closet/supplypod/podspawn/no_return
	bluespace = FALSE

/obj/item/storage/box/gas_miner_beacons
	name = "box of gas miner delivery beacons"
	desc = "Contains two beacons for delivery of atmospheric gas miners."

/obj/item/storage/box/gas_miner_beacons/PopulateContents()
	new /obj/item/summon_beacon/gas_miner(src)
	new /obj/item/summon_beacon/gas_miner(src)


// Actual beacons start here

/obj/item/summon_beacon/gas_miner
	name = "gas miner beacon"
	desc = "Once a gas miner type is selected, delivers a gas miner to the target location."

	allowed_areas = list(
		/area/station/engineering/atmos,
		/area/station/engineering/atmospherics_engine,
	)

	selectable_atoms = list(
		/obj/machinery/atmospherics/miner/carbon_dioxide,
		/obj/machinery/atmospherics/miner/n2o,
		/obj/machinery/atmospherics/miner/nitrogen,
		/obj/machinery/atmospherics/miner/oxygen,
		/obj/machinery/atmospherics/miner/plasma,
	)

	area_string = "atmospherics"
	supply_pod_stay = TRUE

/obj/item/summon_beacon/command_drobe
	name = "command outfitting beacon"
	desc = "Delivers a command outfitting station to the target location."

	allowed_areas = list(
		/area/station/command/bridge,
		/area/station/command/heads_quarters/captain,
		/area/station/command/heads_quarters/hop,
	)

	selectable_atoms = list(
		/obj/machinery/vending/access/command,
	)

	area_string = "the bridge"

/obj/item/summon_beacon/borgi
	name = "E-N beacon"
	desc = "Delivers a lovable borgi to the target location."

	allowed_areas = list(
		/area/station/science/robotics,
	)

	selectable_atoms = list(
		/mob/living/simple_animal/pet/dog/corgi/borgi,
	)

	area_string = "robotics"

/obj/item/summon_beacon/poppy
	name = "engineering possum beacon"
	desc = "Delivers the engineering possum, Poppy, to the target location."

	allowed_areas = list(
		/area/station/engineering,
	)

	selectable_atoms = list(
		/mob/living/simple_animal/pet/poppy,
	)

	area_string = "engineering"

/obj/item/summon_beacon/bumbles
	name = "Bumbles beacon"
	desc = "Delivers hydreponics' bee, Bumbles, to the target location."

	allowed_areas = list(
		/area/station/service/hydroponics,
	)

	selectable_atoms = list(
		/mob/living/simple_animal/pet/bumbles,
	)

	area_string = "hydroponics"

/obj/item/summon_beacon/markus
	name = "cargo corgi beacon"
	desc = "Delivers Markus, the mascot of cargo, to the target location."

	allowed_areas = list(
		/area/station/cargo,
	)

	selectable_atoms = list(
		/mob/living/simple_animal/pet/dog/markus,
	)

	area_string = "cargo"

/obj/item/summon_beacon/secmed
	name = "security medic locker beacon"
	desc = "Delivers a security medic's locker to the target location."

	allowed_areas = list(
		/area/station/security/medical,
	)

	selectable_atoms = list(
		/obj/structure/closet/secure_closet/security_medic,
	)

	area_string = "the medical ward of security"

/obj/item/summon_beacon/vanguard
	name = "vanguard operatives supply beacon"
	desc = "Used to request your job supplies, use in hand to do so!"

	allowed_areas = list(
		/area/awaymission,
		/area/station/command/gateway,
	)

	selectable_atoms = list(
		/obj/structure/closet/crate/secure/exp_corps/marksman,
		/obj/structure/closet/crate/secure/exp_corps/pointman,
		/obj/structure/closet/crate/secure/exp_corps/field_medic,
		/obj/structure/closet/crate/secure/exp_corps/combat_tech,
	)

	area_string = "the gateway chamber"
