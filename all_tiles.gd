extends Node2D

@export var tilevalue = Vector2(0, 0)
@export var state: String
@export var substate: String
var continue_instanciating = true

var tree = load("res://tree.tscn")
var wheat = load("res://wheat.tscn")

var mouse_on_area = false

@onready var floutwitch_1: CharacterBody2D = %floutwitch1
@onready var inventory_interface: Control = $"../../UI/InventoryInterface"
signal tile_pressed

func _ready() -> void:
	tilevalue.x = position.x / 40
	tilevalue.y = position.y / 40

func _process(delta: float) -> void:
	
	if SaveSystem.game_saved == true:
		save()
	if SaveSystem.game_loaded == true:
		_load()
#	if substate == "mown_land":
#		print("1")
	#if $"../../UI/InventoryInterface".grabbed_slot_data != null:
		#if $"../../UI/InventoryInterface".grabbed_slot_data.item_data.name == "Seed":
			#print("not_working")
	if Input.is_action_pressed("click"):
		#if Global.can_spawn_tile("Seed", "mown_land", self):
			#print(self)
			#state = "wheat_plant"
		if $"../../UI/InventoryInterface".grabbed_slot_data:
			#print("1000")
			#if substate == "mown_land":
			# 	print("1")
			#if Input.is_action_just_pressed("click"):
				#print("2")
			#if $"../../UI/InventoryInterface".grabbed_slot_data.item_data.name == "Seed":
				#print("3")
			if substate == "mown_land" and Input.is_action_just_pressed("click") and $"../../UI/InventoryInterface".grabbed_slot_data.item_data.name == "Seed" and mouse_on_area == true and state == "" and Global.in_inventory_area == false:
				$"../../UI/InventoryInterface".grabbed_slot_data.quantity -= 1
				state = "wheat_plant"
				var wheatInst = wheat.instantiate()
				add_child(wheatInst)
				$"../../UI/InventoryInterface".update_grabbed_slot()
		if Global.slot_data_of_current_sellected_item:
			if substate == "mown_land" and Input.is_action_pressed("click") and Global.slot_data_of_current_sellected_item.item_data.name == "Seed" and mouse_on_area == true and state == "":
					
					state = "wheat_plant"
					var wheatInst = wheat.instantiate()
					add_child(wheatInst)
					Global.slot_data_of_current_sellected_item.quantity -= 1
					$"../../UI/InventoryInterface/Inventory".populate_item_grid(floutwitch_1.inventory_data)
					#floutwitch_1.inventory_data.slot_datas[$"../../UI/InventoryInterface".slot_row_selected].quantity -= 1
		#if state == "tree" and continue_instanciating == true:
			#var treeInst = tree.instantiate()
			#add_child(treeInst)
			#
		#if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and mouse_on_area == true and substate == "":
			#state = "tree"
			#
	

func _on_area_2d_mouse_entered() -> void:
	mouse_on_area = true
	

func _on_area_2d_mouse_exited() -> void:
	mouse_on_area = false
	

func save():
	#SaveSystem.config.set_value("tile" + str(round(get_parent().tilevalue.x)) + str(round(get_parent().tilevalue.y)), "state", "wheat")
	#SaveSystem.config.set_value("tile" + str(round(get_parent().tilevalue.x)) + str(round(get_parent().tilevalue.y)), "grow_time", time_to_grow)
	
	SaveSystem.config.set_value("tile" + str(tilevalue.x) + str(tilevalue.y), "state", state)
	

func _load():
	var err = SaveSystem.config.load("res://savegame.cfg")
	if err == OK:
		if SaveSystem.config.get_value("tile" + str(tilevalue.x) + str(tilevalue.y), "state") == "wheat_plant" and state == "":
			print("state_putted")
			state = "wheat_plant"
			var wheatInst = wheat.instantiate()
			add_child(wheatInst)
			#wheat.grow_time = SaveSystem.config.get_value("tile" + str(tilevalue.x) + str(tilevalue.y), "grow_time")
