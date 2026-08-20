extends Node2D

const SYMBOLS = ["🏎️","🏁","⛽","🛞","🏆","⚙️","🧠","⚡"]
const PAIRS = 8  # 16 cards. change to 6/12 for easy, 12/24 for hard

var cards: Array = []
var flipped: Array = []   # indices currently face-up (max 2)
var moves: int = 0
var seconds: int = 0
var lock: bool = false
var done: bool = false

@onready var grid = $Grid
@onready var moves_label = $MovesLabel
@onready var time_label = $TimeLabel
@onready var timer = $GameTimer

func _ready():
	$Restart.pressed.connect(_on_restart)
	timer.timeout.connect(func(): seconds += 1; time_label.text = "Time: %ds" % seconds)
	_new_game()

func _new_game():
	for c in grid.get_children(): c.queue_free()
	cards.clear(); flipped.clear(); moves = 0; seconds = 0; lock = false; done = false
	moves_label.text = "Moves: 0"; time_label.text = "Time: 0s"
	var pool = []
	for i in PAIRS:
		pool.append(SYMBOLS[i]); pool.append(SYMBOLS[i])
	pool.shuffle()
	for i in pool.size():
		var b = Button.new()
		b.text = "?"
		b.custom_minimum_size = Vector2(90, 90)
		b.pressed.connect(_on_card_pressed.bind(i))
		grid.add_child(b)
		cards.append({ "symbol": pool[i], "matched": false, "btn": b })

func _on_card_pressed(idx: int):
	if lock or done: return
	if flipped.has(idx) or cards[idx].matched: return
	if flipped.is_empty() and seconds == 0: timer.start()
	cards[idx].btn.text = cards[idx].symbol
	flipped.append(idx)
	if flipped.size() == 2:
		moves += 1; moves_label.text = "Moves: %d" % moves
		lock = true
		if cards[flipped[0]].symbol == cards[flipped[1]].symbol:
			cards[flipped[0]].matched = true
			cards[flipped[1]].matched = true
			flipped.clear(); lock = false
			_check_done()
		else:
			await get_tree().create_timer(0.7).timeout
			for i in flipped: cards[i].btn.text = "?"
			flipped.clear(); lock = false

func _check_done():
	for c in cards: if not c.matched: return
	done = true; timer.stop()
	# show on screen — add a ResultLabel to your scene and set its text here

func _calc_iq() -> int:
	var move_eff = float(PAIRS) / max(moves, PAIRS)
	var time_eff = float(PAIRS * 4) / max(seconds, PAIRS * 2)
	var raw = 70.0 + move_eff * 55.0 + min(time_eff, 1.4) * 20.0
	return int(clamp(raw, 70, 145))

func _on_restart():
	_new_game()


func _on_button_pressed(): 
	get_tree().change_scene_to_file("res://main_menu.tscn")
