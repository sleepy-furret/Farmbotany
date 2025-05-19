extends Node

var item_selected_mouse: String = ""
var in_inventory_area = false
@onready var inventory_interface: Control = $UI/InventoryInterface
var config = ConfigFile.new()
var player_left_shop = false

var money = 0
var player_can_move = true
var slot_data_of_current_sellected_item: SlotData
var scene = 1
var weapon_erase = false

var collums = 112

var offset_x = 30
var offset_y = 30

func can_spawn_tile(state: String, substate: String, tile):
	return substate == "substate" and Input.is_action_just_pressed("click") and inventory_interface.grabbed_slot_data.item_data.name == state and tile.mouse_on_area == true and tile.state == "" and Global.in_inventory_area == false
	

func position_to_tile_value(position: Vector2) -> int:
	var random
	var whole_value
	var witch_collum
	
	random = round(offset_x + position.x / 40)
	witch_collum = round(offset_y + position.y / 40)
	whole_value = random + round(witch_collum * collums)
	#print(get_global_mouse_position().x + get_global_mouse_position().y)
	#print(random)
	return whole_value

func tile_value_to_position(tile_value: int) -> Vector2:
	var random
	var whole_value: Vector2
	var witch_collum
	
	witch_collum = round(tile_value / collums)
	random = tile_value - witch_collum * collums
	random -= offset_x
	witch_collum -= offset_y
	
	#var random2
	#random2 = witch_collum * collums
	#print(random2, " açlkjadf")
	whole_value.x = random * 40
	whole_value.y = witch_collum * 40
	
	#random = offset_x - tile_value * 40
	#witch_collum = offset_y - tile_value * 40
	#whole_value = random + round(witch_collum * collums)
	#print(get_global_mouse_position().x + get_global_mouse_position().y)
	#print(random)
	return whole_value
