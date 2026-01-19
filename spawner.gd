extends Node2D


var current_donut : RigidBody2D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_new_donut()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if current_donut != null and current_donut.freeze == true:
		# 1. Follow the mouse on the X axis
		var mouse_x = get_global_mouse_position().x
		
		# 2. Clamp the donut so it stays inside the walls
		# Adjust numbers to your screen width
		mouse_x = clamp(mouse_x, 50, 1000)
		
		# 3. Update position
		current_donut.global_position.x = mouse_x
		
func _unhandled_input(event: InputEvent) -> void:
	# Detect Left Click
	if event.is_action_pressed("ui_accept") or event is InputEventMouseButton:
		if event.is_pressed() and current_donut != null:
			drop_donut()
			
func drop_donut():
	# Unfreeze to let gravity take over
	current_donut.freeze = false
	
	# Reset mask and layer back to 1 (Default)
	current_donut.collision_mask = 1
	current_donut.collision_layer = 1
	
	current_donut = null
	
	# Wait a moment before spawning the next one
	await get_tree().create_timer(1.0).timeout
	spawn_new_donut()
	
func spawn_new_donut():
	# Create the donut
	var random_index = randi() % 2
	
	# Grab the scene from GameManager
	var scene = GameManager.donuts[random_index]
	current_donut = scene.instantiate()
	
	# FREEZE IT so it doesn't fall yet
	current_donut.freeze = true
	
	# Set collision mask to 0 so it won't hit anything
	current_donut.collision_mask = 0
	# Set layer to 0 so nothing hit it either
	current_donut.collision_layer = 0
	
	# Add it to the Game scene, not the spawner
	# We cannot use get_parent().add_child(current_donut) directly _ready
	# We must DEFER the call so it happens AFTER the scene loadds
	get_parent().call_deferred("add_child", current_donut)
	
	
	# Set initial position to the spawner's position
	current_donut.global_position = global_position
