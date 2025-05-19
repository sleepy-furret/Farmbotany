extends Control

var grabbed_slot_data: SlotData
var external_inventory_owner
var external_inventory_owner_sell

@onready var inventory: PanelContainer = $Inventory
@onready var grabbed_slot: PanelContainer = $grabbed_slot
@export var sell_inventory_data: InventoryData
@onready var external_inventory: PanelContainer = $ExternalInventory
@onready var external_inventory_sell: PanelContainer = %ExternalInventorySell
@onready var sellected_sprite: Sprite2D = %sellected_sprite
@onready var floutwitch_1: CharacterBody2D = %floutwitch1

var chest_inventory_on = false
var slots: Array
var slot_row_selected = 0

func _ready() -> void:
	slots = inventory.slots

func _process(delta: float) -> void:
	for i in range(0, floutwitch_1.inventory_data.slot_datas.size()):
		if floutwitch_1.inventory_data.slot_datas[i]:
			if floutwitch_1.inventory_data.slot_datas[i].quantity <= 0:
				
				floutwitch_1.inventory_data.slot_datas[i] = null
				inventory.populate_item_grid(floutwitch_1.inventory_data)
				
	if floutwitch_1.inventory_data.slot_datas[slot_row_selected]:
		Global.slot_data_of_current_sellected_item = floutwitch_1.inventory_data.slot_datas[slot_row_selected]
	else:
		Global.slot_data_of_current_sellected_item = null
	
	sellected_sprite.position.y = 20
	sellected_sprite.position.x = 21 + 43 * slot_row_selected + 1 - 1.35 * slot_row_selected
	if Input.is_action_pressed("scroll_up") or Input.is_action_just_pressed("pg_up"):
		
		slot_row_selected += 1
	if Input.is_action_pressed("scroll_down") or Input.is_action_just_pressed("pg_down"):
		slot_row_selected -= 1
	if slot_row_selected >= 12:
		slot_row_selected = 0
	if slot_row_selected <= -1:
		slot_row_selected = 11
	

func _physics_process(delta: float) -> void:
	
	if grabbed_slot_data:
		if grabbed_slot_data.quantity <= 0:
			grabbed_slot_data = null
			update_grabbed_slot()
		
		#print(grabbed_slot_data.item_data.name)
	if grabbed_slot.visible:
		grabbed_slot.position = get_global_mouse_position() + Vector2(5, 5)

func set_player_inventory_data(inventory_data: InventoryData) -> void:
	inventory_data.inventory_interact.connect(on_inventory_interact)
	inventory.set_inventory_data(inventory_data)

func set_external_inventory_owner(_external_inventory_owner):
	external_inventory_owner = _external_inventory_owner
	var inventory_data = external_inventory_owner.inventory_data
	
	inventory_data.inventory_interact.connect(on_inventory_interact)
	external_inventory.set_inventory_data(inventory_data)
	
	external_inventory.show()


func set_external_inventory_sell_owner(_external_inventory_owner_sell):
	external_inventory_owner_sell = _external_inventory_owner_sell
	var inventory_data_sell = external_inventory_owner_sell.inventory_data
	
	inventory_data_sell.inventory_interact.connect(on_inventory_interact)
	external_inventory_sell.set_inventory_data(inventory_data_sell)
	
	external_inventory_sell.show()


func enable_chest_inventory():
	external_inventory.position = Vector2(495.0, 42.0)

func disable_chest_inventory():
	external_inventory.position = Vector2(995.0, 942.0)

func on_inventory_interact(inventory_data: InventoryData, index: int, button: int):
	match [grabbed_slot_data, button]:
		[null, MOUSE_BUTTON_LEFT]:
			grabbed_slot_data = inventory_data.grab_slot_data(index)
		[_, MOUSE_BUTTON_LEFT]:
			grabbed_slot_data = inventory_data.drop_slot_data(grabbed_slot_data, index)
		[null, MOUSE_BUTTON_RIGHT]:
			pass
		[_, MOUSE_BUTTON_RIGHT]:
			grabbed_slot_data = inventory_data.drop_single_slot_data(grabbed_slot_data, index)
	
	update_grabbed_slot()

func update_grabbed_slot():
	if grabbed_slot_data:
		grabbed_slot.show()
		grabbed_slot.set_slot_data(grabbed_slot_data)
	else:
		grabbed_slot.hide()
