/datum/action/item_action/set_internals
	name = "Set Internals"
	default_button_position = SCRN_OBJ_INSERT_FIRST
	button_overlay_state = "ab_goldborder"
	var/current_cycle = "pressure"
	var/current_button
	var/image/text_holder
/datum/action/item_action/set_internals/UpdateButton(atom/movable/screen/movable/action_button/button, status_only = FALSE, force)
	. = ..()
	if(!. || !button) // no button available
		return
	if(!iscarbon(owner))
		return
	var/mob/living/carbon/carbon_owner = owner
	if(target == carbon_owner.internal)
		button.icon_state = "template_active"
		current_button = button
		timed_cycle(current_button)

/datum/action/item_action/set_internals/proc/timed_cycle(atom/movable/screen/movable/action_button/button)
	text_holder = image(null, button || current_button)
	var/mob/living/carbon/carbon_owner = owner
	text_holder.alpha = 15
	text_holder.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA
	text_holder.maptext_width = 160
	text_holder.maptext_height = 64
	text_holder.maptext = MAPTEXT("Checking...")
	if(!current_cycle)
		text_holder.maptext = MAPTEXT("<span style=\"font-size:5px\">REL:\n[carbon_owner.internal.distribute_pressure]\nCUR:\n[round(carbon_owner.internal.air_contents.return_pressure(),0.01)]\n</span>")
		text_holder.maptext_y = -32
		animate(text_holder, 1, alpha = 255, pixel_y = -32)
		current_cycle = "pressure"

	switch(current_cycle)
		if("pressure")
			text_holder.maptext = MAPTEXT("<span style=\"font-size:5px\">CUR:\n[round(carbon_owner.internal.air_contents.return_pressure(),0.01)]\n</span>")
			current_cycle = "remain"
			animate(text_holder, 1, alpha = 255, pixel_y = -32)
			addtimer(CALLBACK(src, .proc/timed_cycle), 5 SECONDS)
		if("remain")
			text_holder.maptext = MAPTEXT("<span style=\"font-size:5px\">REL:\n[carbon_owner.internal.distribute_pressure]\n</span>")
			current_cycle = "pressure"
			animate(text_holder, 1, alpha = 255, pixel_y = -32)
			addtimer(CALLBACK(src, .proc/timed_cycle), 5 SECONDS)

