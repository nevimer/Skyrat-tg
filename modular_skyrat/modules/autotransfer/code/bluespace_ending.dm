/datum/universal_state/bluespace_jump
	var/name = "Bluespace Jump"
	var/list/bluespaced = list()
	var/list/bluegoasts = list()
	var/list/affected_levels

/datum/universal_state/bluespace_jump/New(var/list/zlevels)
	for(var/z in SSmapping.levels_by_trait(ZTRAIT_STATION))
		z |= affected_levels

/datum/universal_state/bluespace_jump/proc/OnEnter()
//	var/space_zlevel = GLOB.using_map.get_empty_zlevel() //get a place for stragglers
	for(var/mob/living/M in GLOB.mob_list)
		if(M.z in affected_levels)
			apply_bluespaced(M)
	for(var/mob/goast in GLOB.current_observers_list)
		goast.mouse_opacity = 0	//can't let you click that Dave
		goast.alpha = 255
	set_observer_default_invisibility(0, span_warning("The round is over! You are now visible to the living."))

//	old_accessible_z_levels = GLOB.using_map.accessible_z_levels.Copy()
//	for(var/z in affected_levels)
//		GLOB.using_map.accessible_z_levels -= "[z]" //not accessible during the jump

/datum/universal_state/bluespace_jump/proc/OnExit()
	for(var/mob/M in bluespaced)
		if(!QDELETED(M))
			clear_bluespaced(M)

	bluespaced.Cut()

/datum/universal_state/bluespace_jump/proc/OnPlayerLatejoin(var/mob/living/M)
	if(M.z in affected_levels)
		apply_bluespaced(M)

/datum/universal_state/bluespace_jump/proc/OnTouchMapEdge(var/atom/A)
	if((A.z in affected_levels) && (A in bluespaced))
		if(ismob(A))
			to_chat(A,"<span class='warning'>You drift away into the shifting expanse, never to be seen again.</span>")
		qdel(A) //lost in bluespace
		return FALSE
	return TRUE

/datum/universal_state/bluespace_jump/proc/apply_bluespaced(var/mob/living/M)
	bluespaced += M
	if(M.client)
		to_chat(M,"<span class='notice'>You feel oddly light, and somewhat disoriented as everything around you shimmers and warps ever so slightly.</span>")
//		M.overlay_fullscreen("bluespace", /obj/screen/fullscreen/bluespace_overlay)
	bluegoasts += new/obj/effect/bluegoast/(get_turf(M),M)

/datum/universal_state/bluespace_jump/proc/clear_bluespaced(var/mob/living/M)
	if(M.client)
		to_chat(M,"<span class='notice'>You feel rooted in material world again.</span>")
//		M.clear_fullscreen("bluespace")
	for(var/mob/goast in GLOB.current_observers_list)
		goast.mouse_opacity = initial(goast.mouse_opacity)
		goast.alpha = initial(goast.alpha)
	for(var/G in bluegoasts)
		qdel(G)
	bluegoasts.Cut()

/obj/effect/bluegoast
	name = "bluespace echo"
	desc = "It's not going to punch you, is it?"
	var/mob/living/carbon/human/daddy
	anchored = TRUE
	var/reality = 0
	var/simulated = FALSE

/obj/effect/bluegoast/New(nloc, ndaddy)
	..(nloc)
	if(!ndaddy)
		qdel(src)
		return
	daddy = ndaddy
	src.dir = daddy.dir
	appearance = daddy.appearance
	addtimer(VARSET_CALLBACK(src, dir, daddy.dir), 1 SECONDS, TIMER_LOOP)
//	addtimer(VARSET_CALLBACK(src, locate(), (daddy.locate() + rand(-3,3))), 1 SECONDS, TIMER_LOOP)

/obj/effect/bluegoast/Destroy()
	daddy = null
	. = ..()

/obj/effect/bluegoast/proc/mirror(var/atom/movable/am, var/old_loc, var/new_loc)
	var/ndir = get_dir(new_loc,old_loc)
	appearance = daddy.appearance
	var/nloc = get_step(src, ndir)
	if(nloc)
		forceMove(nloc)
	if(nloc == new_loc)
		reality++
		if(reality > 5)
			to_chat(daddy, "<span class='notice'>Yep, it's certainly the other one. Your existance was a glitch, and it's finally being mended...</span>")
			blueswitch()
		else if(reality > 3)
			to_chat(daddy, "<span class='danger'>Something is definitely wrong. Why do you think YOU are the original?</span>")
		else
			to_chat(daddy, "<span class='warning'>You feel a bit less real. Which one of you two was original again?..</span>")



/obj/effect/bluegoast/examine()
	return daddy?.examine(arglist(args))

/obj/effect/bluegoast/proc/blueswitch()
	var/mob/living/carbon/human/H
	if(ishuman(daddy))
		H = new(get_turf(src), daddy.name)
//		H.dna = daddy.dna.Clone()
//		H.sync_organ_dna()
		H.apply_prefs_job(daddy.client, H.job)
		for(var/obj/item/entry in daddy.get_equipped_items(TRUE))
			H.equip_to_appropriate_slot(entry)
	else
		H = new daddy.type(get_turf(src))
		H.appearance = daddy.appearance

	H.real_name = daddy.real_name
	daddy.dust()
	qdel(src)

/* /obj/screen/fullscreen/bluespace_overlay
	icon = 'icons/effects/effects.dmi'
	icon_state = "mfoam"
	screen_loc = "WEST,SOUTH to EAST,NORTH"
	alpha = 80
	color = "#000050"
	blend_mode = BLEND_ADD
 */
