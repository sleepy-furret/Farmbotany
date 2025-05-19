extends Node

var config = ConfigFile.new()

@onready var floutwitch_1: CharacterBody2D = $"/root/main_scene/floutwitch1"
@onready var main_scene: Node2D = $"/root/main_scene"
@onready var shop_ui: Control = $"/root/main_scene/UI/shop ui"
@onready var time_system: Node = $"/root/TimeSystem"

@export var seed: SlotData
@export var wheat: SlotData
@export var book: SlotData
@export var mini_cat: SlotData

@export var generic_tile: TileSlotData
@export var wheat_tile: TileSlotData

var game_saved = false
var game_loaded = false

func save():
	game_saved = true
	for i in range(0, floutwitch_1.inventory_data.slot_datas.size()):
		
		if floutwitch_1.inventory_data.slot_datas[i]:
			
			for f in range(0, main_scene.world_1.TileSlotDatas.size()):
				var tile_array = main_scene.world_1.TileSlotDatas
				if tile_array[f]:
					config.set_value("tile" + str(f), "state", tile_array[f].state)
					config.set_value("tile" + str(f), "sub_state", tile_array[f].sub_state)
				else:
					config.set_value("tile" + str(f), "state", "null")
			
			
			config.set_value("slot" + str(i), \
						"name", floutwitch_1.inventory_data.slot_datas[i].item_data.name)
			#config.set_value("slot" + str(floutwitch_1.inventory_data.slot_datas[i].index), \
						#"name", floutwitch_1.inventory_data.slot_datas[i].slot_data.item_data.name)
			config.set_value("slot" + str(i), \
						"quantity", floutwitch_1.inventory_data.slot_datas[i].quantity)
		else:
			config.set_value("slot" + str(i), \
						"name", "")
			
			config.set_value("slot" + str(i), \
						"quantity", 0)
			pass
		#config.set_value("player", "y", )
	if shop_ui.inventory_data.slot_datas[0]:
		config.set_value("sell_inventory_slot0", "name", shop_ui.inventory_data.slot_datas[0].item_data.name)
		config.set_value("sell_inventory_slot0", "quantity", shop_ui.inventory_data.slot_datas[0].quantity)
	config.set_value("player_stats", "money", Global.money)
	config.set_value("time_stats", "current_time", time_system.seconds_past)
	config.set_value("time_stats", "hour", time_system.hour)
	config.set_value("time_stats", "second", time_system.second)
	config.save("res://savegame.cfg")
	await get_tree().create_timer(0.01).timeout
	game_saved = false

