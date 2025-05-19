extends Node2D

#dsssssssssssssss@onready var shop_ui: Control = get_parent().shop_ui
@onready var shop_ui: Control = $"../../UI/shop ui"
var mouse_on_area = false
@onready var inventory_interface: Control = $"../../UI/InventoryInterface"
@onready var external_inventory_sell: PanelContainer = %ExternalInventorySell
@onready var sell_inventory_visible: Control = %SellInventoryVisible
@onready var floutwitch_1: CharacterBody2D = %floutwitch1

func _process(delta: float) -> void:
	if Global.player_left_shop:
		shop_ui.in_shop = false
	if mouse_on_area == true:
		inventory_interface.set_external_inventory_sell_owner(shop_ui)

func _on_area_2d_area_entered(area: Area2D) -> void:
	
	if area.is_in_group("floutwitch"):
		floutwitch_1
		shop_ui.visible = true
		Global.player_can_move = false
		shop_ui.in_shop = true
		#sell_inventory_visible.visible = true
		mouse_on_area = true


func _on_area_2d_area_exited(area: Area2D) -> void:
	
	if area.is_in_group("floutwitch"):
		shop_ui.visible = false
		sell_inventory_visible.visible = false
		mouse_on_area = true
		Global.player_left_shop = true
