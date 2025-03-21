extends UTILAction


func action_logic(delta: float):
	var energy: int = %SurvivorBrain.energy;
	var anim_finished: String = %SurvivorBrain._animation_finished;
	var face_direction: String = %SurvivorBrain._face_direction
	var firewood: Area2D = %SurvivorBrain.firewood;
	var actor: CharacterBody2D = %SurvivorBrain.get_actor();
	var proximity_dist: int = 24;
	var approach_speed: int = 32;
	
	if actor == null:
		return;
	
	if firewood != null && actor.global_position.distance_to(firewood.global_position) > proximity_dist:
		%Animator.play("walk_"+face_direction);
		actor.velocity = (firewood.global_position - actor.global_position).normalized() * approach_speed;
		actor.move_and_slide();
	
	elif firewood == null || actor.global_position.distance_to(firewood.global_position) <= proximity_dist:
		 # if sprite frames depicts a character sleeping in either right or left
		if %SurvivorSprites.frame != 43 || %SurvivorSprites.frame != 47:
			%Animator.play("sleep_"+face_direction);
		
		if anim_finished.begins_with("sleep"):
			%Animator.pause();
			%SurvivorSprites.frame = 43; # sleeping character sprite frame facing right
			%SurvivorSprites.flip_h = true if face_direction == "left" else false;

		if energy > 9:
			%SurvivorBrain._is_action_finished = true;
