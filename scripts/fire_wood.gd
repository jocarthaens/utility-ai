extends Area2D

var kindle_hp: int = 4: set = set_kindle_hp, get = get_kindle_hp;
var max_kindle_hp: int = 10: get = get_max_kindle_hp;
var _kindle_drop_timer: float = 0.0;
var _kindle_drop_tick: float = 15.0


func set_kindle_hp(value: int):
	kindle_hp = clampi(value, 0, max_kindle_hp);

func get_kindle_hp() -> int:
	return kindle_hp;



func get_max_kindle_hp() -> int:
	return max_kindle_hp;





func _ready() -> void:
	randomize();
	kindle_hp = randf_range(0, max_kindle_hp);


func _physics_process(delta: float) -> void:
	pass
	_kindle_drop_timer += delta;
	if _kindle_drop_timer >= _kindle_drop_tick && kindle_hp > 0:
		_kindle_drop_timer = 0;
		kindle_hp -= 1;
	
	_animation();

func _animation():
	%KindleHP.value = kindle_hp;
	
	if kindle_hp > 0:
		%AnimationPlayer.play("burning")  
	else:
		%AnimationPlayer.play("extinguished")

func get_type() -> String:
	return "firewood"

func kindle_fire(value: int):
	kindle_hp += value;
