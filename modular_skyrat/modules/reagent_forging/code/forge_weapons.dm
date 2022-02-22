/obj/item/forging/reagent_weapon
	icon = 'modular_skyrat/modules/reagent_forging/icons/obj/forge_items.dmi'
	lefthand_file = 'modular_skyrat/modules/reagent_forging/icons/mob/forge_weapon_l.dmi'
	righthand_file = 'modular_skyrat/modules/reagent_forging/icons/mob/forge_weapon_r.dmi'

/obj/item/forging/reagent_weapon/Initialize()
	. = ..()
	AddComponent(/datum/component/reagent_weapon)

/obj/item/forging/reagent_weapon/examine(mob/user)
	. = ..()
	. += span_notice("Using a hammer on [src] will repair its damage!")

/obj/item/forging/reagent_weapon/attackby(obj/item/attacking_item, mob/user, params)
	if(atom_integrity >= max_integrity)
		return ..()
	if(istype(attacking_item, /obj/item/forging/hammer))
		var/obj/item/forging/hammer/attacking_hammer = attacking_item
		var/skill_modifier = user.mind.get_skill_modifier(/datum/skill/smithing, SKILL_SPEED_MODIFIER) * attacking_hammer.work_time
		while(atom_integrity < max_integrity)
			if(!do_after(user, skill_modifier, src))
				return
			var/fixing_amount = min(max_integrity - atom_integrity, 5)
			atom_integrity += fixing_amount
			user.mind.adjust_experience(/datum/skill/smithing, 5) //useful heating means you get some experience
		return
	return ..()

/obj/item/forging/reagent_weapon/sword
	name = "reagent sword"
	desc = "A sword that can be imbued with a reagent. Useful for blocking."
	force = 15
	armour_penetration = 10
	icon_state = "sword"
	inhand_icon_state = "sword"
	hitsound = 'sound/weapons/bladeslice.ogg'
	throwforce = 10
	block_chance = 25 //either we make it melee block only or we don't give it too much. It's bulkly so the buckler is superior
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_BACK
	w_class = WEIGHT_CLASS_BULKY
	resistance_flags = FIRE_PROOF
	attack_verb_continuous = list("attacks", "slashes", "stabs", "slices", "tears", "lacerates", "rips", "dices", "cuts")
	attack_verb_simple = list("attack", "slash", "stab", "slice", "tear", "lacerate", "rip", "dice", "cut")
	sharpness = SHARP_EDGED
	max_integrity = 150

/obj/item/forging/reagent_weapon/katana
	name = "reagent katana"
	desc = "A katana that can be imbued with a reagent. It's very sharp, but not quite million-times-folded sharp."
	force = 15
	armour_penetration = 25 //Slices through armour like butter, but can't quite bisect a knight like the real thing.
	wound_bonus = 20
	bare_wound_bonus = 40
	icon_state = "katana"
	inhand_icon_state = "katana"
	hitsound = 'sound/weapons/bladeslice.ogg'
	throwforce = 10
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_BACK
	w_class = WEIGHT_CLASS_BULKY
	resistance_flags = FIRE_PROOF
	attack_verb_continuous = list("attacks", "slashes", "stabs", "slices", "tears", "lacerates", "rips", "dices", "cuts")
	attack_verb_simple = list("attack", "slash", "stab", "slice", "tear", "lacerate", "rip", "dice", "cut")
	sharpness = SHARP_EDGED

/obj/item/forging/reagent_weapon/dagger
	name = "reagent dagger"
	desc = "A dagger that can be imbued with a reagent. It can attack very fast!"
	force = 8
	icon_state = "dagger"
	inhand_icon_state = "dagger"
	hitsound = 'sound/weapons/bladeslice.ogg'
	throwforce = 10
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_BACK
	w_class = WEIGHT_CLASS_SMALL
	resistance_flags = FIRE_PROOF
	attack_verb_continuous = list("attacks", "slashes", "stabs", "slices", "tears", "lacerates", "rips", "dices", "cuts")
	attack_verb_simple = list("attack", "slash", "stab", "slice", "tear", "lacerate", "rip", "dice", "cut")
	sharpness = SHARP_EDGED

/obj/item/forging/reagent_weapon/dagger/attack(mob/living/M, mob/living/user, params)
	. = ..()
	user.changeNext_move(CLICK_CD_RANGE)

/obj/item/forging/reagent_weapon/staff //doesn't do damage. Useful for healing reagents.
	name = "reagent staff"
	desc = "A staff that can be imbued with a reagent. It has a very soft swing."
	force = 0
	icon_state = "staff"
	inhand_icon_state = "staff"
	throwforce = 0
	slot_flags = ITEM_SLOT_BACK
	w_class = WEIGHT_CLASS_NORMAL
	resistance_flags = FIRE_PROOF
	attack_verb_continuous = list("bonks", "bashes", "whacks", "pokes", "prods")
	attack_verb_simple = list("bonk", "bash", "whack", "poke", "prod")

/obj/item/forging/reagent_weapon/staff/attack(mob/living/M, mob/living/user, params)
	. = ..()
	user.changeNext_move(CLICK_CD_RANGE)

