extends Node2D

var phase: String = "idle"  # idle | lights | go | jump | result
var light_count: int = 0
var start_time: int = 0
var result_ms: int = 0

@onready var lights = [$Lights/L1, $Lights/L2, $Lights/L3, $Lights/L4, $Lights/L5]
@onready var status = $Status
@onready var start_btn = $StartBtn
@onready var light_timer = $LightTimer
@onready var go_timer = $GoTimer

func _ready():
	start_btn.pressed.connect(_on_start)
	light_timer.timeout.connect(_next_light)
	go_timer.timeout.connect(_lights_out)
	_reset_lights()

func _on_start():
	_reset_lights()
	result_ms = 0; light_count = 0; phase = "lights"
	status.text = "Hold…"
	start_btn.visible = false
	light_timer.start(0.8)

func _next_light():
	light_count += 1
	if light_count <= 5:
		lights[light_count - 1].color = Color.RED
	if light_count == 5:
		light_timer.stop()
		go_timer.start(1.0 + randf() * 3.0)  # random hold after full lights

func _lights_out():
	_reset_lights()
	phase = "go"
	status.text = "GO!"
	start_time = Time.get_ticks_msec()

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		_handle_press()

func _handle_press():
	if phase == "lights":
		phase = "jump"; light_timer.stop(); go_timer.stop(); _reset_lights()
		status.text = "Jump start! Tap to retry"
		start_btn.visible = true
	elif phase == "go":
		result_ms = Time.get_ticks_msec() - start_time
		phase = "result"
		status.text = "%d ms — tap to go again" % result_ms
		start_btn.visible = true

func _reset_lights():
	for l in lights: l.color = Color(0.102, 0.0, 0.102, 1.0)


func _on_home_button_pressed():
	get_tree().change_scene_to_file("res://main_menu.tscn")
