extends CharacterBody2D

var target = Vector2.ZERO
var speed = 10.0
var width = 0
var time_highlight = 0.4
var time_highlight_size = 0.3
var tween

func _ready():
	width = $CollisionShape2D.get_shape().get_size().x
	target = Vector2(Global.VP.x, Global.VP.y - 60)

func _physics_process(_delta):
	target.x = clamp(target.x, 0 + width/2, Global.VP.x - width/2)
	position = target

func _input(event):
	if event is InputEventMouseMotion:
		target.x += event.relative.x

func hit(_ball):
	var Paddle_Sound = get_node("/root/Game/Paddle_Sound")
	Paddle_Sound.play()
	$Confetti.emitting = true
	if tween:
		tween.kill()
	tween = create_tween().set_parallel(true)
	$Images/Highlight.modulate.a = 1.0
	tween.tween_property($Images/Highlight, "modulate:a", 0.0, time_highlight)
	$Images/Highlight.scale = Vector2(2.0,2.0)
	tween.tween_property($Images/Highlight, "scale", Vector2(1.0,1.0), time_highlight_size).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_IN)
