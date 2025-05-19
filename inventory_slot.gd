extends Node2D

var mouse_in_area = false
@export var item: String

@onready var box_sprite: Sprite2D = %box_sprite
@onready var item_sprite: Sprite2D = %item_sprite

func _process(delta: float) -> void:
	
	if item == "":
		item_sprite.frame_coords.x = 0
	if item == "book":
		item_sprite.frame_coords.x = 1
	if item == "vsauce_face":
		item_sprite.frame_coords.x = 2
	if mouse_in_area == true and Input.is_action_just_pressed("click") and item != "":
		if Global.item_selected_mouse == "":
			Global.item_selected_mouse = item
			await get_tree().create_timer(1.1).timeout
			item = ""
		
	if mouse_in_area == true and Input.is_action_just_pressed("click") and item == "":
		item = Global.item_selected_mouse
		Global.item_selected_mouse = ""
		#print("if you can read this, it is working")
		

func _on_area_2d_mouse_entered() -> void:
	mouse_in_area = true


func _on_area_2d_mouse_exited() -> void:
	mouse_in_area = false
