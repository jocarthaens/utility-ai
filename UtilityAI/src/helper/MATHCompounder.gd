extends RefCounted
class_name MATHCompounder

enum Compound {
	AVERAGE,
	MULTIPLICATION,
	MINIMUM,
	MAXIMUM,
	ADDITION,
	GEOMETRIC_MEAN,
	HARMONIC_MEAN}
var compoundMethodHandler = {
	Compound.AVERAGE: average,
	Compound.MULTIPLICATION: multiply, 
	Compound.MINIMUM: minimum, 
	Compound.MAXIMUM: maximum,
	Compound.ADDITION: add, 
	Compound.GEOMETRIC_MEAN: geometric,
	Compound.HARMONIC_MEAN: harmonic
	}
var compoundMethod = Compound.AVERAGE
var numberArray: Array


func calculate(_numberArray: Array, _compoundMethod):
	numberArray = _numberArray
	compoundMethod = _compoundMethod
	return compoundMethodHandler[compoundMethod].call()


func average():
	var score: float = 0.0
	for value in numberArray:
		score += value
	score /= float(numberArray.size())
	return score

func multiply():
	var score: float = 1.0
	for value in numberArray:
		score *= value
		if score == 0: break
	return score

func minimum():
	var minScore: float = INF
	for value in numberArray:
		if value < minScore:
			minScore = value
	return minScore

func maximum():
	var maxScore: float = 0.0
	for value in numberArray:
		if value > maxScore:
			maxScore = value
	return maxScore

func add():
	var score: float = 0.0
	for value in numberArray:
		score += value
	return score

func geometric():
	var score: float = 1
	for value in numberArray:
		score *= value
		if score == 0: break
	score = pow(score, 1.0/float(numberArray.size()))
	return score

func harmonic():
	var score: float = 0.0
	for value in numberArray:
		score += value
	score = float(numberArray.size())/score
	return score
