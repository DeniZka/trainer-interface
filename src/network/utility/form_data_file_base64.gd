class_name FormDataFileBase64
extends FormDataItem

func body_to_utf8() -> PackedByteArray:
	return Marshalls.base64_to_raw(content)
