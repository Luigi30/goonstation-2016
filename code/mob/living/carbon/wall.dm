/mob/living/carbon/wall
	name = "living wall"
	real_name = "living wall"
	icon = 'icons/mob/mob.dmi'
	icon_state = "livingwall"
	a_intent = "disarm" // just so they don't swap with help intent users
	health = INFINITY
	anchored = 1
	density = 1
	nodamage = 1
	opacity = 1

	//Life(datum/controller/process/mobs/parent)
		//..(parent)
		//return

	examine()
		set src in view()

		boutput(usr, "<span style=\"color:blue\">*---------*</span>")
		boutput(usr, "<span style=\"color:blue\">This is a [bicon(src)] <B>[src.name]</B>!</span>")
		if(prob(50) && ishuman(usr) && usr.bioHolder.HasEffect("clumsy"))
			boutput(usr, "<span style=\"color:red\">You can't help but laugh at it.</span>")
			usr.emote("laugh")
		else
			boutput(usr, "<span style=\"color:red\">It looks pretty disturbing.</span>")

	say_understands(var/other)
		if (ishuman(other) || isrobot(other) || isAI(other))
			return 1
		return ..()

	attack_hand(mob/user as mob)
		boutput(user, "<span style=\"color:blue\">You push the [src.name] but nothing happens!</span>")
		playsound(src.loc, "sound/weapons/Genhit.ogg", 25, 1)
		src.add_fingerprint(user)
		return

	ex_act(severity)
		..() // Logs.
		switch(severity)
			if(1.0)
				src.gib(1)
				return
			if(2.0)
				if (prob(25))
					src.gib(1)
			else
		return

	attackby(obj/item/W as obj, mob/user as mob)
		if (istype(W, /obj/item/weldingtool) && W:welding)
			src.gib(1)
		else
			..()

