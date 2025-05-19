extends CharacterBody2D

var pos: Vector2
var rota: float
var dir: float
var speed = 2000

func _ready() -> void:
	global_position = pos
	global_rotation = rota 

func _physics_process(delta: float) -> void:
	velocity = Vector2(speed, 0).rotated(dir)
	move_and_slide()




#const SPEED: int = 1000
#
## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass
	#position = get_parent().position
	#look_at(get_global_mouse_position())
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _physics_process(delta: float) -> void:
	#print(rotation)
	##var direction = 6
	##print(direction)
	##
	##velocity.x = move_toward(velocity.x, SPEED * direction, 10)
	###velocity.y = move_toward(velocity.y, SPEED * direction.y, 10)
	##
	##move_and_slide()
	##
	##
	#
	#velocity = Vector2(1, 0).rotated(rotation) * SPEED
	#move_and_slide()
	##position += position * SPEED
	##
	##


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("fence_notifiers"):
		queue_free()
	


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
