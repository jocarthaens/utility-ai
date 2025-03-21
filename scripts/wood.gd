extends Area2D

var _set_free: bool = false;
var _type_name: String = "wood";

func _physics_process(delta: float) -> void:
	if _set_free == true:
		get_parent().remove_child(self);
		self.queue_free();

func collect_wood():
	_set_free = true;

func get_type() -> String:
	return _type_name;
