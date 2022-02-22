/datum/opposing_force_equipment/service
	category = OPFOR_EQUIPMENT_CATEGORY_SERVICES
	item_type = /obj/effect/gibspawner/generic

/datum/opposing_force_equipment/service/rep
	name = "100 Reputation"
	description = "Grant your Syndicate uplink 100 reputation, should you have one."
	var/rep_count = 100

/datum/opposing_force_equipment/service/rep/high
	name = "500 Reputation"
	description = "Grant your Syndicate uplink 500 reputation, should you have one."
	rep_count = 500

/datum/opposing_force_equipment/service/rep/very_high
	name = "1000 Reputation"
	description = "Grant your Syndicate uplink 1000 reputation, should you have one."
	rep_count = 1000

/datum/opposing_force_equipment/service/rep/on_issue(mob/living/target)
	var/datum/component/uplink/the_uplink = target.mind.find_syndicate_uplink()
	if(!the_uplink) //Why'd you even purchase this in the first place?
		return
	var/datum/uplink_handler/handler = the_uplink.uplink_handler
	if(!handler)
		return
	handler.progression_points += rep_count

/datum/opposing_force_equipment/service/power_outage
	name = "Power Outage"
	description = "A virus will be uploaded to the engineering processing servers to force a routine power grid check, forcing all APCs on the station to be temporarily disabled."
	admin_note = "Equivalent to the Grid Check random event."

/datum/opposing_force_equipment/service/power_outage/on_issue()
	var/datum/round_event_control/event = locate(/datum/round_event_control/grid_check) in SSevents.control
	event.runEvent()

/datum/opposing_force_equipment/service/telecom_outage
	name = "Telecomms Outage"
	description = "A virus will be uploaded to the telecommunication processing servers to temporarily disable themselves."
	admin_note = "Equivalent to the Communications Blackout random event."

/datum/opposing_force_equipment/service/telecom_outage/on_issue()
	var/datum/round_event_control/event = locate(/datum/round_event_control/communications_blackout) in SSevents.control
	event.runEvent()

/datum/opposing_force_equipment/service/market_crash
	name = "Market Crash"
	description = "Some forged documents will be given to Nanotrasen, skyrocketing the price of all on-station vendors for a short while."
	admin_note = "Equivalent to the Market Crash random event."

/datum/opposing_force_equipment/service/market_crash/on_issue()
	var/datum/round_event_control/event = locate(/datum/round_event_control/market_crash) in SSevents.control
	event.runEvent()
