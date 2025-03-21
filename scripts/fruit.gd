extends Area2D

var _set_free: bool = false;
var _type_name: String = "fruit";
var _food_point: int = 2;

func _physics_process(delta: float) -> void:
	if _set_free == true:
		get_parent().remove_child(self);
		self.queue_free();

func eat_fruit() -> int:
	_set_free = true;
	return _food_point;

func get_type() -> String:
	return _type_name;
