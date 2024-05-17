class_name Url
extends RefCounted

static func with_parameters(url: String, parameters: Dictionary) -> String:
	var result = url + "?"
	for key in parameters.keys():
		var query_parameter = str(parameters[key]).uri_encode()
		result += str(key) + "=" + query_parameter + "&"
	return result
