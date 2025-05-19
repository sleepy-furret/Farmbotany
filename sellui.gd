extends Control

@export var inventory_data_sell: InventoryData
@onready var inventorysell: PanelContainer = $Inventorysell

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	inventorysell.set_inventory_data(inventory_data_sell)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	inventorysell.populate_item_grid(inventory_data_sell)
