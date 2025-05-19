extends Control

signal toggle_inventory(external_inventory_owner)

@export var inventory_data: InventoryData
@onready var external_inventory_sell: PanelContainer = %ExternalInventorySell
var on_which_screen: String = ""
@onready var sell_options: Control = %sell_options
@onready var sellect_options: Control = $sellect_options
var screen_update = false
@onready var sell_inventory_visible: Control = %SellInventoryVisible
@onready var buy_options: Control = $buy_options
@onready var shop_area: Area2D = %shop_area
@onready var shop_area_collision: CollisionShape2D = $shop_area/CollisionShape2D

var in_shop = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false

func player_interact():
	toggle_inventory.emit(self)

func _process(delta: float) -> void:
	
	if in_shop == false:
		shop_area_collision.disabled = true
	else:
		shop_area_collision.disabled = false
	if Global.player_left_shop == true:
		%sell_options.visible = false
		sellect_options.visible = true
		sell_inventory_visible.visible = false
		Global.player_left_shop = false
		buy_options.visible = false

func _on_button_button_down() -> void:
	if inventory_data.slot_datas[0]:
		Global.money += inventory_data.slot_datas[0].item_data.value * inventory_data.slot_datas[0].quantity
		inventory_data.slot_datas[0] = null


func _on_sell_option_button_down() -> void:
	on_which_screen = "sell"
	%sell_options.visible = true
	sellect_options.visible = false
	sell_inventory_visible.visible = true
	buy_options.visible = false


func _on_buy_option_button_down() -> void:
	%sell_options.visible = false
	sellect_options.visible = false
	sell_inventory_visible.visible = false
	buy_options.visible = true


func _on_back_button_button_down() -> void:
	var button_pressed = false
	if sell_options.visible == true and button_pressed == false:
		%sell_options.visible = false
		sellect_options.visible = true
		sell_inventory_visible.visible = false
		buy_options.visible = false
		button_pressed = true
		
	if sellect_options.visible == true and button_pressed == false:
		visible = false
		%sell_options.visible = false
		sellect_options.visible = false
		sell_inventory_visible.visible = false
		button_pressed = true
		
		Global.player_can_move = true
	if buy_options.visible == true:
		%sell_options.visible = false
		sellect_options.visible = true
		sell_inventory_visible.visible = false
		buy_options.visible = false
	button_pressed = false


func _on_shop_area_mouse_entered() -> void:
	if in_shop == true:
		Global.in_inventory_area = true
	

func _on_shop_area_mouse_exited() -> void:
	if in_shop == true:
		Global.in_inventory_area = false
		pass
