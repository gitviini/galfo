extends CharacterBody2D

const SPEED = 20.0
const ATTACK_SPEED = 100.0
@export var target : CharacterBody2D = null
var direction := Vector2.ZERO
var is_attack := false
var is_cooldown := false

func _ready() -> void:
	pass

func _animation() -> void:
	if(is_attack and not is_cooldown):
		$AnimationPlayer.play("attack")
	elif(velocity.length() != 0):
		$Sprite2D.flip_h = velocity.x < 0
		if($AnimationPlayer.current_animation != "idle"):
			$AnimationPlayer.play("idle")
func _process(_delta: float) -> void:
	_animation()

func _physics_process(delta: float) -> void:
	if (not target):
		return
	
	direction = (target.global_position - global_position).limit_length(1)
	
	#direction.x = Input.get_axis("ui_left", "ui_right")
	velocity = direction * (ATTACK_SPEED if is_attack else SPEED)
		
	#velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _on_attack_timer_timeout() -> void:
	is_attack = false
	is_cooldown = true
	$CooldownTimer.start(1)


func _on_cooldown_timer_timeout() -> void:
	is_cooldown = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	if(target):
		if(body.name == target.name and is_cooldown == false):
			is_attack = true
			$AttackTimer.start(0.5)
