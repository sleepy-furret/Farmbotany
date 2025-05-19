extends Node2D

@onready var inventory_interface: Control = $UI/InventoryInterface
@onready var floutwitch_1: CharacterBody2D = %floutwitch1
@export var book: SlotData
@export var slot_array: Array
var index: int
var collums = 12
var whole_value
@export var inv_data: InventoryData
@export var seed: SlotData
@export var wheat: SlotData

@export var generic_tile: TileSlotData
@export var wheat_tile: TileSlotData

@export var generic_block: BlockData
@export var wheat_block: BlockData

@export var world_1: WorldData

@onready var external_inventory: PanelContainer = $UI/InventoryInterface/ExternalInventory
@onready var shop_ui: Control = $"UI/shop ui"
@onready var external_inventory_sell: PanelContainer = %ExternalInventorySell
@onready var sell_inventory_visible: Control = %SellInventoryVisible
@onready var money: Label = $UI/money
@onready var time: Label = %time
@onready var directional_light_2d: DirectionalLight2D = %DirectionalLight2D
@onready var animation_player: AnimationPlayer = $DirectionalLight2D/AnimationPlayer
@onready var all_tiles: Node2D = %all_tiles

@onready var _01_02_transition: Marker2D = $"01-02transition"
@onready var _02_01_transition: Marker2D = $"02-01transition"

@onready var mown_land_1_x_max: Marker2D = $substate_setters/mown_land/mown_land_1_x_max
@onready var mown_land_1_x_min: Marker2D = $substate_setters/mown_land/mown_land_1_x_min
@onready var mown_land_1_y_max: Marker2D = $substate_setters/mown_land/mown_land_1_y_max
@onready var mown_land_1_y_min: Marker2D = $substate_setters/mown_land/mown_land_1_y_min

func _ready() -> void:
	
	for i in range(0, world_1.TileSlotDatas.size()):
		
		var current_pos = Vector2(0,0)
		current_pos = Global.tile_value_to_position(i)
		
		if current_pos.x > mown_land_1_x_max.position.x and current_pos.x < mown_land_1_x_min.position.x and current_pos.y > mown_land_1_y_max.position.y and current_pos.y < mown_land_1_y_min.position.y:
			
			if world_1.TileSlotDatas[i]:
				
				world_1.TileSlotDatas[i].sub_state = "mown_land"
			else:
				generic_tile.duplicate()
				world_1.TileSlotDatas[i] = generic_tile
				generic_tile.duplicate()
				world_1.TileSlotDatas[i].duplicate()
				world_1.TileSlotDatas[i].sub_state = "mown_land"
	
	sell_inventory_visible.visible = false
	inventory_interface.set_player_inventory_data(floutwitch_1.inventory_data)
	await get_tree().create_timer(5.0).timeout
	floutwitch_1.inventory_data.pick_up_slot_data(book)
	
	for node in get_tree().get_nodes_in_group("external_inventory"):
		node.toggle_inventory.connect(toggle_inventory_interface)
	

func toggle_inventory_interface(external_inventory_owner):
	if external_inventory_owner:
		inventory_interface.set_external_inventory(external_inventory_owner)

func save():
	for i in range(0, floutwitch_1.inventory_data.slot_datas.size()):
		
		if floutwitch_1.inventory_data.slot_datas[i]:
			
			
			
			Global.config.set_value("slot" + str(i), \
						"name", floutwitch_1.inventory_data.slot_datas[i].item_data.name)
			#Global.config.set_value("slot" + str(floutwitch_1.inventory_data.slot_datas[i].index), \
						#"name", floutwitch_1.inventory_data.slot_datas[i].slot_data.item_data.name)
			Global.config.set_value("slot" + str(i), \
						"quantity", floutwitch_1.inventory_data.slot_datas[i].quantity)
		else:
			Global.config.set_value("slot" + str(i), \
						"name", "")
			
			Global.config.set_value("slot" + str(i), \
						"quantity", 0)
			pass
		#Global.config.set_value("player", "y", )
	Global.config.save("res://savegame.cfg")

