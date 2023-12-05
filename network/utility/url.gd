class_name Url
extends RefCounted

static func with_parameters(url: String, parameters: Dictionary) -> String:
	var result = url + "?"
	for key in parameters.keys():
		var origin_query_parameter = query_string_format(str(parameters[key]))
		result += str(key) + "=" + origin_query_parameter + "&"
	return result

static func query_string_format(origin: String) -> String:
	return origin.replace(" ", "%20")