/obj/item/forging/reagent_weapon/spear
	name = "reagent spear"
	desc = "A spear that can be imbued with a reagent. It can be dual-wielded to increase its damage!"
	force = 10
	armour_penetration = 10
	icon_state = "spear"
	inhand_icon_state = "spear"
	throwforce = 15 //not a javelin, throwing specialty is for the axe.
	slot_flags = ITEM_SLOT_BACK
	w_class = WEIGHT_CLASS_BULKY
	resistance_flags = FIRE_PROOF
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb_continuous = list("attacks", "pokes", "jabs", "tears", "lacerates", "gores")
	attack_verb_simple = list("attack", "poke", "jab", "tear", "lacerate", "gore")
	wound_bonus = -15
	bare_wound_bonus = 15
	reach = 2
	sharpness = SHARP_POINTY

/obj/item/forging/reagent_weapon/spear/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/two_handed, force_unwielded=10, force_wielded=17) //better than the bone spear

/obj/item/forging/reagent_weapon/axe
	name = "reagent axe"
	desc = "An axe that can be imbued with a reagent. Looks balanced for throwing."
	force = 15
	armour_penetration = 10
	icon_state = "axe"
	inhand_icon_state = "axe"
	throwforce = 22 //ouch
	throw_speed = 4
	embedding = list("impact_pain_mult" = 2, "remove_pain_mult" = 4, "jostle_chance" = 2.5)
	slot_flags = ITEM_SLOT_BACK
	w_class = WEIGHT_CLASS_BULKY
	resistance_flags = FIRE_PROOF
	attack_verb_continuous = list("slashes", "bashes")
	attack_verb_simple = list("slash", "bash")
	sharpness = SHARP_EDGED

/obj/item/forging/reagent_weapon/hammer
	name = "reagent hammer"
	desc = "A hammer that can be imbued with a reagent. It packs a real wallop."
	force = 19 //strong but boring.
	armour_penetration = 10
	icon_state = "crush_hammer"
	inhand_icon_state = "crush_hammer"
	throwforce = 10
	slot_flags = ITEM_SLOT_BACK
	w_class = WEIGHT_CLASS_BULKY
	resistance_flags = FIRE_PROOF
	attack_verb_continuous = list("bashes", "whacks")
	attack_verb_simple = list("bash", "whack")

/obj/item/shield/riot/buckler/reagent_weapon //Same as a buckler, but metal.
	name = "reagent plated buckler shield"
	desc = "A small, round shield best used in tandem with a melee weapon in close-quarters combat; can be imbued with a reagent."
	icon = 'modular_skyrat/modules/reagent_forging/icons/obj/forge_items.dmi'
	icon_state = "buckler"
	inhand_icon_state = "buckler"
	lefthand_file = 'modular_skyrat/modules/reagent_forging/icons/mob/forge_weapon_l.dmi'
	righthand_file = 'modular_skyrat/modules/reagent_forging/icons/mob/forge_weapon_r.dmi'
	custom_materials = list(/datum/material/iron=1000)
	resistance_flags = FIRE_PROOF
	block_chance = 30
	transparent = FALSE
	max_integrity = 150 //over double that of a wooden one
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/shield/riot/buckler/reagent_weapon/Initialize()
	. = ..()
	AddComponent(/datum/component/reagent_weapon)

/obj/item/shield/riot/buckler/reagent_weapon/shatter(mob/living/carbon/human/owner)
	owner.balloon_alert_to_viewers("shield has shattered!")
	playsound(owner, 'sound/effects/bang.ogg', 50)
	new /obj/item/forging/complete/plate(get_turf(src))

/obj/item/shield/riot/buckler/reagent_weapon/examine(mob/user)
	. = ..()
	. += span_notice("Using a hammer on [src] will repair its damage!")

/obj/item/shield/riot/buckler/reagent_weapon/attackby(obj/item/attacking_item, mob/user, params)
	if(atom_integrity >= max_integrity)
		return ..()
	if(istype(attacking_item, /obj/item/forging/hammer))
		var/obj/item/forging/hammer/attacking_hammer = attacking_item
		var/skill_modifier = user.mind.get_skill_modifier(/datum/skill/smithing, SKILL_SPEED_MODIFIER) * attacking_hammer.work_time
		while(atom_integrity < max_integrity)
			if(!do_after(user, skill_modifier, src))
				return
			var/fixing_amount = min(max_integrity - atom_integrity, 5)
			atom_integrity += fixing_amount
			user.mind.adjust_experience(/datum/skill/smithing, 5) //useful heating means you get some experience
			balloon_alert(user, "partially repaired!")
		return
	return ..()

/obj/item/shield/riot/buckler/reagent_weapon/pavise //similar to the adamantine shield. Huge, slow, lets you soak damage and packs a wallop.
	name = "reagent plated pavise shield"
	desc = "An oblong shield used by ancient crossbowman as cover while reloading; can be imbued with a reagent."
	icon_state = "pavise"
	inhand_icon_state = "pavise"
	block_chance = 75
	item_flags = SLOWS_WHILE_IN_HAND
	w_class = WEIGHT_CLASS_HUGE
	slot_flags = ITEM_SLOT_BACK
	max_integrity = 300 //tanky

/obj/item/shield/riot/buckler/reagent_weapon/pavise/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/two_handed, require_twohands=TRUE, force_wielded=15)

/obj/item/pickaxe/reagent_weapon
	name = "reagent pickaxe"

/obj/item/pickaxe/reagent_weapon/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/reagent_weapon)

/obj/item/shovel/reagent_weapon
	name = "reagent shovel"

/obj/item/shovel/reagent_weapon/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/reagent_weapon)
