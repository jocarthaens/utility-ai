@icon("res://UtilityAI/icons/utilconsider.svg")
extends UTILScorer
class_name UTILConsideration


@export var response_curve: Curve:
	set(value): response_curve = value
@export var use_custom_response_function: bool = false

var consider_data: float = 0.0
var consider_score: float: set = set_score, get = get_score

func set_score(value: float):
	consider_score = value
func get_score() -> float:
	return consider_score




# Main update method that calculates the consideration value.
func _update_score():
	consider_data = gather_consider_data()
	var value: float = (_apply_response_curve(consider_data) if not use_custom_response_function 
			else apply_response_function(consider_data))
	#print(name + "_data = "+ str(consider_data))
	#print(name + " = "+ str(value))
	set_score(value)



# Should be overridden to obtain consideration data for calculations
## Overridable method for obtaining source of consideration data.
## Must be overriden to obtain consideration data for utility calculations.
func gather_consider_data(): return 0.0

# Override this function if use_custom_response_function is enabled.
# This will be used instead of response curve to generate a consideration score.
## Overridable method for creating custom response functions.
## This will be used instead of the response curve if UseCustomResponse is activated.
func apply_response_function(_data): return 0.0


# Uses a curve function that calculates consideration data to generate a consideration score.
func _apply_response_curve(data: float):
	if response_curve == null:
		push_error("Response curve hasn't been set.")
		assert(response_curve != null,"Response curve hasn't been set.")
		return 0.0
	return response_curve.sample_baked(data)




# Helper methods in generating the utility score.

## Method to be called inside gather_consider_data() in getting consideration data via object's properties.
func get_data_from_object(object, property_name: StringName) -> float: 
	if (object == null || (object.has_method(property_name) == false && object.get(property_name) == null)):
		if (object == null):
			push_error("Specified object not found.")
			assert(object != null,"Specified object not found.")
		elif (object != null):
			if (object.get(property_name) == null):
				push_error("Variable not found in object.")
				assert(object.get(property_name) != null,"Variable not found in object.")
			if (object.has_method(property_name) == false):
				push_error("Method not found in object")
				assert(object.has_method(property_name) != false,"Method not found in object.")
		return 0.0
	else:
		var value =  object.call(property_name) if object.has_method(property_name) else object.get(property_name)
		if typeof(value) == TYPE_BOOL:
			return 1.0 if (value == true) else 0.0
		return value

# Call this function within gather_consider_data() to normalize consider_data.
## Normalizes values by dividing it to a specified max value.
func normalize_data(value: float, max_value: float) -> float: 
	var normalized_value := value / max_value
	return normalized_value
	
# Call this function within gather_consider_data() to clamp consider_data.
## Clamps values to specified parameters.
func clamp_data(value: float, max_value: float, min_value: float = 0) -> float: 
	var clamped_value := clampf(value, min_value, max_value)
	return clamped_value
