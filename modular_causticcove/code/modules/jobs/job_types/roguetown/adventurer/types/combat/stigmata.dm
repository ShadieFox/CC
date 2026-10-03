	// Weaker absolve for the Stigmata adventurer
/obj/effect/proc_holder/spell/invoked/psydonamend
	name = "AMEND"
	action_icon = 'icons/mob/actions/psydonmiracles.dmi'
	overlay_icon = 'icons/mob/actions/psydonmiracles.dmi'
	overlay_state = "ABSOLVE"
	desc = "A lesser form of the mighty art of ABSOLUTION, bereft of its means to revive. Transfers the wounds from your target to you. Use carefully."
	releasedrain = 20
	chargedrain = 0
	chargetime = 0
	range = 5
	warnie = "sydwarning"
	movement_interrupt = FALSE
	sound = 'sound/magic/psyabsolution.ogg'
	invocations = list("BE AMENDED!")
	invocation_type = "none"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = FALSE
	recharge_time = 30 SECONDS // 60 seconds cooldown
	miracle = TRUE
	devotion_cost = 80

/obj/effect/proc_holder/spell/invoked/psydonamend/cast(list/targets, mob/living/user)

	if(!ishuman(targets[1]))
		to_chat(user, span_warning("AMENDMENT is for those who walk in HIS image!"))
		revert_cast()
		return FALSE

	var/mob/living/carbon/human/H = targets[1]

	if(H == user)
		to_chat(user, span_warning("You cannot AMEND yourself!"))
		revert_cast()
		return FALSE

	// THE LESSER ART OF AMENDMENT CANNOT RETURN THE DEAD.

	// Transfer afflictions from the target to the caster

	// Transfer damage
	var/brute_transfer = H.getBruteLoss()
	var/burn_transfer = H.getFireLoss()
	var/tox_transfer = H.getToxLoss()
	var/oxy_transfer = H.getOxyLoss()
	var/clone_transfer = H.getCloneLoss()

	if (oxy_transfer >= 150)
		if (alert(user, "THEY ARE ASHEN WITH STILLED BREATH. AMENDMENT MAY INSTANTLY KILL YOU, STIGMATA. PROCEED?", "SELF-PRESERVATION", "YES", "NO") != "YES")
			revert_cast()
			return

	// Heal the target
	H.adjustBruteLoss(-brute_transfer)
	H.adjustFireLoss(-burn_transfer)
	H.adjustToxLoss(-tox_transfer)
	H.adjustOxyLoss(-oxy_transfer)
	H.adjustCloneLoss(-clone_transfer)

	// Apply damage to the caster
	user.adjustBruteLoss(brute_transfer)
	user.adjustFireLoss(burn_transfer)
	user.adjustToxLoss(tox_transfer)
	user.adjustOxyLoss(oxy_transfer)
	user.adjustCloneLoss(clone_transfer)

	// Visual effects
	user.visible_message(span_danger("[user] takes [H]'s suffering upon themselves!"))
	new /obj/effect/temp_visual/psyheal_rogue(get_turf(H), "#aa1717")
	new /obj/effect/temp_visual/psyheal_rogue(get_turf(H), "#aa1717")
	new /obj/effect/temp_visual/psyheal_rogue(get_turf(H), "#aa1717")

	new /obj/effect/temp_visual/psyheal_rogue(get_turf(user), "#aa1717")
	new /obj/effect/temp_visual/psyheal_rogue(get_turf(user), "#aa1717")
	new /obj/effect/temp_visual/psyheal_rogue(get_turf(user), "#aa1717")

	// Notify the user and target
	to_chat(user, span_warning("You amend [H] of their agony, taking it upon yourself!"))
	to_chat(H, span_notice("[user] amends you of your agony!"))

	return TRUE

/datum/advclass/cleric/stigmata
	name = "Stigmata"
	tutorial = "PSYDON weeps. You are a devout cleric of the Allfather whom takes the suffering of others upon themselves. You have eschewn violence. You will suffer. You will endure."
	outfit = /datum/outfit/job/roguetown/adventurer/stigmata
	allowed_races = RACES_NO_CONSTRUCT

	traits_applied = list(
		TRAIT_PACIFISM,
		TRAIT_EMPATH,
		TRAIT_CRITICAL_RESISTANCE,
		TRAIT_STEELHEARTED,
		TRAIT_RITUALIST
	)
	subclass_stats = list(
		STATKEY_CON = 5,
		STATKEY_WIL = 3,
		STATKEY_SPD = 1,
		STATKEY_STR = -2,
	)
	subclass_skills = list(
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/alchemy = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/fishing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/holy = SKILL_LEVEL_JOURNEYMAN,
	)
	subclass_stashed_items = list(
		"Tome of Psydon" = /obj/item/book/rogue/bibble/psy
	)
	extra_context = "This is a psydonite only subclass, it will force you to be one if it is not set. You will be a pacifist and are able to draw upon a weaker version of the abilities known by a Psydonic Absolver."

/datum/outfit/job/roguetown/adventurer/stigmata
	allowed_patrons = list(/datum/patron/old_god)

/datum/outfit/job/roguetown/adventurer/stigmata/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	H.adjust_blindness(-3)
	r_hand = /obj/item/cooking/pan
	head = /obj/item/clothing/head/roguetown/roguehood/psydon/navy_blue
	pants = /obj/item/clothing/under/roguetown/tights/black
	shirt = /obj/item/clothing/suit/roguetown/armor/vestments_padded/navy_blue
	neck = /obj/item/clothing/neck/roguetown/psicross/silver
	wrist = /obj/item/clothing/wrists/roguetown/wrappings
	shoes = /obj/item/clothing/shoes/roguetown/boots
	backl = /obj/item/storage/backpack/rogue/satchel
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/storage/belt/rogue/pouch/coins/mid
	backpack_contents = list(
		/obj/item/recipe_book/survival = 1,
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot = 2,
		/obj/item/storage/belt/rogue/pouch/medicine = 1,
		/obj/item/ritechalk = 1
		)

	if (H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/diagnose/secular)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/psydonlux_tamper) // absolver's bleed transfer
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/psydonamend) // nerfed no-rez version of absolver's absolve

	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T4, passive_gain = (CLERIC_REGEN_ABSOLVER / 2), start_maxed = TRUE)
