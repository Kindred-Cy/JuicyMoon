/datum/round_event_control/spider_infestation
	name = "Spider Infestation"
	typepath = /datum/round_event/spider_infestation
	weight = 50
	max_occurrences = 5
	min_players = 15
	category = EVENT_CATEGORY_ENTITIES
	description = "Spawns spider eggs, ready to hatch."

/datum/round_event/spider_infestation
	announce_when	= 400

	var/spawncount = 1


/datum/round_event/spider_infestation/setup()
	announce_when = rand(announce_when, announce_when + 50)
	spawncount = rand(5, 8)

/datum/round_event/spider_infestation/announce(fake)
	priority_announce("Неизвестные признаки жизни обнаружены на борту [station_name()]. Заблокируйте любой внешний доступ, включая воздуховоды и вентиляцию.", "Вторжение на Борт", "aliens")


/datum/round_event/spider_infestation/start()
	var/list/vents = list()
	for(var/obj/machinery/atmospherics/components/unary/vent_pump/temp_vent in GLOB.machines)
		if(QDELETED(temp_vent))
			continue
		if(is_station_level(temp_vent.loc.z) && !temp_vent.welded)
			var/datum/pipeline/temp_vent_parent = temp_vent.parents[1]
			if(temp_vent_parent.other_atmosmch.len > 20)
				vents += temp_vent

	while((spawncount >= 1) && vents.len)
		var/obj/vent = pick(vents)
		var/spawn_type = /obj/structure/spider/spiderling
		if(prob(66))
			spawn_type = /obj/structure/spider/spiderling/nurse
		announce_to_ghosts(spawn_atom_to_turf(spawn_type, vent, 1, FALSE))
		vents -= vent
		spawncount--
