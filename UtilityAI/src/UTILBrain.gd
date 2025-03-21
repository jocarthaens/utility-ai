@icon("res://UtilityAI/icons/utilbrain.svg")
extends Node
class_name UTILBrain

@export var actor: Node: get = get_actor;
@export_enum("Max Score", "Min Score") var action_selection = "Max Score"
@export var shuffle_if_same_scores: bool = false ## Randomizes selection if multiple actions has max/min values satisfied and are equal. This is to ensure that all possible options are chosen even if their values are equal.

var action_list: Array[UTILAction]

var _is_initialized := false



func get_actor() -> Node:
	return actor;



# Methods that adds and removes UTILAction nodes from its list, or clears the entire UTILAction list.

func add_action(action: UTILAction):
	add_child(action)

func remove_action(action: UTILAction, is_permanent: bool = true):
	remove_child(action)
	if is_permanent:
		action.queue_free()

func clear_actions(is_permanent: bool):
	for action: UTILAction in action_list:
		remove_action(action, is_permanent)





# Method to be called by UTILAction instances when they enter/exit the scene tree
func _update_actions(child: UTILAction, is_entering: bool):
	if is_entering:
		action_list.append(child)
	elif not is_entering:
		action_list.erase(child)






## Updates utility decisions. Must be called first before calling determine_action().
func utility_update():
	if not _is_initialized:
		_initialize()
	for action in action_list:
		action._action_score_update()
		#print(action.name +" "+ str(action.get_action_score()))

## Determines best action to use. Must be used after calling utility_update() method every tick/
func determine_action() -> UTILAction:
	if shuffle_if_same_scores == true:
		randomize()
		action_list.shuffle()
	
	if (action_selection == "Max Score"):
		action_list.sort_custom(func(a: UTILAction, b: UTILAction): return a.get_action_score() > b.get_action_score())
	elif (action_selection == "Min Score"):
		action_list.sort_custom(func(a: UTILAction, b: UTILAction): return a.get_action_score() <  b.get_action_score())
	
	return action_list[0]







# Functions that checks its list of UTILAction nodes.

func _initialize():
	_check_action_list()
	_is_initialized = true

func _check_action_list():
	if action_list.size() <= 0:
		push_error("UTILAgent doesn't have any UTILAction nodes on its list.")
		assert(action_list.size() > 0,"UTILAgent doesn't have any UTILAction nodes on its list")
