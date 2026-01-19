extends Node

signal score_updated(current_score, high_score)

const SAVE_PATH = "user://savegame.save"

var score : int = 0
var high_score : int = 0
var particle_scene = preload("res://scenes/explosion.tscn")

# Preload our donut scenes
var donuts : Array[PackedScene] = [
	preload("res://scenes/donut_01.tscn"),
	preload("res://scenes/donut_02.tscn"),
	preload("res://scenes/donut_03.tscn")
]

func _ready():
	load_score()
	
	score = 0
	
func add_score(amount):
	score += amount
	if score > high_score:
		high_score = score
		save_score()
		
	score_updated.emit(score, high_score)
		
func save_score():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_var(high_score)
	
func load_score():
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		high_score = file.get_var()
	else:
		high_score = 0

func spawn_donut(pos : Vector2, current_level : int):
	# Check if a next level exists
	if current_level < donuts.size():
		# Next donut is at index = current_level (since array is 0 based)d
		var new_donut = donuts[current_level].instantiate()
		new_donut.position = pos
		
		# Defer adding the child to avoid physics locks
		call_deferred("add_child_to_game", new_donut)
		
func add_child_to_game(donut_node):
	get_tree().current_scene.add_child(donut_node)
	
func spawn_explosion(pos : Vector2, color : Color):
	if particle_scene:
		var puff = particle_scene.instantiate()
		puff.position = pos
		puff.modulate = color # Match the particle color to the donut!
		puff.emitting = true
		
		# Add to the current scene (The Game node), NOT the donut
		call_deferred("add_child_to_game", puff)
		
func reset_high_score():
	# 1. Reset the variable
	high_score = 0
	
	# 2. Overwrite the save file with 0
	save_score()
	
	# 3. Emit the signal so the UI updates instantly
	score_updated.emit(score, high_score)
	
func game_over():
	# 1. Create a new CanvasLayer to hold UI
	var layer = CanvasLayer.new()
	layer.layer = 100 # Force it the very front
	
	# 2. Add the layer to the scene
	get_tree().current_scene.add_child(layer)
	
	# 3. Instantiate the UI
	var ui = preload("res://scenes/game_over_ui.tscn").instantiate()
	
	# 4. Add the UI as a child of the LAYER, not scene
	layer.add_child(ui)
	
	# Pause the Physics
	get_tree().paused = true
