extends Area2D

@onready var timer: Timer = $Timer

# 1. Add a counter to track overlapping objects
var bodies_in_zone = 0


func _on_body_entered(body: Node2D) -> void:
	if body is RigidBody2D and body.freeze == true:
		return
		
	if body.is_in_group("donut"):
		# 2. Increment the counter
		bodies_in_zone += 1
		
		# 3. Only start the timer if this is the FIRST danger object
		if bodies_in_zone == 1:
			timer.start()


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("donut"):
		# 4. Decrement the counter
		bodies_in_zone -= 1
	
	# 5. Only timer if NO danger objects remain
	if bodies_in_zone == 0:
		timer.stop()


func _on_timer_timeout() -> void:
	GameManager.game_over()
