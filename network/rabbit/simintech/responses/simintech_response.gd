class_name SimintechResponse
extends RefCounted

var trans_id: String
var reply: String

func is_success() -> bool:
	return reply == "ok"

static func create_from_json(json: Dictionary) -> SimintechResponse:
	var response = SimintechResponse.new()
	response.trans_id = json["trans_id"]
	response.reply = json["reply"]
	return response
