/datum/controller/subsystem/ticker/proc/security_report()
	var/list/result = list()
	result += "<div>"
	result += "The Shitcurity Officers Were:"
	for(var/mob/living/carbon/human/officer in GLOB.mob_list)
		if(officer.get_assignment() == "Security Officer", "Warden", "Head Of Security", "Security Medic")
			officer += result += "..."
	result += "</div>"

	return result.Join()
