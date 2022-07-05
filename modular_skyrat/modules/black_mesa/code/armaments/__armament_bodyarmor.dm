
/datum/armament_entry/hecu/bodyarmor
	category = "Armor Kit"
	category_item_limit = 4

/datum/armament_entry/hecu/bodyarmor/normal
	name = "Basic Armor Kit"
	description = "Contains a set of two basic armor pieces, meant to moderately protect your body against everything."
	item_type = /obj/item/storage/box/armor_set/normal
	max_purchase = 4
	cost = 6

/datum/armament_entry/hecu/bodyarmor/bulletproof
	name = "Bulletproof Armor Kit"
	description = "Contains a set of two bulletproof armor pieces, meant to greatly protect your body against bullets and explosives."
	item_type = /obj/item/storage/box/armor_set/bulletproof
	max_purchase = 4
	cost = 10

/datum/armament_entry/hecu/bodyarmor/pcv
	name = "PCV Kit"
	description = "Contains a set of two hazardous environment armor pieces. This armor gives you a robust all-around protection, as well as mild regeneration."
	item_type = /obj/item/storage/box/armor_set/pcv
	max_purchase = 4
	cost = 20

/obj/item/storage/box/armor_set
	name = "box of armor"
	desc = "Box full of armor. Amazing."
	icon_state = "box"
	illustration = null

/obj/item/storage/box/armor_set/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.set_holdable(list(/obj/item/clothing/suit/armor,/obj/item/clothing/suit/space/hev_suit/pcv,/obj/item/clothing/head/helmet))
	STR.max_items = 2

/obj/item/storage/box/armor_set/normal
	name = "basic armor set"
	desc = "Box containing a basic armor vest and helmet."

/obj/item/storage/box/armor_set/normal/PopulateContents()
	new /obj/item/clothing/suit/armor/vest/hecu(src)
	new /obj/item/clothing/head/helmet/hecu(src)

/obj/item/storage/box/armor_set/bulletproof
	name = "bulletproof armor set"
	desc = "Box containing a bulletproof armor vest and helmet."

/obj/item/storage/box/armor_set/bulletproof/PopulateContents()
	new /obj/item/clothing/suit/armor/bulletproof/hecu(src)
	new /obj/item/clothing/head/helmet/alt/hecu(src)

/obj/item/storage/box/armor_set/pcv
	name = "PCV Mk. II armor set"
	desc = "Box containing a PCV Mark II armor vest and helmet."

/obj/item/storage/box/armor_set/pcv/PopulateContents()
	new /obj/item/clothing/suit/space/hev_suit/pcv(src)
	new /obj/item/clothing/head/helmet/space/hev_suit/pcv(src)
