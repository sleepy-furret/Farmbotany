extends Resource

class_name SlotData

const MAX_STACK_SIZE: int = 999

@export var item_data: ItemData
@export_range(1, MAX_STACK_SIZE) var quantity: int = 1: set = set_quantity


func can_merge_with(other_slot_data: SlotData):
	return item_data == other_slot_data.item_data \
			and item_data.stackable and quantity < MAX_STACK_SIZE


func can_fully_merge_with(other_slot_data: SlotData):
	return item_data == other_slot_data.item_data \
			and item_data.stackable and quantity + other_slot_data.quantity < MAX_STACK_SIZE

func fully_merge_with(other_slot_data: SlotData):
	quantity += other_slot_data.quantity
	

func create_single_slot_data() -> SlotData:
	var new_slot_data = duplicate()
	new_slot_data.quantity = 1
	quantity -= 1
	return new_slot_data

func set_item_data(item_name: String):
	if self.item_data:
		item_data.name = item_name

func set_quantity(value: int) -> void:
	quantity = value
	if quantity > 1 and item_data.stackable == false:
		quantity = 1
