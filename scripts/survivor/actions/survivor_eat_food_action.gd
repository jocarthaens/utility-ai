extends UTILAction


func action_logic(delta: float):
	var nearest_fruit_tree: Area2D = %SurvivorBrain.nearest_fruit_tree;
	var nearest_fruit: Area2D = %SurvivorBrain.nearest_fruit;
	var found_fruit: bool = nearest_fruit != null || nearest_fruit_tree != null && nearest_fruit_tree.has_fruit() == true;
	var actor: CharacterBody2D = %SurvivorBrain.get_actor();
	var moving_speed: int = 96;
	var face_direction: String = %SurvivorBrain._face_direction;
	var proximity_dist: int = 8;
	
	var energy: int = %SurvivorBrain.energy;
	
	
	if actor == null|| %Animator.current_animation.begins_with("melee"):
		return;
	
	if found_fruit == false || nearest_fruit == null && energy < 1:
		#randomize();
		#%SurvivorBrain._eat_tries = randi_range(3, %SurvivorBrain._max_eat_tries);
		%SurvivorBrain._is_action_finished = true;
		return;
	
	elif found_fruit == true:
		if nearest_fruit != null:
			if actor.global_position.distance_to(nearest_fruit.global_position) > proximity_dist:
				%Animator.play("walk_"+face_direction);
				actor.velocity = (nearest_fruit.global_position - actor.global_position).normalized() * moving_speed;
			else:
				actor.velocity = Vector2.ZERO;
				%SurvivorBrain.collect();
				%SurvivorBrain._eat_tries -= 1;
				#%SurvivorBrain._is_action_finished = true; # #
		elif nearest_fruit_tree != null && nearest_fruit_tree.has_fruit() == true:
			if actor.global_position.distance_to(nearest_fruit_tree.global_position) > proximity_dist:
				%Animator.play("walk_"+face_direction);
				actor.velocity = (nearest_fruit_tree.global_position - actor.global_position).normalized() * moving_speed;
			else:
				actor.velocity = Vector2.ZERO;
				#%SurvivorBrain.collect();
				%Animator.play("melee_"+face_direction);
	
	actor.move_and_slide();
	
	if %SurvivorBrain.hunger < 1:# || %SurvivorBrain._eat_tries < 1:
		#randomize();
		#%SurvivorBrain._eat_tries = randi_range(3, %SurvivorBrain._max_eat_tries);
		%SurvivorBrain._is_action_finished = true;
