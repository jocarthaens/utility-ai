extends UTILBrain


var nearest_fruit: Area2D = null;
var nearest_wood: Area2D = null;
var nearest_wood_tree: Area2D = null;
var nearest_fruit_tree: Area2D = null;
var firewood: Area2D = null

var has_wood: bool = false;
var wood_point: int = 2;

var energy: int = 6: set = set_energy;
var max_energy: int = 10;
var _lethargy_timer: float = 0.0;
var _lethargy_tick: float = 20.0;
var _energize_timer: float = 0.0;
var _energize_tick: float = 1.0;

var hunger: int = 3: set = set_hunger;
var max_hunger: int = 10;
var _hunger_rise_timer: float = 0.0;
var _hunger_rise_tick: float = 4.0
var _eat_tries: int = 3;
var _max_eat_tries: int = 5;

var kindle_hp: int = 0;
var max_kindle_hp: int = 10;

var _collect_timer: float = 0;
var _collect_duration: float = 0.333333333333;

var wander_mode: String = "idle"; # states: idle, walk;
var wander_position: Vector2 = Vector2.ZERO;
var walk_dist: float = 320.0;
var walk_duration: float = 4.0;
var idle_duration: float = 3.0;
var _wander_timer: float = 0.0;



var _selected_action: UTILAction = null;
var _is_action_finished: bool = false; # access and modification intended for UTILAction nodes
var _face_direction: String = "right";
var _animation_finished: String = "";



func set_energy(value: int):
	energy = clampi(value, 0, max_energy);

func set_hunger(value: int):
	hunger = clampi(value, 0, max_hunger);






func _ready() -> void:
	randomize();
	hunger = randi_range(0, max_hunger);
	energy = randi_range(0, max_energy);
	#_eat_tries = randi_range(3, _max_eat_tries);



func _physics_process(delta: float) -> void:
	check_objects();
	scan_area();
	_execute_utility_action(delta);
	modify_values(delta);




func check_objects():
	if (not is_instance_valid(nearest_fruit) ):
		nearest_fruit = null;
	if (not is_instance_valid(nearest_wood) ):
		nearest_wood = null;
	if (not is_instance_valid(nearest_fruit_tree) ):
		nearest_fruit_tree = null;
	if (not is_instance_valid(nearest_wood_tree) ):
		nearest_wood_tree = null;
	if ( not is_instance_valid(firewood) ):
		firewood = null;


func scan_area():
	var areas: Array[Area2D] = %Sensor.get_overlapping_areas();
	for area: Area2D in areas:
		if area.has_method("get_type"):
			var type: String = area.get_type();
			match type:
				"fruit":
					if (not is_instance_valid(nearest_fruit) 
							or (nearest_fruit.global_position - get_actor().global_position).length() 
							> (area.global_position - get_actor().global_position).length() ):
						nearest_fruit = area;
				"wood":
					if (not is_instance_valid(nearest_wood) 
							or (nearest_wood.global_position - get_actor().global_position).length() 
							> (area.global_position - get_actor().global_position).length() ):
						nearest_wood = area;
				"fruit_tree":
					if (not is_instance_valid(nearest_fruit_tree) || nearest_fruit_tree.has_fruit() == false
							or (nearest_fruit_tree.global_position - get_actor().global_position).length() 
							> (area.global_position - get_actor().global_position).length() 
							and area.has_method("has_fruit") && area.has_fruit() == true):
						nearest_fruit_tree = area;
				"wood_tree":
					if (not is_instance_valid(nearest_wood_tree) || nearest_wood_tree.has_wood() == false
							or (nearest_wood_tree.global_position - get_actor().global_position).length()
							> (area.global_position - get_actor().global_position).length() 
							and area.has_method("has_wood") && area.has_wood() == true):
						nearest_wood_tree = area;
				"firewood":
					if ( not is_instance_valid(firewood) ):
						firewood = area;


func _execute_utility_action(delta: float):
	utility_update();
	if _is_action_finished == true || _selected_action == null:
		_selected_action = determine_action();
		_is_action_finished = false;
	
	if _selected_action != null:
		_selected_action.action_logic(delta)
		%ActionLabel.text = _selected_action.get_name();


func modify_values(delta: float):
	if firewood != null && firewood.has_method("get_kindle_hp") && firewood.has_method("get_max_kindle_hp"):
		kindle_hp = firewood.get_kindle_hp();
		max_kindle_hp = firewood.get_max_kindle_hp();
	
	if _animation_finished.begins_with("sleep") && energy < max_energy:
		_energize_timer += delta;
		if _energize_timer >= _energize_tick:
			energy += 1;
			_energize_timer = 0;
	elif not _animation_finished.begins_with("sleep") && energy > 0:
		_lethargy_timer += delta;
		if _lethargy_timer >= _lethargy_tick:
			energy -= 1;
			_lethargy_timer = 0;
	
	if hunger < max_hunger:
		_hunger_rise_timer += delta;
		if _hunger_rise_timer >= _hunger_rise_tick:
			hunger += 1;
			_hunger_rise_timer = 0;
	
	
	%HungerBar.value = hunger;
	%EnergyBar.value = energy;
	
	
	if %CollectorShape.disabled == false:
		_collect_timer += delta;
		if _collect_timer >= _collect_duration:
			_collect_timer = 0;
			%CollectorShape. disabled = true;
	
	var character: CharacterBody2D = get_actor();
	if character.velocity.length() > 0:
		_face_direction = "left" if character.velocity.x < 0 else "right";
		%RayCast2D.set_rotation(character.velocity.angle());






func collect():
	%CollectorShape.disabled = false;






func _on_collector_area_entered(area: Area2D) -> void:
	if area.has_method("get_type"):
		var type: String = area.get_type();
		match type:
			"fruit":
				if area.has_method("eat_fruit"):
					hunger -= area.eat_fruit();
			"wood":
				if area.has_method("collect_wood") && has_wood == false && energy > 0:
					area.collect_wood();
					has_wood = true;
					energy -= 1;
			"firewood":
				if area.has_method("kindle_fire") && has_wood == true:
					area.kindle_fire(wood_point);
					has_wood = false;


func _on_animation_finished(anim_name: StringName) -> void:
	_animation_finished = anim_name;


func _on_tool_hit(area: Area2D) -> void:
	if area.has_method("get_type"):
		var type: String = area.get_type();
		match type:
			"wood_tree":
				if area.has_method("drop_wood") && energy > 0:
					area.drop_wood();
					energy -= 1;
			"fruit_tree":
				if area.has_method("drop_fruit") && energy > 0:
					area.drop_fruit();
					energy -= 1;
