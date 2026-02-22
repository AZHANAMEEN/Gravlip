extends Node2D

@onready var lvl = $Node2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	lvl.position.x += 0
	
	Autoloadscript.posplr = $Node2D2.global_position.x
	print($Node2D2.global_position.x)
