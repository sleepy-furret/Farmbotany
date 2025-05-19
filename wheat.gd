extends Node2D

var time_to_grow: float
var can_be_collected = false
@onready var timer: Timer = %Timer
@onready var wheat_sprite: Sprite2D = $wheat_sprite
@export var wheat: SlotData
@onready var floutwitch_1: CharacterBody2D = get_parent().get_parent().floutwitch_1

var pos: Vector2
var tile_value

func _process(delta: float) -> void:
	pass
	position = pos
	#if SaveSystem.game_saved == true:
		#save()
		#await get_tree().create_timer(0.1).timeout
		#SaveSystem.game_saved = false
	#if SaveSystem.game_loaded == true:
		#
		#_load()
		#await get_tree().create_timer(0.1).timeout
		#SaveSystem.game_loaded = false
	wheat.duplicate()
	wheat.quantity = 1
	if can_be_collected == true:
		pass
	
	if can_be_collected == true and Global.position_to_tile_value(get_global_mouse_position()) == tile_value and Input.is_action_pressed("click"):
		if floutwitch_1:
			wheat.duplicate()
			
			floutwitch_1.inventory_data.pick_up_slot_data(wheat)
			get_parent().get_parent().world_1.TileSlotDatas[tile_value].state = ""
			#print("hi")
		queue_free()
		
	#if floutwitch_1:
	#	print("hi")
	#if get_parent().get_parent().get_parent().floutwitch_1:
	#	print("hi")
	time_to_grow = timer.time_left
	if time_to_grow < 999:
		can_be_collected = false
		wheat_sprite.texture = load("res://Sprites/harvests/wheat_growing.png")
	if time_to_grow == 0:
		
		can_be_collected = true
		wheat_sprite.texture = load("res://Sprites/harvests/wheat.png")
		timer.stop()
	

func save():
	pass
	#SaveSystem.config.set_value("tile" + str(round(get_parent().tilevalue.x)) + str(round(get_parent().tilevalue.y)), "state", "wheat")
	#SaveSystem.config.set_value("tile" + str(round(get_parent().tilevalue.x)) + str(round(get_parent().tilevalue.y)), "grow_time", time_to_grow)
	#print(get_parent().tilevalue.x, get_parent().tilevalue.y, position)
	#SaveSystem.config.set_value("tile" + str(get_parent().tilevalue.x) + str(get_parent().tilevalue.y), "state", "wheat")
	#SaveSystem.config.set_value("tile" + str(get_parent().tilevalue.x) + str(get_parent().tilevalue.y), "grow_time", timer.wait_time)
	#print("saved")


func _load():
	var err = SaveSystem.config.load("res://savegame.cfg")
	#if err == OK:
		#
		#if SaveSystem.config.get_value("tile" + str(get_parent().tilevalue.x) + str(get_parent().tilevalue.y), "state") != "wheat_plant":
			#queue_free()
			#print("queue_free")
		#else:
			#time_to_grow = SaveSystem.config.get_value("tile" + str(get_parent().tilevalue.x) + str(get_parent().tilevalue.y), "grow_time")
			#timer.wait_time = SaveSystem.config.get_value("tile" + str(get_parent().tilevalue.x) + str(get_parent().tilevalue.y), "grow_time")
			#timer.stop()
			#timer.start()
			#print(time_to_grow, SaveSystem.config.get_value("tile" + str(get_parent().tilevalue.x) + str(get_parent().tilevalue.y), "grow_time"))
