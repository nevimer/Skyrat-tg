/datum/species/lizard
	mutant_bodyparts = list()
	external_organs = list()
	species_traits = list(
		MUTCOLORS,
		EYECOLOR,
		LIPS,
		HAS_FLESH,
		HAS_BONE,
		HAIR,
		FACEHAIR,
	)
	default_mutant_bodyparts = list(
		"tail" = ACC_RANDOM,
		"snout" = ACC_RANDOM,
		"spines" = ACC_RANDOM,
		"frills" = ACC_RANDOM,
		"horns" = ACC_RANDOM,
		"body_markings" = ACC_RANDOM,
		"legs" = "Digitigrade Legs",
		"taur" = "None",
		"wings" = "None",
	)
	learnable_languages = list(/datum/language/common, /datum/language/draconic)
	payday_modifier = 0.75

/datum/species/lizard/get_random_features()
	var/list/returned = MANDATORY_FEATURE_LIST
	var/main_color = "#[random_color()]"
	var/second_color
	var/third_color
	var/random = rand(1,3)
	switch(random)
		if(1) //First random case - all is the same
			second_color = main_color
			third_color = main_color
		if(2) //Second case, derrivatory shades, except there's no helpers for that and I dont feel like writing them
			second_color = main_color
			third_color = main_color
		if(3) //Third case, more randomisation
			second_color = "#[random_color()]"
			third_color = "#[random_color()]"
	returned["mcolor"] = main_color
	returned["mcolor2"] = second_color
	returned["mcolor3"] = third_color
	return returned

/datum/species/lizard/prepare_human_for_preview(mob/living/carbon/human/lizard, lizard_color = "#009999")
	lizard.dna.features["mcolor"] = lizard_color
	lizard.dna.species.mutant_bodyparts["tail"] = list(MUTANT_INDEX_NAME = "Light Tiger", MUTANT_INDEX_COLOR_LIST = list(lizard_color, lizard_color, lizard_color))
	lizard.dna.species.mutant_bodyparts["snout"] = list(MUTANT_INDEX_NAME = "Sharp + Light", MUTANT_INDEX_COLOR_LIST = list(lizard_color, lizard_color, lizard_color))
	lizard.dna.species.mutant_bodyparts["horns"] = list(MUTANT_INDEX_NAME = "Simple", MUTANT_INDEX_COLOR_LIST = list(lizard_color, lizard_color, lizard_color))
	lizard.dna.species.mutant_bodyparts["frills"] = list(MUTANT_INDEX_NAME = "Aquatic", MUTANT_INDEX_COLOR_LIST = list(lizard_color, lizard_color, lizard_color))
	lizard.dna.features["legs"] = "Normal Legs"
	lizard.update_mutant_bodyparts(TRUE)
	lizard.update_body(TRUE)

/datum/species/lizard/ashwalker
	species_traits = list(
		MUTCOLORS,
		EYECOLOR,
		LIPS,
		HAS_FLESH,
		HAS_BONE,
		NO_UNDERWEAR,
		HAIR,
		FACEHAIR
	)
	always_customizable = TRUE
	learnable_languages = list(/datum/language/ashtongue)

/datum/species/lizard/ashwalker/prepare_human_for_preview(mob/living/carbon/human/lizard, lizard_color = "#990000")
	. = ..(lizard, lizard_color)


/datum/species/lizard/silverscale/prepare_human_for_preview(mob/living/carbon/human/lizard, lizard_color = "#eeeeee")
	lizard.eye_color_left = "#0000a0"
	lizard.eye_color_right = "#0000a0"
	. = ..(lizard, lizard_color)
