class_name ReadSignalsSimintechResponse
extends SimintechResponse

var command_name: String
var command_number: int
var signal_names: Array[String]
var signal_values: Array
var signal_types: Array[String]

static func create_from_json(json: Dictionary) -> ReadSignalsSimintechResponse:
	var response = ReadSignalsSimintechResponse.new()
	response.trans_id = json["trans_id"]
	response.reply = json["reply"]
	response.command_name = json["cmd"]
	response.command_number = json["cmd_num"]
	response.signal_names = json["sig_names_arr"]
	response.signal_values = json["sig_vals_arr"]
	response.signal_types = json["sig_types_arr"]
	return response
