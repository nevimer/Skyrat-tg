#define COMSIG_CARBON_HEART_UPDATE "heart_update"

/mob/living/carbon
	var/lastpainmessage
	var/falling_apart = FALSE
	var/injuries
	var/synth_functions
	var/obj/item/organ/internal/heart/robot_ipc/my_heart // Reference to our heart, for quick lookups
/mob/living/carbon/set_species(datum/species/mrace, icon_update = TRUE, pref_load = FALSE, list/override_features, list/override_mutantparts, list/override_markings, retain_features = FALSE, retain_mutantparts = FALSE)
	. = ..()
	if(mob_biotypes & MOB_ROBOTIC || is_type_in_list(mrace, typesof(/datum/species/robotic)))
		INVOKE_ASYNC(src, .proc/synth_init)

/mob/living/carbon/proc/synth_init()
		maxHealth = 800
		health = 600
		my_heart = getorganslot(ORGAN_SLOT_HEART)
		synth_functions = TRUE
		RegisterSignal(src, COMSIG_CARBON_HEART_UPDATE, .proc/handle_damage)
		RegisterSignal(src, COMSIG_CARBON_HEALTH_UPDATE, .proc/handle_damage)
		handle_damage()

/mob/living/carbon/proc/handle_damage()
	SIGNAL_HANDLER
	my_heart = getorganslot(ORGAN_SLOT_HEART)
	injuries = calc_injuries()
//		var/pain_score = injuries + length(all_wounds) // old, backup and sketchy
	calc_pain()
	if(stat == DEAD) // If we die, we ded. Stop here. Make us look dead.
		my_heart.flow_rate = 0 // Impedance
		update_health_hud()
		return
	else if(!falling_apart)
		my_heart.flow_rate = clamp(rand(BASE_FLOW_RATE, BASE_FLOW_RATE_UPPER) + calc_pain(), 0, FLOW_RATE_ARREST) // Normal Flow tasks
	falling_apart ? shock_dying(my_heart.flow_rate) : shock_helper(my_heart.flow_rate) // Handling thresholds, going into our shock.

	update_health_hud()

/mob/living/carbon/proc/calc_pain()
	var/pain_score = 1
	for(var/i in all_wounds)
		var/datum/wound/iterwound = i
		if(iterwound.severity == WOUND_SEVERITY_SEVERE || WOUND_SEVERITY_CRITICAL || WOUND_SEVERITY_LOSS)
			pain_score += SHOCK_STAGE_MAJOR
		if(iterwound.severity == WOUND_SEVERITY_MODERATE || WOUND_SEVERITY_TRIVIAL)
			pain_score += SHOCK_STAGE_MINOR

	pain_score += getBruteLoss() + getFireLoss() + getToxLoss() + getOxyLoss() + getStaminaLoss() / DAMAGE_TO_PAIN_DIVISION_FACTOR
	return pain_score

/mob/living/carbon/proc/calc_injuries()
	var/injuries
	for(var/i in all_wounds)
		injuries++
	return injuries

/mob/living/carbon/proc/shock_dying(flow_rate)
	if(!falling_apart || stat == DEAD)
		return
	if(can_leave_shock(flow_rate) && stat != DEAD)
		falling_apart = FALSE
		pre_stat()
		to_chat(src, span_hypnophrase("You body tingles painfully as your nerves come back...")) // Like that feeling you get when your nerves are pressurized IRL
	else
		current_pain_message_helper("Shock")
		losebreath += 0.1 // Let's speed this up if we're actively taking damage still
	flow_rate = clamp(flow_rate - losebreath, FLOW_RATE_DEAD, FLOW_RATE_ARREST) // Double negative when in crit?

	if(flow_rate <= 0 && getOrganLoss(ORGAN_SLOT_BRAIN) >= BRAIN_DAMAGE_DEATH) // Let us die once!
		adjustOrganLoss(ORGAN_SLOT_BRAIN, (injuries ? (losebreath + (injuries / 2)) : losebreath))


