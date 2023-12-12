class_name ReadSignalsSimintechResponse
extends SimintechResponse

var command_name: String
var command_number: int
var signal_names: Array
var signal_values: Array
var signal_types: Array

func _to_string() -> String:
	return "Read Signals Simintech Resposne: %s" % { "trans_id": trans_id, 
	"reply": reply, "signal_names": signal_names, "signal_values": signal_values,
	"signal_types": signal_types }

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
