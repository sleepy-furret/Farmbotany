extends Node2D

@onready var inventory_slot_1: Node2D = %inventory_slot1
@onready var inventory_slot_2: Node2D = %inventory_slot2
@onready var inventory_slot_3: Node2D = %inventory_slot3
var inventory_slot_selected = 1
@onready var inventory_slot_selected_path = %inventory_slot1

func _process(delta: float) -> void:
	
	
	if inventory_slot_selected > 3:
		inventory_slot_selected = 1
	if inventory_slot_selected < 1:
		inventory_slot_selected = 3

	if Input.is_key_pressed(KEY_1):
		
		inventory_slot_selected = 1
	if Input.is_key_pressed(KEY_2):
		
		inventory_slot_selected = 2
	if Input.is_key_pressed(KEY_3):
		
		inventory_slot_selected = 3

	if inventory_slot_selected == 1:
		inventory_slot_selected_path = %inventory_slot1
		inventory_slot_1.box_sprite.frame_coords.y = 1
		inventory_slot_2.box_sprite.frame_coords.y = 0
		inventory_slot_3.box_sprite.frame_coords.y = 0
	if inventory_slot_selected == 2:
		inventory_slot_selected_path = %inventory_slot2
		inventory_slot_1.box_sprite.frame_coords.y = 0
		inventory_slot_2.box_sprite.frame_coords.y = 1
		inventory_slot_3.box_sprite.frame_coords.y = 0
	if inventory_slot_selected == 3:
		inventory_slot_selected_path = %inventory_slot3
		inventory_slot_1.box_sprite.frame_coords.y = 0
		inventory_slot_2.box_sprite.frame_coords.y = 0
		inventory_slot_3.box_sprite.frame_coords.y = 1
