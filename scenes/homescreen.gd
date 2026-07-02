extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Path2D/AnimationPlayer.play("new_animation")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/home.tscn")


func _on_touch_screen_button_3_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/shop.tscn")
