extends UTILAction


func action_logic(delta: float): 
	var nearest_wood_tree: Area2D = %SurvivorBrain.nearest_wood_tree;
	var has_wood: bool = %SurvivorBrain.has_wood;
	var firewood: Area2D = %SurvivorBrain.firewood;
	var nearest_wood: Area2D = %SurvivorBrain.nearest_wood;
	var found_wood: bool = nearest_wood != null || nearest_wood_tree != null && nearest_wood_tree.has_wood() == true;
	var actor: CharacterBody2D = %SurvivorBrain.get_actor();
	var moving_speed: int = 64;
	var carry_speed: int = 32;
	var face_direction: String = %SurvivorBrain._face_direction;
	var tree_proximity: int = 12;
	var wood_proximity: int = 4;
	var firewood_proximity: int = 16;
	var energy: float = %SurvivorBrain.energy;
	
	
	if firewood == null || actor == null || %Animator.current_animation.begins_with("melee_"):
		return;
	
	elif (found_wood == false || energy < 1) && has_wood == false:
		%SurvivorBrain._is_action_finished = true;
		return;
		
	
	if has_wood == false && found_wood == true:
		if nearest_wood != null:
			if actor.global_position.distance_to(nearest_wood.global_position) > wood_proximity:
				%Animator.play("walk_"+face_direction)
				actor.velocity = (nearest_wood.global_position - actor.global_position).normalized() * moving_speed;
			else:
				actor.velocity = Vector2.ZERO;
				%SurvivorBrain.collect();
		elif nearest_wood_tree != null && nearest_wood_tree.has_wood() == true:
			if actor.global_position.distance_to(nearest_wood_tree.global_position) > tree_proximity:
				%Animator.play("walk_"+face_direction);
				actor.velocity = (nearest_wood_tree.global_position - actor.global_position).normalized() * moving_speed;
			else:
				actor.velocity = Vector2.ZERO;
				%Animator.play("melee_"+face_direction);
	
	if has_wood == true:
		if actor.global_position.distance_to(firewood.global_position) > firewood_proximity:
			%Animator.play("carry_"+face_direction)
			actor.velocity = (firewood.global_position - actor.global_position).normalized() * carry_speed;
		else:
			actor.velocity = Vector2.ZERO;
			%SurvivorBrain.collect();
			#%SurvivorBrain._is_action_finished = true;
	
	actor.move_and_slide();
	
	if %SurvivorBrain.kindle_hp > 9:
		%SurvivorBrain._is_action_finished = true;
