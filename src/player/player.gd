extends CharacterBody2D


const SPEED = 100.0
const DASH_SPEED = 700.0
var direction := Vector2.ZERO
var is_attack := false
var is_attack_cooldown := false
var is_dash := false
var is_dash_cooldown := false
var is_end_coolown := false

func _ready() -> void:
	pass
	
func _animation() -> void:
	if(is_attack):
		$AnimationPlayer.play("attack")
		return
	if(velocity.length() != 0):
		if(is_dash):
			$AnimationPlayer.play("dash")
			return
		
		$AnimationPlayer.play("walk")
		if(velocity.x != 0):
			$Sprite2D.flip_h = velocity.x < 0
		return
	$AnimationPlayer.play("idle")

func _process(_delta: float) -> void:
	_animation()

func _physics_process(delta: float) -> void:
	if(not is_attack and not is_dash):
		direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if(Input.is_action_just_pressed("ui_attack") and  not is_attack_cooldown and not is_attack):
		is_attack = true
		$AttackTimer.start(0.4)
		direction = Vector2.ZERO
	
	if(Input.is_action_just_pressed("ui_accept") and not is_dash and not is_dash_cooldown):
		is_dash = true
		$DashSprite2D.rotation = velocity.angle()
		$DashTimer.start(0.1)
		
	
	velocity = direction * (DASH_SPEED if is_dash else SPEED)
	velocity.normalized()

	move_and_slide()


func _on_attack_timer_timeout() -> void:
	is_attack = false
	is_attack_cooldown = true
	$AttackCooldownTimer.start(1)

func _on_attack_cooldown_timer_timeout() -> void:
	is_attack_cooldown = false


func _on_dash_timer_timeout() -> void:
	$Sprite2D.rotation = 0
	is_dash = false
	is_dash_cooldown = true
	$DashCoolDownTimer.start(1)


func _on_dash_cool_down_timer_timeout() -> void:
	is_dash_cooldown = false
	
