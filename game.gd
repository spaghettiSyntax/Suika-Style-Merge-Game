extends Node2D

@onready var score_label: Label = $HUD/ScoreLabel
@onready var high_score_label: Label = $HUD/HighScoreLabel

func _ready():
	# Since GamaManager persists, we must manually reset variables
	GameManager.score = 0
	
	# Connect the signal from singleton
	GameManager.score_updated.connect(_on_score_updated)
	
	# Initialize labels current values
	_on_score_updated(GameManager.score, GameManager.high_score)
	
func _on_score_updated(score, high_score):
	score_label.text = "Score: " + str(score)
	high_score_label.text = "Best: " + str(high_score)
