/datum/round_event_control/kobold
	name = "Pack of Kobolds"
	typepath = /datum/round_event/ghost_role/kobold
	weight = 8
	max_occurrences = 1

/datum/round_event/ghost_role/kobold
	minimum_required = 1
	role_name = "Kobold Invader"
	fakeable = FALSE

/datum/round_event/ghost_role/kobold/spawn_role()
	var/list/candidates = get_candidates(ROLE_KOBOLD)
	if(!length(candidates))
		return NOT_ENOUGH_PLAYERS

	var/mob/dead/selected = pick_n_take(candidates)

	var/list/spawn_locs = list()
	for(var/obj/effect/kobbystart in GLOB.landmarks_list)
		spawn_locs += kobbystart.loc
	if(!length(spawn_locs))
		return MAP_ERROR

	var/mob/living/carbon/human/kobold = new(pick(spawn_locs))
	kobold.dna.update_dna_identity()
	kobold.set_species(/datum/species/lizard/kobold, TRUE)
	kobold.randomize_human_appearance(~RANDOMIZE_SPECIES)
	var/datum/mind/mind = new /datum/mind(selected.key)
	mind.set_assigned_role(SSjob.GetJobType(/datum/job/kobold))
	mind.special_role = ROLE_KOBOLD
	mind.active = TRUE
	mind.transfer_to(kobold)
	mind.add_antag_datum(/datum/antagonist/kobold)

	message_admins("[ADMIN_LOOKUPFLW(kobold)] has been made into [src] by an event.")
	log_game("[key_name(kobold)] was spawned as a [src] by an event.")
	spawned_mobs += kobold
	return SUCCESSFUL_SPAWN
