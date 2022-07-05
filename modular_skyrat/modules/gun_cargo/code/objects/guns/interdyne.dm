/obj/item/gun/ballistic/automatic/pistol/firefly/smartdart
	name = "\improper I-94 'Honeybee'"
	desc = "A 9mm sidearm made by Armadyne and modified by Interdyne, it features a slightly modified paint job and sports a SmartDart underbarrel attachment."
	company_flag = COMPANY_INTERDYNE
	icon = 'modular_skyrat/modules/gun_cargo/icons/honeybee.dmi'
	icon_state = "honeybee"
	company_flag = COMPANY_INTERDYNE
	var/obj/item/gun/syringe/smartdart/underbarrel/underbarrel

/obj/item/gun/ballistic/automatic/pistol/firefly/smartdart/Initialize()
	. = ..()
	underbarrel = new(src)
	update_appearance()

/obj/item/gun/ballistic/automatic/pistol/firefly/smartdart/afterattack_secondary(atom/target, mob/living/user, flag, params)
	underbarrel.afterattack(target, user, flag, params)
	return SECONDARY_ATTACK_CONTINUE_CHAIN

/obj/item/gun/ballistic/automatic/pistol/firefly/smartdart/attack_hand_secondary(mob/user, list/modifiers)
	underbarrel.attack_self(user, modifiers)
	return SECONDARY_ATTACK_CONTINUE_CHAIN

/obj/item/gun/ballistic/automatic/pistol/firefly/smartdart/attackby(obj/item/attacking_item, mob/user, params)
	if(istype(attacking_item, /obj/item/reagent_containers/syringe/smartdart))
		underbarrel.attackby(attacking_item, user, params)
	else
		..()

/obj/item/gun/ballistic/automatic/pistol/firefly/smartdart/examine(mob/user)
	. = ..()
	. += "<br>You can fire the underbarrel device with [span_bold("right click")]."
	. += "<br>You can unload the underbarrel device by [span_bold("right clicking with an empty hand")]."

	for(var/obj/item/reagent_containers/syringe/dart as anything in underbarrel.syringes)
		. += "There is a [dart] loaded."

/obj/item/gun/syringe/smartdart/underbarrel
	name = "SmartDart underbarrel device"
	desc = "An underbarrel attachment for a pistol that fits a SmartDart."
	has_gun_safety = FALSE
