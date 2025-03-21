extends Area2D

var grow_time: float = 45.0
var _is_full_tree: bool = false;
var _timer: float = 4.0;
var _drop_command: bool = false;

@onready var collider_shape: CollisionShape2D = %WoodTreeShape
@onready var sprite: Sprite2D = %Sprites
@onready var wood = preload("res://scenes/wood.tscn");

func _ready() -> void:
	randomize();
	_timer = randf_range(grow_time * 0.5, grow_time);

func _physics_process(delta: float) -> void:
	if (_drop_command == true):
		_drop_item();
	if (_is_full_tree == false):
		sprite.frame = 1;
		collider_shape.disabled = true;
		_timer += delta;
		if (_timer >= grow_time):
			_is_full_tree = true;
			sprite.frame = 0;
			collider_shape.disabled = false
			randomize();
			_timer = randf_range(0,grow_time);


func has_wood():
	return _is_full_tree;

func drop_wood():
	if (_is_full_tree == true):
		_drop_command = true;

func _drop_item():
	var drop = wood.instantiate();
	#drop.pickup_time = 1.0;
	randomize()
	drop.position = position + Vector2(randi_range(-16, 16), randi_range(-16, 16));
	get_parent().add_child(drop);
	_drop_command = false;
	_is_full_tree = false;

func get_type() -> String:
	return "wood_tree";
