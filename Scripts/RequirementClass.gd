class_name Requirement

var req: Variant
var arguments: Array #type variants


func save():
	return {
		'req':req,
		'arguments':arguments
	}
	
func load_data(data):
	req = data['req']
	arguments = data['arguments']
