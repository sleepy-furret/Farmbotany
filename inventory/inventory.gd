extends PanelContainer

const SLOT = preload("res://inventory/slot.tscn")
var invdata = preload("res://inventory/test_inventory.tres")
@onready var grid_container: GridContainer = $MarginContainer/GridContainer

var slots: Array
var slot_row_selected = 0

#var slots: int = 0
#@export var scene: String

func _ready() -> void:
	
	await get_tree().create_timer(0.1).timeout
	slots = grid_container.get_children()
	#populate_item_grid(invdata.slot_datas)

func _process(delta: float) -> void:
	pass
	#slots = grid_container.get_children()


func set_inventory_data(inventory_data: InventoryData) -> void:
	inventory_data.inventory_update.connect(populate_item_grid)
	populate_item_grid(inventory_data)

func populate_item_grid(inventory_data: InventoryData)  -> void:
	for child in grid_container.get_children():
		child.queue_free()
	
	for slot_data in inventory_data.slot_datas:
		var slot = SLOT.instantiate()
		grid_container.add_child(slot)
		#slot.slot_number = slots
		#slots += 1
		slot.slot_clicked.connect(inventory_data.on_slot_clicked)
		
		if slot_data:
			slot.set_slot_data(slot_data)
			
	
