extends UTILAction

func action_logic(delta: float):
	var wander_mode: String = %SurvivorBrain.wander_mode; # states: idle, walk;
	var wander_pos: Vector2 = %SurvivorBrain.wander_position;
	var walk_dist: float = %SurvivorBrain.walk_dist;
	var walk_duration: float = %SurvivorBrain.walk_duration;
	var idle_duration: float = %SurvivorBrain.idle_duration;
	var _wander_timer: float = %SurvivorBrain._wander_timer;
	
	var face_direction: String = %SurvivorBrain._face_direction;
	var char: CharacterBody2D = %SurvivorBrain.get_actor();
	var wander_speed: float = 64;
	var proximity_dist: float = 8;
	
	_wander_timer += delta;
	
	if wander_mode == "idle" && (_wander_timer >= idle_duration) || %RayCast2D.is_colliding():
		randomize();
		wander_pos = (char.global_position 
				+ Vector2(randf_range(-walk_dist, walk_dist), randf_range(-walk_dist, walk_dist)));
		var dist: float = wander_pos.distance_to(char.global_position);
		while (dist > walk_dist || dist < walk_dist * 0.75):
			wander_pos = (char.global_position 
				+ Vector2(randf_range(-walk_dist, walk_dist), randf_range(-walk_dist, walk_dist)));
			dist = wander_pos.distance_to(char.global_position);
	
	if ( (wander_mode == "idle" && _wander_timer >= idle_duration) 
			or (wander_mode == "walk" && (_wander_timer >= walk_duration 
					|| char.global_position.distance_to(wander_pos) < proximity_dist) ) ):
		_wander_timer = 0;
		wander_mode = "idle" if wander_mode == "walk" else "walk";
	
	
	
	
	var direction: Vector2 = (Vector2.ZERO if wander_mode == "idle" 
			else char.global_position.direction_to(wander_pos) * wander_speed);
	char.velocity = direction;
	#%RayCast2D.set_rotation(direction.angle());
	
	%SurvivorBrain.wander_mode = wander_mode; # states: idle, walk;
	%SurvivorBrain.wander_position = wander_pos;
	%SurvivorBrain._wander_timer = _wander_timer;
	
	char.move_and_slide();
	
	%Animator.play(wander_mode+"_"+face_direction);
	%SurvivorBrain._is_action_finished = true;
