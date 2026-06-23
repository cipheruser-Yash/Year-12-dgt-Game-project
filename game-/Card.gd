extends TextureButton
class_name Card

var suit : int
var value : int

var face : Texture2D
var back : Texture2D

var flipped := false

func setup(s: int, v: int):
	suit = s
	value = v

	face = load("res://Cards/card-%d-%d.png" % [suit, value])
	back = load("res://Cards/cardBack_red2.png")

	texture_normal = back


func flip():
	flipped = !flipped

	if flipped:
		texture_normal = face
	else:
		texture_normal = back


func _pressed():
	flip()
