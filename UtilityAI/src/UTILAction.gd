@icon("res://UtilityAI/icons/utilaction.svg")
extends Node
class_name UTILAction

enum Compound{
	AVERAGE,
	MULTIPLICATION,
	MINIMUM,
	MAXIMUM,
	ADDITION,
	GEOMETRIC_MEAN,
	HARMONIC_MEAN}
@export var score_method := Compound.AVERAGE
var _compounder := MATHCompounder.new()

var _action_score: float : set = set_action_score, get = get_action_score
func set_action_score(score: float):
	_action_score = score
func get_action_score():
	return _action_score

var _scorer_list: Array[UTILScorer]
var _parent

var _is_initialized := false





## Overridable method for defining task logic.
func action_logic(delta: float): pass





# Callable methods that allow for adding and removing UTILScorer nodes, or clearing the list of UTILScorers.

func add_scorer(util_scorer):
	if util_scorer is UTILScorer:
		_scorer_list.append(util_scorer)
	elif util_scorer is Array:
		for scorer in util_scorer:
			if scorer is UTILScorer:
				_scorer_list.append(scorer)
	elif not (util_scorer is UTILScorer) and not (util_scorer is Array):
		push_warning("Input is neither a UTILScorer instance, nor contains any UTILScorer instances.")

func remove_scorer(util_scorer):
	if util_scorer is UTILScorer:
		_scorer_list.erase(util_scorer)
	elif util_scorer is Array:
		var scorer_array = util_scorer.duplicate()
		for scorer in scorer_array:
			if scorer is UTILScorer:
				_scorer_list.erase(scorer)
	elif not (util_scorer is UTILScorer)  and not (util_scorer is Array):
		push_warning("Input doesn't contain any matching UTILScorer instances, or even any UTILScorer instances inside.")

func clear_scorers():
	_scorer_list.clear()








# These functions update their parent UTILBrain node upon entering/exiting the scene tree

func _enter_tree():
	_parent = get_parent()
	if (_parent is UTILBrain):
		_parent._update_actions(self, true)

func _exit_tree():
	if (_parent is UTILBrain):
		_parent._update_actions(self, false)
		_is_initialized = false







# Functions that initialize the UTILAction node, when running it after it enters the scene tree

func _initialize():
	_get_scorers()
	_check_scorer_list()
	_is_initialized = true

func _get_scorers():
	_scorer_list.clear()
	var scorer_children := get_children()
	add_scorer(scorer_children)

func _check_scorer_list():
	if _scorer_list.size() <= 0:
		push_error("UTILAction doesn't have a list of UTILScorer nodes.")
		assert(_scorer_list.size() > 0,"UTILAction doesn't have a list of UTILScorer nodes.")











# Updates its child UTILScorers and combines their scores.
func _action_score_update():
	if not _is_initialized:
		_initialize()
	for scorer in _scorer_list:
		scorer._update_score()
	_generate_action_score()


# Generates the UTILAction's score by combining the scores of UTILScorer child nodes.
func _generate_action_score():
	var scores_list := []
	for scorer in _scorer_list:
		if scorer is UTILScorer:
			var value: float = scorer.get_score()
			scores_list.append(value)
	var final_score = _compounder.calculate(scores_list, score_method)
	set_action_score(final_score)
