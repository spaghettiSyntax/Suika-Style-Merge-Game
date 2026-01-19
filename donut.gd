extends RigidBody2D

@export var level : int = 1
# Pick this color in the Inspector to match you sprite!
@export var particle_color : Color = Color.WHITE

func _ready():
	# 1. Create a Tween (lightweight animator)
	var tween = create_tween()
	
	# 2. Animate the 'scale' property
	tween.tween_property(self, "scale", Vector2.ONE, 0.3)\
		.from(Vector2.ZERO)\
		.set_trans(Tween.TRANS_ELASTIC)\
		.set_ease(Tween.EASE_OUT)

func merge_donut(other_donut):
	# 1. Calculate the midpoint between the two donuts for the new spawn
	var spawn_pos = (global_position + other_donut.global_position) / 2
	
	# 2. Trigger the Explosion
	# WE pass the calculated position AND our specific particle_color
	GameManager.spawn_explosion(spawn_pos, particle_color)
	
	# 3. Tell the Manager to spawn the next level up
	GameManager.spawn_donut(spawn_pos, level)
	
	# 4. Award Points: Level 1 = 10pts, Level 2 = 20pts.
	GameManager.add_score(level * 10)
	
	# 5. Delete the other donut and this donut
	other_donut.queue_free()
	queue_free()


func _on_body_entered(body: Node) -> void:
	# 1. Check if the thing we hit is Also a Donut
	if body.is_in_group("donut"):
		# 2. Check if it is the SAME level (01 hits 01)
		if body.level == level:
			# If we are Level 3, DO NOT MERGE.
			if level >= 3:
				return
			
			# 3. CONFLICT RESOLUTION: Only the donut with the higher ID
			if body.get_instance_id() > get_instance_id():
				return # Stop! Let the other donut handle this.
			
			call_deferred("merge_donut", body)
