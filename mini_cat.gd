extends Node2D

const BULLET = preload("res://bullet.tscn")

@onready var animation_playerflip: AnimationPlayer = $"mini-cat-sprite/animation playerflip"
@onready var bullet_point: Marker2D = $bullet_point
@onready var shot_time: Timer = %shot_time
var state = ""

#func _ready() -> void:
	#if get_global_mouse_position().x > get_parent().position.x:
		#
		#state = "right"
		#
	#if get_global_mouse_position().x < get_parent().position.x:
		#print("ÇLAKJFÇLKJFÇLKJ")
		#state = "left"
		#

func _physics_process(delta: float) -> void:
	#
	#if get_global_mouse_position().x > get_parent().position.x and state == "left":
		#animation_playerflip.play("flip_left")
		#state = "right"
		#print("ÇLAKJFÇLKJFÇLKJ")
		##await animation_playerflip.animation_finished
		#
	#if get_global_mouse_position().x < get_parent().position.x and state == "right":
		#animation_playerflip.play("flip")
		#state = "left"
		#print("ÇLAKJFÇLKJFÇLKJ")
		##await animation_playerflip.animation_finished
		#
	#
	position = get_parent().gun_point.position
	look_at(get_global_mouse_position())
	if Global.weapon_erase == true:
		queue_free()
		Global.weapon_erase = false

	rotation_degrees = wrap(rotation_degrees, 0, 360)
	if rotation_degrees > 90 and rotation_degrees < 270:
		scale.y = -1
	else:
		scale.y = 1
	if Input.is_action_pressed("click") and shot_time.time_left == 0 and Global.in_inventory_area == false:
		shot_time.start()
		var bullet_inst = BULLET.instantiate()
		bullet_inst.dir = rotation
		bullet_inst.pos = bullet_point.global_position
		bullet_inst.rota = rotation
		get_parent().add_child(bullet_inst)
		#bullet_inst.position = bullet_point.position
		#bullet_inst.rotation = rotation

func erase():
	queue_free()


func _on_shot_time_timeout() -> void:
	pass
