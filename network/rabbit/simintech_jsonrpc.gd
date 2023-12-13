class_name SimintechJSONRPC
extends JSONRPC

signal signals_updated(signals: Dictionary)

## Execute from client, used process_action
func update_signals(signals: Dictionary) -> void:
	signals_updated.emit(signals)
	Log.trace(str(signals))
	Log.debug("Обновление сигналов")
