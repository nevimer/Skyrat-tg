/datum/preference/choiced/payday
	savefile_key = "feature_payday"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	var/POOR = 0.50
	var/NORMAL = 0.75
	var/RICH = 1

	var/possible_options = list(0.50, 0.75, 1)

/datum/preference/choiced/payday/is_accessible(datum/preferences/preferences)
	var/passed_initial_check = ..(preferences)
	return (passed_initial_check)

/datum/preference/choiced/payday/init_possible_values()
	return possible_options

/datum/preference/choiced/payday/apply_to_human(mob/living/carbon/human/target, value)
	target.payday_modifier = value

/datum/preference/choiced/payday/create_default_value()
	return NORMAL

/mob/living/carbon/human
	var/payday_modifier = 1
