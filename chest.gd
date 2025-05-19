extends Node2D

signal toggle_inventory(external_inventory_owner)

var mouse_on_area = false
var allready_on = false

@export var inventory_data: InventoryData
@onready var inventory_interface: Control = $"../UI/InventoryInterface"

func _process(delta: float) -> void:
	
	if mouse_on_area == true and Input.is_action_just_pressed("click") and inventory_interface.chest_inventory_on == false and allready_on == false:
		inventory_interface.chest_inventory_on = true
		allready_on = true
	if mouse_on_area == true and Input.is_action_just_pressed("click") and inventory_interface.chest_inventory_on == true and allready_on == false:
		inventory_interface.chest_inventory_on = false
		allready_on = true
	allready_on = false

func player_interact():
	toggle_inventory.emit(self)


func _on_area_2d_mouse_entered() -> void:
	
	mouse_on_area = true
	


func _on_area_2d_mouse_exited() -> void:
	
	mouse_on_area = false
	
