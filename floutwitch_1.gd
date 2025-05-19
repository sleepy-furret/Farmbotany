extends CharacterBody2D

var speed = 200
var accel = 20

@export var inventory_data: InventoryData

@onready var player_sprite: Sprite2D = $player_sprite
@onready var player_eyes: Sprite2D = $player_eyes
@onready var animation_player: AnimationPlayer = $player_sprite/AnimationPlayer
@onready var animation_playerflip: AnimationPlayer = $player_sprite/AnimationPlayerflip
@onready var inventory_interface: Control = $"../UI/InventoryInterface"
@onready var gun_point: Marker2D = %gun_point

const MINI_CAT = preload("res://mini_cat.tscn")

var state = ""

func _ready() -> void:
	if get_global_mouse_position().x > position.x:
		
		state = "right"
	if get_global_mouse_position().x < position.x:
		
		state = "left"
		

func _physics_process(delta: float) -> void:
	if Global.player_can_move == true:
		var direction = Input.get_vector("move_left","move_right","move_up","move_down")
		
		
		velocity.x = move_toward(velocity.x, speed * direction.x, accel)
		velocity.y = move_toward(velocity.y, speed * direction.y, accel)
		
		move_and_slide()
		
	if get_global_mouse_position().x > position.x and state == "left":
		animation_playerflip.play("flip_left")
		state = "right"
		await animation_playerflip.animation_finished
		animation_player.play("idle")
	if get_global_mouse_position().x < position.x and state == "right":
		animation_playerflip.play("flip")
		state = "left"
		await animation_playerflip.animation_finished
		animation_player.play("idle")

var continue_instanciating = true
var continue_instanciating2 = true

func _process(delta: float) -> void:
	var mini_cat_int = MINI_CAT.instantiate()
	var in_mouse_selection = false
	var in_bar_selection = false
	
	if inventory_data.slot_datas[inventory_interface.slot_row_selected] and continue_instanciating == true:
		if continue_instanciating == true:
			if inventory_data.slot_datas[inventory_interface.slot_row_selected].item_data.name == "Mini-cat":
				Global.weapon_erase = false
				print("1")
				continue_instanciating = false
				add_child(mini_cat_int)
			else:
				if in_mouse_selection == false:
					continue_instanciating = true
					Global.weapon_erase = true
	if inventory_data.slot_datas[inventory_interface.slot_row_selected] and inventory_data.slot_datas[inventory_interface.slot_row_selected].item_data.name == "Mini-cat":
		in_bar_selection = true
	else:
		in_bar_selection = false
	if inventory_interface.grabbed_slot_data and inventory_interface.grabbed_slot_data.item_data.name == "Mini-cat":
		in_mouse_selection = true
		print("hi3")
	else:
		in_mouse_selection = false
	if inventory_data.slot_datas[inventory_interface.slot_row_selected] == null and in_mouse_selection == false:
		continue_instanciating = true
		Global.weapon_erase = true
		await get_tree().create_timer(0.01).timeout
		Global.weapon_erase = false
	elif inventory_data.slot_datas[inventory_interface.slot_row_selected] and inventory_data.slot_datas[inventory_interface.slot_row_selected].item_data.name != "Mini-cat" and in_mouse_selection == false:
		continue_instanciating = true
		Global.weapon_erase = true
		await get_tree().create_timer(0.01).timeout
		Global.weapon_erase = false
	if inventory_interface.grabbed_slot_data and continue_instanciating2 == true:
		if inventory_interface.grabbed_slot_data.item_data.name == "Mini-cat":
			Global.weapon_erase = false
			print("2")
			continue_instanciating2 = false
			add_child(mini_cat_int)
			mini_cat_int.position = gun_point.position
			in_mouse_selection = true
		else:
			
			if in_bar_selection == false:
				continue_instanciating2 = true
				Global.weapon_erase = true
				in_mouse_selection = false
	if inventory_interface.grabbed_slot_data == null and in_bar_selection == false:
		continue_instanciating2 = true
		Global.weapon_erase = true
