extends PanelContainer

signal slot_clicked(index: int, button: int)

@onready var texture_rect: TextureRect = $MarginContainer/TextureRect
@onready var quantity: Label = $Quantity
#@export var slot_number: int


func _process(delta: float) -> void:
	pass

#
#func save():
	#if get_parent().
	#Global.config.set_value("slot + St", "x", )
	#Global.config.set_value("player", "y", )
	#Global.config.save("res://savegame.cfg")
#
#func _load():
	#var err = Global.config.load("res://savegame.cfg")
	#if err == OK:
		##character_body_2d.position.x = Global.config.get_value("player", "x")
		##character_body_2d.position.y = Global.config.get_value("player", "y")


func set_slot_data(slot_data: SlotData) -> void:
	var item_data = slot_data.item_data
	texture_rect.texture = item_data.texture
	tooltip_text = "%s\n%s" % [item_data.name, item_data.description]
	
	
	if item_data == null:
		pass
	
	if slot_data.quantity > 1:
		quantity.text = str(slot_data.quantity)
		quantity.show()
	else:
		quantity.hide()


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton \
			and (event.button_index == MOUSE_BUTTON_LEFT \
			or event.button_index == MOUSE_BUTTON_RIGHT) \
			and event.is_pressed():
		slot_clicked.emit(get_index(), event.button_index)
		

func spotlight():
	%Sprite2D.frame_coords.x = 182

func un_spotlight():
	%Sprite2D.frame_coords.x = 183
