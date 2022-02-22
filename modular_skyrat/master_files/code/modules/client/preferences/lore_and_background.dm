//Education Rates
#define BASE_PAY_RATE 1
#define RATE_1_REDUCTION 0.60
#define RATE_2_REDUCTION 0.1
#define RATE_3_REDUCTION 0
#define NEW_HIRE_RATE 0.25
#define ERROR_RATE 0.35


#define UNSET_RATE 0
#define DEBTSLAVE "Debtslave"
#define MIGRANT "Migrant Worker"
#define LOST "Slipped through the cracks"
#define SLAVE "Indentured Servant"
#define NORMAL "Regular Employee"

#define OLD_MONEY "Old Money"
#define PRODIGY "Prodigy"
#define C_LIST "C-List Celebrity"
#define FAVORED "Nanotrasen Favored Employee"
//Educational Code
/datum/preference/choiced/education
	savefile_key = "feature_education"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL


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
		if(TRUE && "Uneducated", "Underemployed")
			message_admins("[target],[value],[target.payday_modifier]\n")
			if(value == "Uneducated")
				ADD_TRAIT(target, TRAIT_DUMB, INNATE_TRAIT) // placeholder
			target.payday_modifier -= RATE_1_REDUCTION
			message_admins("[target],[value],[target.payday_modifier]\n")

		if(TRUE && "Vocational", "Trainee", "Student")
			message_admins("[target],[value],[target.payday_modifier]\n")
			target.payday_modifier -= RATE_2_REDUCTION
			message_admins("[target],[value],[target.payday_modifier]\n")

		if(TRUE && "Post-Secondary", "Unionized")
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
/datum/preference/choiced/origin
	savefile_key = "feature_origin"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	var/possible_options_origin = list(
		DEBTSLAVE,
		MIGRANT,
		LOST,
		SLAVE,
		NORMAL
		)

/datum/preference/choiced/origin/is_accessible(datum/preferences/preferences)
	var/passed_initial_check = ..(preferences)
	return (passed_initial_check)

/datum/preference/choiced/origin/init_possible_values()
	return possible_options_origin

/datum/preference/choiced/origin/apply_to_human(mob/living/carbon/human/target, value)
	switch(value)
		if(TRUE && NORMAL)
			message_admins("[target],[value],[target.payday_modifier]\n")
			target.payday_modifier -= 0
			message_admins("[target],[value],[target.payday_modifier]\n")

		if(TRUE && MIGRANT)
			message_admins("[target],[value],[target.payday_modifier]\n")
			target.payday_modifier -= RATE_2_REDUCTION // Todo, trait here.
			message_admins("[target],[value],[target.payday_modifier]\n")

		if(TRUE && LOST)
			message_admins("[target],[value],[target.payday_modifier]\n")
			target.payday_modifier = 0 // Todo, trait here.
			message_admins("[target],[value],[target.payday_modifier]\n")

		if(TRUE && SLAVE, DEBTSLAVE)
			message_admins("[target],[value],[target.payday_modifier]\n")
			target.payday_modifier = 0 // Todo, trait here.
			message_admins("[target],[value],[target.payday_modifier]\n")

		else //Failsafe for bad input.. Unset is stateless, undefined inputs = NANOTRASEN(no difference) .
			message_admins("[target],[value],[target.payday_modifier]\n")
			target.payday_modifier -= value ? NEW_HIRE_RATE : UNSET_RATE
			message_admins("[target],[value],[target.payday_modifier]\n")

/datum/preference/choiced/origin/create_default_value()
	return NORMAL

//Faction Code
/datum/preference/choiced/social_status
	savefile_key = "feature_social_status"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	var/possible_options_social_status = list(
		OLD_MONEY,
		C_LIST,
		PRODIGY,
		FAVORED,
		NORMAL
		)

/datum/preference/choiced/social_status/is_accessible(datum/preferences/preferences)
	var/passed_initial_check = ..(preferences)
	return (passed_initial_check)

/datum/preference/choiced/social_status/init_possible_values()
	return possible_options_social_status

/datum/preference/choiced/social_status/apply_to_human(mob/living/carbon/human/target, value)
	switch(value)
		if(TRUE && NORMAL)
			message_admins("[target],[value],[target.payday_modifier]\n")
			target.payday_modifier -= RATE_3_REDUCTION
			message_admins("[target],[value],[target.payday_modifier]\n")
		if(TRUE && C_LIST)
			message_admins("[target],[value],[target.payday_modifier]\n")
			target.payday_modifier -= RATE_3_REDUCTION // Todo, trait here.
			message_admins("[target],[value],[target.payday_modifier]\n")
		if(TRUE && PRODIGY)
			message_admins("[target],[value],[target.payday_modifier]\n")
			target.payday_modifier -= RATE_3_REDUCTION // Todo, trait here.
			message_admins("[target],[value],[target.payday_modifier]\n")
		if(TRUE && FAVORED)
			message_admins("[target],[value],[target.payday_modifier]\n")
			target.payday_modifier -= RATE_3_REDUCTION // Todo, trait here.
			message_admins("[target],[value],[target.payday_modifier]\n")
		else //Failsafe for bad input.. Unset is stateless
			message_admins("[target],[value],[target.payday_modifier]\n")
			target.payday_modifier -= value ? RATE_3_REDUCTION : UNSET_RATE
			message_admins("[target],[value],[target.payday_modifier]\n")

/datum/preference/choiced/social_status/create_default_value()
	return NORMAL


/mob/living/carbon/human
	var/payday_modifier = 1