func _load():
	game_loaded = true
	var err = config.load("res://savegame.cfg")
	if err == OK:
		for i in range(0, floutwitch_1.inventory_data.slot_datas.size()):
			if config.get_value("slot" + str(i), "name"):
				nullify()
				
				#print(config.get_value("slot" + str(i), "name"))
				#print(config.get_value("slot" + str(i), "quantity"))
				if config.get_value("slot" + str(i), "name") == "Seed": 
					
					seed = seed.duplicate()
					floutwitch_1.inventory_data.slot_datas[i] = seed
					floutwitch_1.inventory_data.slot_datas[i].quantity = config.get_value("slot" + str(i), "quantity")
					
				if config.get_value("slot" + str(i), "name") == "Book":
					
					book = book.duplicate()
					floutwitch_1.inventory_data.slot_datas[i] = book
					floutwitch_1.inventory_data.slot_datas[i].quantity = config.get_value("slot" + str(i), "quantity")
					
				if config.get_value("slot" + str(i), "name") == "Wheat": 
					
					wheat = wheat.duplicate()
					floutwitch_1.inventory_data.slot_datas[i] = wheat
					floutwitch_1.inventory_data.slot_datas[i].quantity = config.get_value("slot" + str(i), "quantity")
				if config.get_value("slot" + str(i), "name") == "Mini-cat": 
					
					mini_cat = mini_cat.duplicate()
					floutwitch_1.inventory_data.slot_datas[i] = mini_cat
					if floutwitch_1.inventory_data.slot_datas[i].item_data.stackable == true:
						floutwitch_1.inventory_data.slot_datas[i].quantity = Global.config.get_value("slot" + str(i), "quantity")
					
				
				#floutwitch_1.inventory_data.slot_datas[i].set_item_data(config.get_value("slot" + str(i), "name"))
				#floutwitch_1.inventory_data.slot_datas[i].item_data.name = config.get_value("slot" + str(i), "name")
				#floutwitch_1.inventory_data.slot_datas[i].quantity = config.get_value("slot" + str(i), "quantity")
				#floutwitch_1.inventory_data.inventory_update.emit("res://inventory/test_inventory.tres")
				floutwitch_1.inventory_data.inventory_update.emit("res://inventory/test_inventory.tres")
				floutwitch_1.inventory_data.inventory_interact.emit(floutwitch_1.inventory_data, i, i)
				$/root/main_scene/UI/InventoryInterface/Inventory.populate_item_grid(floutwitch_1.inventory_data)
			else:
				
				if config.get_value("slot" + str(i), "name") == "": 
					floutwitch_1.inventory_data.slot_datas[i] = null
					
					
				floutwitch_1.inventory_data.inventory_update.emit("res://inventory/test_inventory.tres")
				floutwitch_1.inventory_data.inventory_interact.emit(floutwitch_1.inventory_data, i, i)
				$/root/main_scene/UI/InventoryInterface/Inventory.populate_item_grid(floutwitch_1.inventory_data)
				
				
				#floutwitch_1.inventory_data.slot_datas[i].item_data.name = ""
				#floutwitch_1.inventory_data.slot_datas[i].quantity = 0
				#floutwitch_1.inventory_data.inventory_update.emit("res://inventory/test_inventory.tres")
				
		if config.get_value("sell_inventory_slot0", "name"):
			if config.get_value("sell_inventory_slot0", "name") == "Seed": 
				
				seed = seed.duplicate()
				shop_ui.inventory_data.slot_datas[0] = seed
				shop_ui.inventory_data.slot_datas[0].quantity = config.get_value("sell_inventory_slot0", "quantity")
				
			if config.get_value("sell_inventory_slot0", "name") == "Book":
				
				book = book.duplicate()
				shop_ui.inventory_data.slot_datas[0] = book
				shop_ui.inventory_data.slot_datas[0].quantity = config.get_value("sell_inventory_slot0", "quantity")
				
			if config.get_value("sell_inventory_slot0", "name") == "Mini-cat": 
				
				mini_cat = mini_cat.duplicate()
				shop_ui.inventory_data.slot_datas[0] = mini_cat
				if shop_ui.inventory_data.slot_datas[0].item_data.stackable == true:
					shop_ui.inventory_data.slot_datas[0].quantity = config.get_value("sell_inventory_slot0", "quantity")
			shop_ui.inventory_data.inventory_update.emit("res://inventory/test_inventory.tres")
			shop_ui.inventory_data.inventory_interact.emit(floutwitch_1.inventory_data, 0, 0)
			$/root/main_scene/UI/InventoryInterface/SellInventoryVisible/ExternalInventorySell.populate_item_grid(shop_ui.inventory_data)
			
		else:
			
			if config.get_value("sell_inventory_slot0", "name") == "": 
				shop_ui.inventory_data.slot_datas[0] = null
				
		for child in main_scene.all_tiles.get_children():
			child.queue_free()
		var tile_array = main_scene.world_1.TileSlotDatas
		for f in range(0, tile_array.size()):
			
			if config.get_value("tile" + str(f), "state") == "":
				generic_tile.duplicate()
				tile_array[f] = generic_tile
				if config.get_value("tile" + str(f), "substate"):
					tile_array[f].sub_state = config.get_value("tile" + str(f), "substate")
				else:
					tile_array[f].sub_state = ""
				generic_tile.duplicate()
				tile_array[f].duplicate()
			if config.get_value("tile" + str(f), "state") == "Wheat":
				wheat_tile.duplicate()
				tile_array[f] = wheat_tile
				if config.get_value("tile" + str(f), "substate"):
					tile_array[f].sub_state = config.get_value("tile" + str(f), "substate")
				else:
					tile_array[f].sub_state = ""
				wheat_tile.duplicate()
				tile_array[f].duplicate()
				var scene_name = load(tile_array[f].block_data.scene)
				var scene_inst = scene_name.instantiate()
				main_scene.all_tiles.add_child(scene_inst)
				var place_position = Vector2(0,0)
				place_position = Global.tile_value_to_position(f)
				scene_inst.tile_value = f
				scene_inst.pos = place_position
				
		
		
		Global.money = config.get_value("player_stats", "money")
		if config.get_value("time_stats", "current_time"):
			time_system.seconds_past = config.get_value("time_stats", "current_time")
		if config.get_value("time_stats", "hour"):
			time_system.hour = config.get_value("time_stats", "hour")
		if config.get_value("time_stats", "hour"):
			time_system.second = config.get_value("time_stats", "second")
	await get_tree().create_timer(0.1).timeout
	game_loaded = false

func nullify():
	for i in range(0, floutwitch_1.inventory_data.slot_datas.size()):
		floutwitch_1.inventory_data.slot_datas[i]