/mob/living/carbon/proc/can_leave_shock(last_bpm)
	var/truepain = calc_pain()
	if(truepain <= 100) // When our pain is below a certain threshold, we're free to leave shock. Like 4 minor wounds, 3 major as of writing.
		return TRUE
	return FALSE

/mob/living/carbon/proc/resetpainmsg()
	lastpainmessage = null // refactor this lmao

/mob/living/carbon/proc/current_pain_message_helper(current_pain)
	if(lastpainmessage)
		return
	lastpainmessage = TRUE
	addtimer(CALLBACK(src, .proc/resetpainmsg), 45 SECONDS) // *sweatdrops
	var/list/close2death = list("a human", "a moth", "a felinid", "a lizard", "a particularly resilient slime", "a syndicate agent", "a clown", "a mime", "a mortal foe", "an innocent bystander")

	switch(current_pain)
		if("Shock")
			to_chat(src, span_resonate("You feel your body shutting down..."))
		if("Minor")
			to_chat(src, span_resonate("I could use some painkillers right about now..."))
		if("Moderate")
			to_chat(src, span_resonate("It hurts so much!"))
		if("Major")
			to_chat(src, span_resonate("Make the pain stop!"))
		if("Severe")
			to_chat(src, span_resonate("Please! End the pain!"))
		if("Soft-crit")
			var/dream = span_italics(". . . You think about . . . ") + span_hypnophrase("[pick(close2death)]")
			to_chat(src, dream)
		if("Dying")
			to_chat(src, span_unconscious(pick("Where am I?", "What's going on?")))

/mob/living/carbon/proc/shock_helper(flow_rate)
	SIGNAL_HANDLER
	if(stat == DEAD)
		return
	switch(flow_rate)
		if(FLOW_RATE_ARREST)
			if(stat != HARD_CRIT || stat != SOFT_CRIT && !HAS_TRAIT(src, TRAIT_NOSOFTCRIT))
				pre_stat()
				to_chat(src, "shock_helper made us [SOFT_CRIT]")
				falling_apart = TRUE
//				shock_dying(flow_rate, pulsetimer)
				current_pain_message_helper("Soft-crit")
			if(calc_pain() > hardcrit_threshold || stat != HARD_CRIT && !HAS_TRAIT(src, TRAIT_NOHARDCRIT)) // testing..
				pre_stat()
				to_chat(src, "shock_helper made us [HARD_CRIT]")
				falling_apart = TRUE
				current_pain_message_helper("Dying")


		if(180 to FLOW_RATE_ARREST - 1)
			current_pain_message_helper("Severe")
//			set_stat(CONSCIOUS)
		if(120 to 140)
			current_pain_message_helper("Minor")
//			set_stat(CONSCIOUS)
		if(140 to 160)
			current_pain_message_helper("Moderate")
//			set_stat(CONSCIOUS)
		if(160 to 180)
			current_pain_message_helper("Major")
//			set_stat(CONSCIOUS)

//mob/living/carbon/updatehealth()
//	. = ..()
//	shock_helper()
//		flow_control()
/mob/living/carbon/update_health_hud(shown_health_amount)
	if(!synth_functions)
		. = ..()
	else
		if(!client || !hud_used)
			return
		var/atom/movable/screen/healths/pulse = hud_used.healths
		var/switch_flow_rate = my_heart?.flow_rate
		pulse.maptext = MAPTEXT("[falling_apart ? ":(" : ((switch_flow_rate <= 130) ? ":)" : ":|")]")
		if(hud_used.healths) // MOVED TO MODULAR
			. = 1
			if(shown_health_amount == null)
				shown_health_amount = health
			switch(switch_flow_rate)
				if(60 to 90)
					hud_used.healths.icon_state = "health1"
				if(90 to 110)
					hud_used.healths.icon_state = "health2"
				if(110 to 130)
					hud_used.healths.icon_state = "health3"
				if(130 to 200)
					hud_used.healths.icon_state = "health4"
				if(200 to 299)
					hud_used.healths.icon_state = "health5"
			if(falling_apart && stat != DEAD)
				hud_used.healths.icon_state = "health6"
			if(stat == DEAD)
				hud_used.healths.icon_state = "health7"
