extends Node2D

# Block scene paths
const BLOCK_SCENES = [
	"res://scenes/lvlblock1.tscn",
	"res://scenes/lvlblock2.tscn"
]

# Configuration
var spawn_distance: float = 1000.0  # How far ahead of player to spawn blocks
var cleanup_distance: float = 2000  # How far back to remove blocks
var spawn_start_offset: float = 3744.0  # Start spawning after the initial level block

# Tracking
var next_spawn_x: float = 0.0
var spawned_blocks: Array = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Initialize spawn position after the initial level block
	next_spawn_x = spawn_start_offset


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var current_x_position = Autoloadscript.posplr
	
	# Spawn new blocks if player is approaching empty space ahead
	spawn_blocks_if_needed(current_x_position)
	
	# Clean up old blocks
	cleanup_old_blocks(current_x_position)


func spawn_random_block(x_position: float) -> void:
	"""Spawn a random block at the given X position"""
	var random_scene = BLOCK_SCENES[randi() % BLOCK_SCENES.size()]
	var block_scene = load(random_scene)
	var block_instance = block_scene.instantiate()
	
	block_instance.position.x = x_position
	add_child(block_instance)
	spawned_blocks.append(block_instance)
	
	# Get block width from the block's script constant
	var block_width = get_block_width(block_instance)
	next_spawn_x = x_position + block_width


func get_block_width(block: Node) -> float:
	"""Read BLOCK_WIDTH constant from the block's script"""
	if block.has_meta("block_width"):
		return block.get_meta("block_width")
	# Fallback: try to get from script
	if block.get_script():
		var script = block.get_script()
		if script.has_source_code():
			# Try to get the constant from the script
			if "BLOCK_WIDTH" in script:
				return script.get("BLOCK_WIDTH")
	# Last resort fallback
	return 592.0


func spawn_blocks_if_needed(current_x_position: float) -> void:
	"""Spawn new blocks when player is approaching empty space"""
	# Keep spawning blocks until there's enough buffer ahead of player
	while current_x_position + spawn_distance > next_spawn_x:
		spawn_random_block(next_spawn_x)


func cleanup_old_blocks(current_x_position: float) -> void:
	"""Remove blocks that are far behind the player"""
	for block in spawned_blocks.duplicate():
		if block and block.global_position.x < current_x_position - cleanup_distance:
			block.queue_free()
			spawned_blocks.erase(block)
