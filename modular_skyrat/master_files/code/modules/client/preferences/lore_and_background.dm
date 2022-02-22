//Education Rates
#define BASE_PAY_RATE 1
#define RATE_1_REDUCTION 0.25
#define RATE_2_REDUCTION 0.15
#define RATE_3_REDUCTION 0
#define NEW_HIRE_RATE 0.25
#define ERROR_RATE 0.35
//Location Based Rates
#define EARTH 0.05
#define LUNA 0
#define MARS 0.10
//Faction Based Rates
#define NANOTRASEN 0
#define SOLGOV 0.02
#define TAU_CETI_SCHOOL -0.1
#define TERRAGOV 0.03
#define STATELESS 0.25
//Elses
#define UNSET_RATE 0

//Educational Code
/datum/preference/choiced/education
	savefile_key = "feature_education"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
/* 	var/base_rate = 1
	var/actual_payout
	var/error_rate = 0.25
	var/new_hire_rate = 0.25
	var/rate_1_reduction = 0.25
	var/rate_2_reduction = 0.15
	var/rate_3_reduction = 0 */

	var/possible_options_education = list(
		"Trainee",
		"Student",
		"Uneducated",
		"Underemployed",
		"Vocational",
		"Post-Secondary",
		"Unionized")

/datum/preference/choiced/education/is_accessible(datum/preferences/preferences)
	var/passed_initial_check = ..(preferences)
	return (passed_initial_check)

/datum/preference/choiced/education/init_possible_values()
	return possible_options_education

/datum/preference/choiced/education/apply_to_human(mob/living/carbon/human/target, value)
	switch(value)
		if(TRUE && "Uneducated" || "Underemployed")
			message_admins("[target],[value],[target.payday_modifier]\n")
			target.payday_modifier -= RATE_1_REDUCTION
			message_admins("[target],[value],[target.payday_modifier]\n")

		if(TRUE && "Vocational" || "Trainee" || "Student")
			message_admins("[target],[value],[target.payday_modifier]\n")
			target.payday_modifier -= RATE_2_REDUCTION
			message_admins("[target],[value],[target.payday_modifier]\n")

		if(TRUE && "Post-Secondary" || "Unionized")
			message_admins("[target],[value],[target.payday_modifier]\n")
			target.payday_modifier -= RATE_3_REDUCTION
			message_admins("[target],[value],[target.payday_modifier]\n")
		else //Failsafe for bad input. Non-listed selections new hire rate, no input is unset rate.
			message_admins("[target],[value],[target.payday_modifier]\n")
			target.payday_modifier -= value ? NEW_HIRE_RATE : UNSET_RATE
			message_admins("[target],[value],[target.payday_modifier]\n")

/datum/preference/choiced/education/create_default_value()
	return NEW_HIRE_RATE

//Faction Code
/datum/preference/choiced/faction
	savefile_key = "feature_faction"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	var/possible_options_faction = list(
		"Nanotrasen",
		"Solgov",
		"Tau Ceti",
		"TerraGov",
		"Stateless",
		"Free Trade Union",
		"Expeditionary Corps Organisation",
		"Gilgamesh Colonial Confederation",
		"Xynergy",
		"Hephaestus Industries",
		"Strategic Assault and Asset Retention Enterprises",
		"Deimos Advanced Information Systems",
		"Other"
		)

/datum/preference/choiced/faction/is_accessible(datum/preferences/preferences)
	var/passed_initial_check = ..(preferences)
	return (passed_initial_check)

/datum/preference/choiced/faction/init_possible_values()
	return possible_options_faction

/datum/preference/choiced/faction/apply_to_human(mob/living/carbon/human/target, value)
	switch(value)
		if(TRUE && "Nanotrasen")
			message_admins("[target],[value],[target.payday_modifier]\n")
			target.payday_modifier -= NANOTRASEN
			message_admins("[target],[value],[target.payday_modifier]\n")

		if(TRUE && "Solgov")
			message_admins("[target],[value],[target.payday_modifier]\n")
			target.payday_modifier -= SOLGOV
			message_admins("[target],[value],[target.payday_modifier]\n")

		if(TRUE && "Tau Ceti")
			message_admins("[target],[value],[target.payday_modifier]\n")
			target.payday_modifier -= TAU_CETI_SCHOOL
			message_admins("[target],[value],[target.payday_modifier]\n")

		if(TRUE && "TerraGov")
			message_admins("[target],[value],[target.payday_modifier]\n")
			target.payday_modifier -= TERRAGOV
			message_admins("[target],[value],[target.payday_modifier]\n")

		else //Failsafe for bad input.. Unset is stateless, undefined inputs = NANOTRASEN(no difference) .
			message_admins("[target],[value],[target.payday_modifier]\n")
			target.payday_modifier -= value ? NANOTRASEN : UNSET_RATE
			message_admins("[target],[value],[target.payday_modifier]\n")

/datum/preference/choiced/faction/create_default_value()
	return SOLGOV

//Faction Code
/datum/preference/choiced/homeworld
	savefile_key = "feature_homeworld"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	var/possible_options_homeworld = list(
		"Gaia",
		"Sol",
		"Ceti Epsilon",
		"Terra",
		"Stateless",
		"Other",
		)

/datum/preference/choiced/homeworld/is_accessible(datum/preferences/preferences)
	var/passed_initial_check = ..(preferences)
	return (passed_initial_check)

/datum/preference/choiced/homeworld/init_possible_values()
	return possible_options_homeworld

/datum/preference/choiced/homeworld/apply_to_human(mob/living/carbon/human/target, value)
	switch(value)
		if(TRUE && "Gaia")
			message_admins("[target],[value],[target.payday_modifier]\n")
			target.payday_modifier -= EARTH
			message_admins("[target],[value],[target.payday_modifier]\n")
		if(TRUE && "Sol")
			message_admins("[target],[value],[target.payday_modifier]\n")
			target.payday_modifier -= SOLGOV
			message_admins("[target],[value],[target.payday_modifier]\n")
		if(TRUE && "Ceti Epsilon")
			message_admins("[target],[value],[target.payday_modifier]\n")
			target.payday_modifier -= TAU_CETI_SCHOOL
			message_admins("[target],[value],[target.payday_modifier]\n")
		if(TRUE && "Terra")
			message_admins("[target],[value],[target.payday_modifier]\n")
			target.payday_modifier -= TERRAGOV
			message_admins("[target],[value],[target.payday_modifier]\n")
		else //Failsafe for bad input.. Unset is stateless
			message_admins("[target],[value],[target.payday_modifier]\n")
			target.payday_modifier -= value ? LUNA : UNSET_RATE
			message_admins("[target],[value],[target.payday_modifier]\n")

/datum/preference/choiced/homeworld/create_default_value()
	return EARTH


/mob/living/carbon/human
	var/payday_modifier = 1