/mob/living/carbon/update_damage_hud()

	. = ..()
	if(synth_functions)
		var/switch_flow_rate = my_heart?.flow_rate
		if(switch_flow_rate)
			var/severity = 0
			switch(switch_flow_rate)
				if(100 to 120)
					severity = 1
				if(120 to 140)
					severity = 2
				if(140 to 160)
					severity = 3
				if(160 to 180)
					severity = 4
				if(180 to 240)
					severity = 5
				if(240 to INFINITY)
					severity = 6
			overlay_fullscreen("brute", /atom/movable/screen/fullscreen/brute, severity)
		else
			clear_fullscreen("brute")

/*
/obj/structure/table/optable
	var/beepvalid
/obj/structure/table/optable/set_patient(mob/living/carbon/human/patient)
	if(patient)
		addtimer(CALLBACK(src, .proc/ekg, patient), 2 SECONDS)
/obj/structure/table/optable/patient_deleted(datum/source)
	patient = null
/obj/structure/table/optable/proc/ekg(mob/living/carbon/human/patient)

	if(!beepvalid || !patient)
		return
	if(patient?.falling_apart && DT_PROB(50, 3))
		patient.flow_rate ? say("Patient critical! Pulse rate at [patient.flow_rate] BPM, vital signs fading!") : say("Excessive heartbeat! Possible Shock Detected! Pulse rate at [patient.flow_rate] BPM.")
	switch(patient?.flow_rate)
		if(0 to 60 && !patient?.falling_apart)
			playsound(src, 'modular_skyrat/sound/effects/flatline.ogg', 20)
		if(60 to 90 && !patient?.falling_apart)
			playsound(src, 'modular_skyrat/sound/effects/quiet_beep.ogg', 40)
		if(90 to 170 && !patient?.falling_apart)
			playsound(src, 'modular_skyrat/sound/effects/quiet_double_beep.ogg', 40)
		else
			patient.flow_rate ? playsound(src, ('modular_skyrat/sound/effects/ekg_alert.ogg')) : playsound(src, ('modular_skyrat/sound/effects/flatline.ogg'))
	if(beepvalid)
		addtimer(CALLBACK(src, .proc/ekg, patient), 2 SECONDS) // SFX length
		if(patient.stat != DEAD)
			SEND_SIGNAL(patient, COMSIG_SHOCK_UPDATE)

/obj/structure/table/optable/proc/chill_out(mob/living/target)
	var/freq = rand(24750, 26550)
	playsound(src, 'sound/effects/spray.ogg', 5, TRUE, 2, frequency = freq)
	target.apply_status_effect(/datum/status_effect/grouped/stasis, STASIS_MACHINE_EFFECT)
	ADD_TRAIT(target, TRAIT_TUMOR_SUPPRESSED, TRAIT_GENERIC)
	target.extinguish_mob()

/obj/structure/table/optable/proc/thaw_them(mob/living/target)
	target.remove_status_effect(/datum/status_effect/grouped/stasis, STASIS_MACHINE_EFFECT)
	REMOVE_TRAIT(target, TRAIT_TUMOR_SUPPRESSED, TRAIT_GENERIC)

/obj/structure/table/optable/post_buckle_mob(mob/living/L)
	beepvalid = TRUE
	set_patient(L)
	chill_out(L)

/obj/structure/table/optable/post_unbuckle_mob(mob/living/L)
	beepvalid = FALSE
	set_patient(null)
	thaw_them(L) */

