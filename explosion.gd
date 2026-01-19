extends CPUParticles2D

@onready var audio_player = $AudioStreamPlayer2D

func _ready():
	# Randomize pitch so every explosion sounds slightly differentt
	audio_player.pitch_scale = randf_range(0.9, 1.1)

# Particles stop emitting, but they stay in memory
# forever. Unless we delete them
func _on_finished():
	# Verify the sound is done before deleting, just in case
	# the particle is faster than the sound
	if not audio_player.playing:
		queue_free()
	else:
		# If particles are done sound is still player, wait
		await audio_player.finished
		queue_free()