func _load():
	var err = Global.config.load("res://savegame.cfg")
	if err == OK:
		for i in range(0, floutwitch_1.inventory_data.slot_datas.size()):
			if Global.config.get_value("slot" + str(i), "name"):
				nullify()
				
				#print(Global.config.get_value("slot" + str(i), "name"))
				#print(Global.config.get_value("slot" + str(i), "quantity"))
				if Global.config.get_value("slot" + str(i), "name") == "Seed": 
					
					seed = seed.duplicate()
					floutwitch_1.inventory_data.slot_datas[i] = seed
					floutwitch_1.inventory_data.slot_datas[i].quantity = Global.config.get_value("slot" + str(i), "quantity")
					
				if Global.config.get_value("slot" + str(i), "name") == "Book":
					
					book = book.duplicate()
					floutwitch_1.inventory_data.slot_datas[i] = book
					floutwitch_1.inventory_data.slot_datas[i].quantity = Global.config.get_value("slot" + str(i), "quantity")
					
				if Global.config.get_value("slot" + str(i), "name") == "Wheat": 
					
					wheat = wheat.duplicate()
					floutwitch_1.inventory_data.slot_datas[i] = wheat
					floutwitch_1.inventory_data.slot_datas[i].quantity = Global.config.get_value("slot" + str(i), "quantity")
					
				
				
				#floutwitch_1.inventory_data.slot_datas[i].set_item_data(Global.config.get_value("slot" + str(i), "name"))
				#floutwitch_1.inventory_data.slot_datas[i].item_data.name = Global.config.get_value("slot" + str(i), "name")
				#floutwitch_1.inventory_data.slot_datas[i].quantity = Global.config.get_value("slot" + str(i), "quantity")
				#floutwitch_1.inventory_data.inventory_update.emit("res://inventory/test_inventory.tres")
				floutwitch_1.inventory_data.inventory_update.emit("res://inventory/test_inventory.tres")
				floutwitch_1.inventory_data.inventory_interact.emit(floutwitch_1.inventory_data, i, i)
				$UI/InventoryInterface/Inventory.populate_item_grid(floutwitch_1.inventory_data)
			else:
				
				if Global.config.get_value("slot" + str(i), "name") == "": 
					floutwitch_1.inventory_data.slot_datas[i] = null
					
					
				floutwitch_1.inventory_data.inventory_update.emit("res://inventory/test_inventory.tres")
				floutwitch_1.inventory_data.inventory_interact.emit(floutwitch_1.inventory_data, i, i)
				$UI/InventoryInterface/Inventory.populate_item_grid(floutwitch_1.inventory_data)
				
				
				#floutwitch_1.inventory_data.slot_datas[i].item_data.name = ""
				#floutwitch_1.inventory_data.slot_datas[i].quantity = 0
				#floutwitch_1.inventory_data.inventory_update.emit("res://inventory/test_inventory.tres")
				
		

func nullify():
	for i in range(0, floutwitch_1.inventory_data.slot_datas.size()):
		floutwitch_1.inventory_data.slot_datas[i]

