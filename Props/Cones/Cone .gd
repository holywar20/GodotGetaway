extends RigidBody

onready var audioPlayer = $AudioStreamPlayer3D
onready var timer = $Timer


var hasSpawned = false

func _onTimerTimeout():
	queue_free()

func _onConeBodyEntered( _body: Node ):
	if not audioPlayer.playing:
		audioPlayer.play()

# Uses timer and sleeping state as a boolean to determine if it's been hit or not
func _onSleepingStateChanged():
	if not sleeping and hasSpawned:
		timer.start()
	else:
		hasSpawned = true

