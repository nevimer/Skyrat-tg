/datum/dynamic_ruleset/midround/from_ghosts/kobold
	name = "Pack of Kobolds"
	midround_ruleset_style = MIDROUND_RULESET_STYLE_LIGHT
	antag_datum = /datum/antagonist/kobold
	antag_flag = ROLE_KOBOLD
	antag_flag_override = ROLE_KOBOLD
	required_candidates = 1
	weight = 2
	cost = 3
	/// valid places to spawn
	var/list/spawn_locs = list()

/datum/dynamic_ruleset/midround/from_ghosts/kobold/ready(forced = FALSE)
	if(prob(33))
		required_candidates++
	if (required_candidates > (length(dead_players) + length(list_observers)))
		return FALSE
	for(var/obj/effect/landmark/start/assistant/kbobold in GLOB.landmarks_list)
		spawn_locs += kbobold.loc
	if(!length(spawn_locs))
		log_admin("Cannot accept Kobold ruleset. Couldn't find any blob spawn points.")
		message_admins("Cannot accept Kobold ruleset. Couldn't find any blob spawn points.")
		return FALSE
	return ..()


/datum/dynamic_ruleset/midround/from_ghosts/kobold/generate_ruleset_body(mob/applicant)
	var/mob/living/carbon/human/kobold = new(pick(spawn_locs))
	kobold.dna.remove_all_mutations()
	kobold.randomize_human_appearance(~RANDOMIZE_SPECIES)
	kobold.dna.update_dna_identity()
	return kobold

/datum/dynamic_ruleset/midround/from_ghosts/kobold/finish_setup(mob/new_character, index)
	if(!usr.mind)
		usr.mind = new /datum/mind(usr.key)
	usr.mind.transfer_to(new_character)
	new_character.ckey = usr.ckey
	..()
	new_character.mind.set_assigned_role(SSjob.GetJobType(/datum/job/kobold))
	new_character.mind.special_role = ROLE_KOBOLD
	new_character.mind.active = TRUE




/datum/job/kobold
	title = ROLE_KOBOLD



/datum/antagonist/kobold
	name = "Kobold"
	antagpanel_category = "Kobold"
	preview_outfit = /datum/outfit/kobold_preview
	job_rank = ROLE_KOBOLD
	antag_hud_name = "kobold"
	antag_moodlet = /datum/mood_event/focused
	show_to_ghosts = TRUE
	suicide_cry = "weh??"
	var/kobold_outfit = /datum/outfit/kobold

/datum/antagonist/kobold/proc/equip_guy()
	if(!ishuman(owner.current))
		return
	var/mob/living/carbon/human/person = owner.current
	person.equipOutfit(kobold_outfit)
	return TRUE

/datum/antagonist/kobold/on_gain()
	var/datum/objective/traitor_objectives/kobby = new
	kobby.owner = owner
	kobby.explanation_text = "You are a Kobold! Go create mischief, but don't overdo it! After all, you ARE a visitor."
	objectives += kobby
	. = ..()
	equip_guy()
