extends Resource

class_name InventoryData

signal inventory_update(inventory_data: InventoryData)
signal inventory_interact(inventory_data: InventoryData, index: int, button: int)

@export var slot_datas: Array[SlotData]

func grab_slot_data(index: int):
	var slot_data = slot_datas[index]
	
	if slot_data:
		slot_datas[index] = null
		inventory_update.emit(self)
		return slot_data
	else:
		return null

func drop_slot_data(grabbed_slot_data: SlotData, index: int):
	var slot_data = slot_datas[index]
	
	var return_slot_data: SlotData
	
	if slot_data and slot_data.can_fully_merge_with(grabbed_slot_data):
		slot_data.fully_merge_with(grabbed_slot_data)
	else:
		slot_datas[index] = grabbed_slot_data
		return_slot_data =slot_data
	
	inventory_update.emit(self)
	return return_slot_data
	#slot_datas[index] = grabbed_slot_data
	#inventory_update.emit(self)
	#
	#if slot_data:
		#return slot_data
	#else:
		#return null

func drop_single_slot_data(grabbed_slot_data: SlotData, index: int):
	var slot_data = slot_datas[index]
	
	if not slot_data:
		slot_datas[index] = grabbed_slot_data.create_single_slot_data()
	elif slot_data.can_merge_with(grabbed_slot_data):
		slot_data.fully_merge_with(grabbed_slot_data.create_single_slot_data())
	
	inventory_update.emit(self)
	
	if grabbed_slot_data.quantity > 0:
		return grabbed_slot_data
	else:
		return null


var allready_appeared = false


func pick_up_slot_data(slot_data: SlotData):
	var yet_another_slot_data
	yet_another_slot_data = slot_data
	yet_another_slot_data
	for index in slot_datas.size():
		if slot_datas[index] and slot_datas[index].can_fully_merge_with(yet_another_slot_data) and allready_appeared == false:
			
			slot_datas[index].fully_merge_with(slot_data)
			allready_appeared = true
			inventory_update.emit(self)
	
	
	for index in range(0, slot_datas.size()):
		if allready_appeared == false:
			if slot_datas[index] == null and allready_appeared == false:
				if allready_appeared == false:
					
					allready_appeared = true
					slot_data.duplicate()
					slot_data.resource_local_to_scene = true
					slot_datas[index] = yet_another_slot_data
					slot_datas[index].duplicate()
					slot_datas[index].resource_local_to_scene = true
					slot_data.duplicate()
					yet_another_slot_data.resource_local_to_scene = true
					yet_another_slot_data.duplicate()
					inventory_update.emit(self)
					#print("hi")
				
	
	allready_appeared = false
	yet_another_slot_data = null
	

func on_slot_clicked(index: int, button: int):
	inventory_interact.emit(self, index, button)
