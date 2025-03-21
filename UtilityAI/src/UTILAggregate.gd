@icon("res://UtilityAI/icons/utilaggregator.svg")
extends UTILScorer
class_name UTILAggregator

enum CompoundMethod{
	AVERAGE, 
	MULTIPLICATION,
	MINIMUM,
	MAXIMUM,
	ADDITION,
	GEOMETRIC_MEAN,
	HARMONIC_MEAN
	}
@export var compound: CompoundMethod = CompoundMethod.AVERAGE
var _compounder: MATHCompounder = MATHCompounder.new()
var _scorer_list: Array[UTILScorer]

var _is_initialized := false

var aggregate_score: float: set = set_score, get = get_score

func set_score(value: float):
	aggregate_score = value
func get_score():
	return aggregate_score



# Methods that allow for adding and removing UTILScorer instances, and also clearing the list of its UTILScorer nodes.

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





# Functions that initializes the UTILAggregator node after entering the scene tree.

func _ready():
	_initialize()

func _initialize():
	set_score(0)
	_gather_scorers()
	_check_scorer_list()
	_is_initialized = true

func _gather_scorers():
	_scorer_list.clear()
	var scorer_children = get_children()
	add_scorer(scorer_children)

func _check_scorer_list():
	if _scorer_list.size() <= 0:
		push_error("UTILAggregator doesn't have a list of UTILScorer nodes.")
		assert(_scorer_list.size() > 0,"UTILAggregator doesn't have a list of UTILScorer nodes.")





# Updates the scorers and combines their scores. Called upon by either parent UTILScorer or UTILAction nodes.
func _update_score():
	if not _is_initialized:
		_initialize()
	for scorer in _scorer_list:
		scorer._update_score()
	_aggregate_scorers()

# Combines scores and set the result as the UTILAggregate's score.
func _aggregate_scorers():
	var scores_list: Array[float] = []
	for scorer in _scorer_list:
		var value: float = scorer.get_score()
		scores_list.append(value)
	var score = _compounder.calculate(scores_list, compound)
	set_score(score)