/mob/living/carbon/wall/meatcube
	name = "meat cube"
	real_name = "meat cube"
	icon_state = "meatcube-squish"
	opacity = 0
	var/life_timer = 10

	Life(datum/controller/process/mobs/parent)
		if (..(parent))
			return 1

		if (src.client)
			src.antagonist_overlay_refresh(0, 0)

		if (istype(loc, /obj/machinery/deep_fryer))
			return

		if (prob(30))
			src.visible_message("<span style=\"color:red\"><b>[src] [pick("quivers","pulsates","squirms","flollops","shudders","twitches","willomies")] [pick("sadly","disgustingly","horrifically","unpleasantly","disturbingly","worryingly","pathetically","floopily")]!</b></span>")

		if (life_timer-- > 0)
			return

		for (var/i = 3, i > 0, i--)
			var/obj/item/reagent_containers/food/snacks/ingredient/meat/mysterymeat/meat = new /obj/item/reagent_containers/food/snacks/ingredient/meat/mysterymeat(src.loc)
			meat.name = "cube steak"
			meat.desc = "Grody."

		playsound(src.loc, "sound/effects/splat.ogg", 75, 1)
		src.visible_message("<span style=\"color:red\"><b>The meat cube pops!</b></span>")
		src.gib(1)
		return

	say_quote(var/text)
		if(src.emote_allowed)
			if(!(src.client && src.client.holder))
				src.emote_allowed = 0
			/*
			if(src.gender == MALE) playsound(get_turf(src), "sound/voice/male_scream.ogg", 100, 0, 0, 0.91)
			else playsound(get_turf(src), "sound/voice/female_scream.ogg", 100, 0, 0, 0.9)
			*/

			if (narrator_mode)
				playsound(src.loc, 'sound/vox/scream.ogg', 80, 0, 0, src.get_age_pitch())
			else
				if(src.gender == MALE) playsound(get_turf(src), 'sound/voice/male_scream.ogg', 80, 0, 0, src.get_age_pitch())
				else playsound(get_turf(src), 'sound/voice/female_scream.ogg', 80, 0, 0, src.get_age_pitch())

			spawn(50)
				src.emote_allowed = 1
			return "screams!"
		else
			return pick("gurgles.","shivers.","twitches.","shakes.","squirms.", "cries.")

	emote(var/act)
		. = null
		switch(act)
			if("dance")
				src.visible_message("<B>[src]</B> twitches to some kind of rhythm. At least, you think so. Those things are always twitching.")
			if("fart")
				var/fart_on_other = 0
				for (var/mob/living/M in src.loc)
					if (M == src || !M.lying) continue
					src.visible_message("<span style=\"color:red\"><B>[src]</B> jumps and farts all over [M]! That's disgusting!</span>")
					fart_on_other = 1
					if(prob(20))
						sleep(1)
						src.visible_message("<span style=\"color:red\">[M] vomits!</span>")
						playsound(M.loc, "sound/effects/splat.ogg", 50, 1)
						new /obj/decal/cleanable/vomit(M.loc)
					break
				if(!fart_on_other)
					switch (rand(1, 10))
						if (1) src.visible_message("<B>[src]</B> releases some kind of gas into the air.")
						if (2) src.visible_message("<B>[src]</B> farts! How can meat cubes do that?")
						if (3) src.visible_message("<B>[src]</B> shoots out a cloud of death.")
						if (4) src.visible_message("<B>[src]</B> squeezes itself inward and farts.")
						if (5) src.visible_message("<B>[src]</B> hops up and down, farting all the while.")
						if (6) src.visible_message("<B>[src]</B> fart in it own mouth. A shameful [src].")
						if (7) src.visible_message("<B>[src]</B> gets revenge on humanity with a terrible fart.")
						if (8) src.visible_message("<B>[src]</B> stinks even worse than normal, somehow.")
						if (9) src.visible_message("<B>[src]</B> shows that it can fart just as good as any human.")
						if (10)
							src.visible_message("<B>[src]</B> farts blood and guts out of one of its sides! That's absolutely disgusting!")
							var/obj/decal/cleanable/blood/gibs/gib = null
							gib = new /obj/decal/cleanable/blood/gibs(src.loc)
							gib.streak(alldirs)
				playsound(src.loc, 'sound/misc/poo2.ogg', 50, 1)
			if ("flex","flexmuscles")
				src.visible_message("<B>[src]</B>'s center compresses slightly more than the rest of its jiggling mass. Are those... muscles?")
			if ("flip")
				src.visible_message("<B>[src]</b> squishes down, pops up, and does a flip! Gross!")
				animate_spin(src, "R", 1, 0)
			if ("smile","grin","smirk","frown","scowl","grimace","sulk","pout","blink","nod","shrug","think","ponder","contemplate")
				// basic visible single-word emotes
				src.visible_message("<B>[src]</B> jiggles like only a meat cube can.")

	verb/suicide()
		set hidden = 1

		if (src.stat == 2)
			boutput(src, "You're already dead!")
			return

		if (suiciding)
			boutput(src, "You're already committing suicide! Be patient!")
			return

		suiciding = 1

		var/confirm = alert("Are you sure you want to commit suicide?", "Confirm Suicide", "Yes", "No")

		if(confirm == "Yes")
			logTheThing("combat", src, null, "commits suicide")

			var/obj/machinery/deep_fryer/fryer = locate() in orange(1, src)
			if (istype(fryer) && fryer.suicide(src))
				src.unlock_medal("Damned", 1)
				src.suiciding = 0
				return
			else
				src.visible_message("<span style=\"color:red\"><b>The meat cube pops!</b></span>")
				src.gib(1)
				src.unlock_medal("Damned", 1)
				src.suiciding = 0
				return

/mob/living/carbon/wall/meatcube/krampus
	name = "Krampus 2.0"
	life_timer = INFINITY
	icon_state = "krampus2-squish"

	New()
		..()
		real_name = pick("Krampus", "Krampus 2.0", "The Krampmeister", "The Krampster") //For deadchat
		spawn(20) //I do not know where the hell you get a bioholder from =I
			if(src.bioHolder) src.bioHolder.age = 110


	attackby(obj/item/W as obj, mob/user as mob)
		user.visible_message("<span class='combat'><B>[user] pokes [src] with \the [W]!</B></span>") //No weldergibs. Krampus is truly a fiend.