func _process(delta: float) -> void:
	if world_1.TileSlotDatas[Global.position_to_tile_value(get_global_mouse_position())]:
		print(world_1.TileSlotDatas[Global.position_to_tile_value(get_global_mouse_position())].state)
	
	animation_player.seek(TimeSystem.seconds_past)
	time.text = str(TimeSystem.hour) + " : " + str(TimeSystem.second)
	money.text = str(Global.money)
	if Input.is_action_just_pressed("click"):
		
		if inventory_interface.grabbed_slot_data and Global.in_inventory_area == false:
			
			if inventory_interface.grabbed_slot_data.item_data.name == "Seed":
				var place_tile_value
				place_tile_value = Global.position_to_tile_value(get_global_mouse_position())
				if world_1.TileSlotDatas[place_tile_value]:
					if world_1.TileSlotDatas[place_tile_value].sub_state == "mown_land":
						
						
						if world_1.TileSlotDatas[place_tile_value] == null:
							world_1.TileSlotDatas[place_tile_value] = wheat_tile
							world_1.TileSlotDatas[place_tile_value].state = wheat_tile.state
							
							var place_to_grow = get_global_mouse_position()
							var wheat = load(world_1.TileSlotDatas[place_tile_value].block_data.scene)
							var wheat_inst = wheat.instantiate()
							wheat_inst.pos = Global.tile_value_to_position(place_tile_value)
							wheat_inst.tile_value = place_tile_value
							all_tiles.add_child(wheat_inst)
							inventory_interface.grabbed_slot_data.quantity -= 1
							inventory_interface.update_grabbed_slot()
						else:
							if world_1.TileSlotDatas[place_tile_value].state == "":
								world_1.TileSlotDatas[place_tile_value].block_data = wheat_tile.block_data
								world_1.TileSlotDatas[place_tile_value].state = "Wheat"
								
								var place_to_grow = get_global_mouse_position()
								var wheat = load(world_1.TileSlotDatas[place_tile_value].block_data.scene)
								var wheat_inst = wheat.instantiate()
								wheat_inst.pos = Global.tile_value_to_position(place_tile_value)
								wheat_inst.tile_value = place_tile_value
								all_tiles.add_child(wheat_inst)
								inventory_interface.grabbed_slot_data.quantity -= 1
								inventory_interface.update_grabbed_slot()
			
		#if world_1.TileSlotDatas[Global.position_to_tile_value(get_global_mouse_position())]:
			#print(world_1.TileSlotDatas[Global.position_to_tile_value(get_global_mouse_position())].sub_state)
		#else:
			#print("null")
		if floutwitch_1.inventory_data.slot_datas[inventory_interface.slot_row_selected]:
			
			var place_tile_value
			place_tile_value = Global.position_to_tile_value(get_global_mouse_position())
			if world_1.TileSlotDatas[place_tile_value]:
				
				if world_1.TileSlotDatas[place_tile_value].sub_state == "mown_land":
					
					if floutwitch_1.inventory_data.slot_datas[inventory_interface.slot_row_selected].item_data.name == "Seed":
						
						if world_1.TileSlotDatas[place_tile_value] == null:
							world_1.TileSlotDatas[place_tile_value].block_data = wheat_block
							world_1.TileSlotDatas[place_tile_value].state = wheat_tile.state
							
							var place_to_grow = get_global_mouse_position()
							var wheat = load(world_1.TileSlotDatas[place_tile_value].block_data.scene)
							var wheat_inst = wheat.instantiate()
							wheat_inst.pos = Global.tile_value_to_position(place_tile_value)
							wheat_inst.tile_value = place_tile_value
							all_tiles.add_child(wheat_inst)
							Global.slot_data_of_current_sellected_item.quantity -= 1
							$UI/InventoryInterface/Inventory.populate_item_grid(floutwitch_1.inventory_data)
						else:
							if world_1.TileSlotDatas[place_tile_value].state == "":
								world_1.TileSlotDatas[place_tile_value].block_data = wheat_block
								world_1.TileSlotDatas[place_tile_value].state = wheat_tile.state
								
								var place_to_grow = get_global_mouse_position()
								var wheat = load(world_1.TileSlotDatas[place_tile_value].block_data.scene)
								var wheat_inst = wheat.instantiate()
								wheat_inst.pos = Global.tile_value_to_position(place_tile_value)
								wheat_inst.tile_value = place_tile_value
								all_tiles.add_child(wheat_inst)
								Global.slot_data_of_current_sellected_item.quantity -= 1
								$UI/InventoryInterface/Inventory.populate_item_grid(floutwitch_1.inventory_data)
		#$wheat.pos = Global.tile_value_to_position(place_tile_value)
		
		#var random
		#
		#var witch_collum
		#
		#random = round(15 + get_global_mouse_position().x + 15 / 40)
		#witch_collum = round(15 + get_global_mouse_position().y / 40)
		#whole_value = random + round(witch_collum * collums)
		#print(get_global_mouse_position().x + get_global_mouse_position().y)
		#print(random)
		#print(whole_value)
	#if shop_ui:
	#	print("nvm")
	#if inventory_interface.chest_inventory_on == true:
		#inventory_interface.set_external_inventory_owner($chest)
		#inventory_interface.enable_chest_inventory()
	#if inventory_interface.chest_inventory_on == false:
		#inventory_interface.disable_chest_inventory()
	#inventory_interface.set_external_inventory_sell_owner($"UI/shop ui")
	
	for i in range(0, floutwitch_1.inventory_data.slot_datas.size()):
		if floutwitch_1.inventory_data.slot_datas[i]:
			floutwitch_1.inventory_data.slot_datas[i].resource_local_to_scene = true
			floutwitch_1.inventory_data.slot_datas[i].duplicate()
			

	
#	if $UI/InventoryInterface.grabbed_slot_data.item_data:
#		print($UI/InventoryInterface.grabbed_slot_data.item_data.name)
	#if Input.is_action_just_pressed("open_and_close_inventory"):
	#	if $InventoryInterface.visible == false:
	#		$InventoryInterface.visible = true
	#	if $InventoryInterface.visible == true:
	#		$InventoryInterface.visible 	


func _on_inventory_area_2d_mouse_entered() -> void:
	Global.in_inventory_area = true
	
	


func _on_inventory_area_2d_mouse_exited() -> void:
	Global.in_inventory_area = false
	


func _on_load_buttonw_down() -> void:
	SaveSystem._load()


func _on_save_button_down() -> void:
	SaveSystem.save()


func _on_leave_area_1_area_entered(area: Area2D) -> void:
	if area.is_in_group("floutwitch"):
		floutwitch_1.position = _01_02_transition.position
		%scene_2.visible = true
		%scene_1.visible = false


func _on_leave_area_2_area_entered(area: Area2D) -> void:
	if area.is_in_group("floutwitch"):
		floutwitch_1.position = _02_01_transition.position
		%scene_2.visible = false
		%scene_1.visible = true


func _on_load_button_down() -> void:
	pass # Replace with function body.
