/datum/language_holder/kobold
	understood_languages = list(/datum/language/draconic = list(LANGUAGE_ATOM))
	spoken_languages = list(/datum/language/draconic = list(LANGUAGE_ATOM))

/* /datum/sprite_accessory/tails/kobold/default
	name = "Kobold"
	icon_state = "kobold"
	icon = 'icons/mob/species/mutant_bodyparts.dmi' */


/datum/species/lizard/kobold
	name = "Kobold"
	id = "kobold"
	say_mod = "shrills"
	external_organs = list(
		/obj/item/organ/external/horns = "Short",
		/obj/item/organ/external/frills = "None",
		/obj/item/organ/external/snout = "Round",
		/obj/item/organ/external/spines = "None",
		/obj/item/organ/external/tail/lizard/kobold = "Smooth",
	)
	mutant_organs = list(/obj/item/organ/external/tail/lizard/kobold)
	mutant_bodyparts = list("legs" = DIGITIGRADE_LEGS)
	skinned_type = /obj/item/stack/sheet/animalhide/lizard
	meat = /obj/item/food/meat/slab/human/mutant/lizard
	knife_butcher_results = list(/obj/item/food/meat/slab/human/mutant/lizard = 5, /obj/item/stack/sheet/animalhide/lizard = 1)
	species_traits = list(MUTCOLORS, HAS_FLESH, HAS_BONE, NO_UNDERWEAR, LIPS)

//	limbs_id = "kobold"
	bodypart_overrides = list(
		BODY_ZONE_L_ARM = /obj/item/bodypart/l_arm/lizard/kobold,
		BODY_ZONE_R_ARM = /obj/item/bodypart/r_arm/lizard/kobold,
		BODY_ZONE_HEAD = /obj/item/bodypart/head/lizard/kobold,
		BODY_ZONE_L_LEG = /obj/item/bodypart/l_leg/lizard/kobold,
		BODY_ZONE_R_LEG = /obj/item/bodypart/r_leg/lizard/kobold,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/lizard/kobold,)
	species_language_holder = /datum/language_holder/kobold
	attack_verb = "bite"
	attack_effect = ATTACK_EFFECT_BITE
/* /datum/species/lizard/kobold/random_name(gender,unique,lastname)
	var/randname = "kobold ([rand(1,999)])"
	return randname */

/datum/species/lizard/kobold/on_species_gain(mob/living/carbon/human/H, datum/species/old_species)
	. = ..()
	H.dna.current_body_size = 0.92

/datum/species/lizard/kobold/check_roundstart_eligible()
	return FALSE


/obj/item/organ/external/tail/lizard/kobold
	name = "kobold tail"
	desc = "A smaller version of a normal lizard tail. Somewhere, no doubt, a lizard hater feels cheated."
	color = "#116611"
//	tail_type = "Kobold"
//	icon_state = "severedkoboldtail"



/obj/item/bodypart/head/lizard/kobold
//	icon_greyscale = 'modular_skyrat/master_files/icons/mob/kobold_parts_greyscale.dmi'
//	limb_id = "kobold"
	is_dimorphic = FALSE

/obj/item/bodypart/chest/lizard/kobold
//	icon_greyscale = 'modular_skyrat/master_files/icons/mob/kobold_parts_greyscale.dmi'
//	limb_id = "kobold"
	is_dimorphic = TRUE

/obj/item/bodypart/l_arm/lizard/kobold
//	icon_greyscale = 'modular_skyrat/master_files/icons/mob/kobold_parts_greyscale.dmi'
//	limb_id = "kobold"

/obj/item/bodypart/r_arm/lizard/kobold
//	icon_greyscale = 'modular_skyrat/master_files/icons/mob/kobold_parts_greyscale.dmi'
//	limb_id = "kobold"

/obj/item/bodypart/l_leg/lizard/kobold
//	icon_greyscale = 'modular_skyrat/master_files/icons/mob/kobold_parts_greyscale.dmi'
//	limb_id = "kobold"

/obj/item/bodypart/r_leg/lizard/kobold
//	icon_greyscale = 'modular_skyrat/master_files/icons/mob/kobold_parts_greyscale.dmi'
//	limb_id = "kobold"
