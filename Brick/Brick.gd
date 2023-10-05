extends StaticBody2D

var score = 0
var new_position = Vector2.ZERO
var dying = false
var time_appear = 0.5
var time_fall = 0.8
var time_rotate = 1.0
var time_a = 0.8
var time_s = 1.2
var time_v = 1.5

var sway_amplitude = 3.0
var sway_initial_position = Vector2.ZERO
var sway_randomizer = Vector2.ZERO

var color_index = 0
var color_distance = 0
var color_completed = true

var tween

var colors = [
	Color8(224,49,49,255)
	,Color8(255,146,43,255)
	,Color8(255,212,59,255)
	,Color8(148,216,45,255)
	,Color8(34,139,230,255)
	,Color8(132,94,247,255)
	,Color8(190,75,219,255)
	,Color8(134,142,150,255)
]

func _ready():
	randomize()
	position.x = new_position.x
	position.y = -100
	tween = create_tween()
	tween.tween_property(self, "position", new_position, time_appear + randf()*2).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_IN_OUT)
	if score >= 100: color_index = 0
	elif score >= 90: color_index = 1
	elif score >= 80: color_index = 2
	elif score >= 70: color_index = 3 
	elif score >= 60: color_index=  4
	elif score >= 50: color_index = 5
	elif score >= 40: color_index = 6
	else: color_index = 7
	$ColorRect.color = colors[color_index]
	sway_initial_position = $ColorRect.position
	sway_randomizer = Vector2(randf()*6-3.0, randf()*6-3.0)
	

func _physics_process(_delta):
	if dying and not $Confetti.emitting and not tween:
		queue_free()
	elif not get_tree().paused:
		color_distance = Global.color_position.distance_to(global_position) / 100
		if Global.color_rotate >= 0:
			$ColorRect.color = colors[(int(float(color_distance + Global.color_rotate))) % len(colors)]
			color_completed = false
		elif not color_completed:
			$ColorRect.color = colors[color_index]
			color_completed = true
	var pos_x = (sin(Global.sway_index)* (sway_amplitude + sway_randomizer.x))
	var pos_y = (cos(Global.sway_index)* (sway_amplitude + sway_randomizer.y))
	$ColorRect.position = Vector2(sway_initial_position.x + pos_x, sway_initial_position.y + pos_x)

func hit(_ball):
	Global.color_rotate = Global.color_rotate_amount
	Global.color_position = _ball.global_position
	die()

func die():
	var brick_sound = get_node("/root/Game/Brick_Sound")
	brick_sound.play()
	dying = true
	collision_layer = 0
	collision_mask = 0
	Global.update_score(score)
	get_parent().check_level()
	$Confetti.emitting = true
	if tween:
		tween.kill()
	tween = create_tween().set_parallel(true)
	tween.tween_property(self, "position", Vector2(position.x, 1000), time_fall).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "rotation", -PI + randf()*2*PI, time_rotate).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property($ColorRect, "color:a", 0, time_a)
	tween.tween_property($ColorRect, "color:s", 0, time_s)
	tween.tween_property($ColorRect, "color:v", 0, time_v)
