extends UTILConsideration


# Should be overridden to obtain consideration data for calculations
## Overridable method for obtaining source of consideration data.
## Must be overriden to obtain consideration data for utility calculations.
func gather_consider_data():
	var found_wood: bool = (%SurvivorBrain.nearest_wood != null 
			|| %SurvivorBrain.nearest_wood_tree != null 
			&& %SurvivorBrain.nearest_wood_tree.has_wood() == true);
	return found_wood;

# Override this function if use_custom_response_function is enabled.
# This will be used instead of response curve to generate a consideration score.
## Overridable method for creating custom response functions.
## This will be used instead of the response curve if UseCustomResponse is activated.
func apply_response_function(data):
	return data;
