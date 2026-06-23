extends Control

var deck = []

@onready var grid = $grid

var CardScene = preload("res://Card.tscn")

func _ready():
	fill_deck()
	deal_deck()

func fill_deck():
	for value in range(1, 9):

		var card1 = CardScene.instantiate()
		card1.setup(1, value)

		var card2 = CardScene.instantiate()
		card2.setup(1, value)

		deck.append(card1)
		deck.append(card2)

	deck.shuffle()

func deal_deck():
	for card in deck:
		grid.add_child(card)
