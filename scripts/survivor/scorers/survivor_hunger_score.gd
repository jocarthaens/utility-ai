extends UTILConsideration


# Should be overridden to obtain consideration data for calculations
## Overridable method for obtaining source of consideration data.
## Must be overriden to obtain consideration data for utility calculations.
func gather_consider_data():
	var score: float = get_data_from_object(%SurvivorBrain, "hunger");
	var max_score: float = get_data_from_object(%SurvivorBrain, "max_hunger");
	return score / max_score;

# Override this function if use_custom_response_function is enabled.
# This will be used instead of response curve to generate a consideration score.
## Overridable method for creating custom response functions.
## This will be used instead of the response curve if UseCustomResponse is activated.
func apply_response_function(_data):
	return 0.0
