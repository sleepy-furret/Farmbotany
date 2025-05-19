extends Panel

@export var product_data: ProductData

@onready var texture_rect: TextureRect = %TextureRect
@onready var price: Label = %Price
@onready var floutwitch_1: CharacterBody2D = %floutwitch1

func _ready() -> void:
	texture_rect.texture = product_data.item_data.item_data.texture
	price.text = str(product_data.value)


func _on_button_button_down() -> void:
	if Global.money >= product_data.value:
		product_data.item_data = product_data.item_data.duplicate()
		product_data.item_data.resource_local_to_scene = true
		product_data.item_data.duplicate()
		
		Global.money -= product_data.value
		get_parent().get_parent().get_parent().get_parent().get_parent().floutwitch_1.inventory_data.pick_up_slot_data(product_data.item_data)
		
		product_data.item_data.item_data.resource_local_to_scene = true
		product_data.item_data.item_data.duplicate()
