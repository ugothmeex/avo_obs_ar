extends TabContainer

@export var OBS: Class_OBS

@onready var http_request: HTTPRequest = %HTTPRequest
@onready var btn_photo: Button = %btn_photo
@onready var btn_video: Button = %btn_video
@onready var lb_namescene: Label = %lb_namescene

@onready var btn_upload_last: Button = %btn_upload_last
@onready var btn_upload_manual: Button = %btn_upload_manual
@onready var file_dialog_manual_upload: FileDialog = %FileDialog_manual_upload

@onready var tx_ip: LineEdit = %tx_ip
@onready var tx_password: LineEdit = %tx_password
@onready var tx_port: LineEdit = %tx_port

var Last_Pic_Name := ""
var Last_Pic_Path := ""
#! editables

@onready var tx_namescene: LineEdit = %tx_namescene
@onready var lb_pic_path: Label = %lb_pic_path
@onready var tx_video_timer: SpinBox = $Settings/VBoxContainer/HBoxContainer2/tx_video_timer
@onready var error_correction_level: OptionButton = %error_correction_level
@onready var tx_linkwebsite: LineEdit = %tx_linkwebsite


func _ready() -> void:
	http_request.request_completed.connect(_on_http_request_completed)
	
	error_correction_level.add_item("Low", QrCode.ErrorCorrectionLevel.LOW)
	error_correction_level.add_item("Medium", QrCode.ErrorCorrectionLevel.MEDIUM)
	error_correction_level.add_item("Quartile", QrCode.ErrorCorrectionLevel.QUARTILE)
	error_correction_level.add_item("High", QrCode.ErrorCorrectionLevel.HIGH)
	
	$Home.show()


func _on_btn_load_default_pressed() -> void:
	tx_namescene.text = "Scene"
	lb_pic_path.text = "_"
	tx_video_timer.value = 5
	error_correction_level.select(0)
	tx_linkwebsite.text = "https://avolutioninc.net/fotoar/"


func _on_btn_video_pressed() -> void:
	OBS.obs_websocket.send_command("StartRecord")
	await get_tree().create_timer(5.0).timeout
	OBS.obs_websocket.send_command("StopRecord")


func _on_btn_photo_pressed() -> void:
	var txsc = str(tx_namescene.text)
	var dir = str(lb_pic_path.text)
	if not DirAccess.dir_exists_absolute(dir):
		G._dialog(str("Wrong path: ",dir))
		return
	
	G._dark(true)
	var tim = Time.get_datetime_string_from_system()
	var string_time = tim.replacen(":","")
	Last_Pic_Name = str("pic-",string_time,".png")
	Last_Pic_Path = str(dir,"\\",Last_Pic_Name)
	OBS.obs_websocket.send_command("SaveSourceScreenshot",{
		"sourceName":txsc,
		"imageFormat":"png",
		"imageFilePath":Last_Pic_Path}
	)
	await get_tree().create_timer(2.0).timeout
	G._dark(false)


func _on_btn_upload_last_pressed() -> void:
	G._dark(true)
	G._notif("Wait, 5s")
	_upload_image2(Last_Pic_Path)
	await get_tree().create_timer(5.0).timeout
	G._dark(false)
	


func _on_btn_upload_manual_pressed() -> void:
	file_dialog_manual_upload.show()
func _on_file_dialog_manual_upload_file_selected(path: String) -> void:
	Last_Pic_Name = path.get_file()
	G._dark(true)
	G._notif("Wait, 5s")
	_upload_image2(path)
	await get_tree().create_timer(5.0).timeout
	G._dark(false)

func _upload_image2(image_path: String):
	# Open the image file
	var file = FileAccess.open(image_path, FileAccess.ModeFlags.READ)
	if file == null:
		#print("Failed to open the image file.")
		G._dialog("Failed to open the image file.")
		return

	# Read the file content
	var file_content = file.get_buffer(file.get_length())
	file.close()

	# Create the body for multipart/form-data
	var boundary = "----WebKitFormBoundary" + str(Time.get_ticks_usec())  # Getting microseconds
   
	var body = PackedByteArray()
	var tim = Time.get_datetime_string_from_system().replacen(":","")
	# Prepare the multipart/form-data body
	body.append_array(("--" + boundary + "\r\n").to_utf8_buffer())  # Boundary start
	body.append_array(str("Content-Disposition: form-data; name=\"image\"; filename=\"",Last_Pic_Name,"\"\r\n").to_utf8_buffer())  # Content-Disposition header
	#body.append_array("Content-Disposition: form-data; name=\"image\"; filename=\"image.png\"\r\n".to_utf8_buffer())  # Content-Disposition header
	body.append_array("Content-Type: image/png\r\n\r\n".to_utf8_buffer())  # Content-Type header
	body.append_array(file_content)  # Image content
	body.append_array(("\r\n--" + boundary + "--\r\n").to_utf8_buffer())  # Boundary end

	# Set headers for multipart/form-data with boundary
	var headers = PackedStringArray()
	headers.append("Content-Type: multipart/form-data; boundary=" + boundary)

	# Perform the HTTP POST request
	var error = http_request.request_raw(
		str(tx_linkwebsite.text),  # Replace with your PHP URL
		headers,
		HTTPClient.Method.METHOD_POST,
		body
	)
	
	if error != OK:
		print("An error occurred in the HTTP request.")
	
	

func _on_http_request_completed(result: int, response_code: int, headers: Array, body: PackedByteArray):
	if response_code != 200:
	#	print("Request failed with response code:", response_code)
		G._dialog(str("Request failed with response code:", response_code))
		return

	# Parse the response
	var response_text = body.get_string_from_utf8()
	print("Response from server:", response_text)
	
	var json = JSON.new()
	var parse_result = json.parse(response_text)
	print(parse_result)
	if parse_result == OK:
		var response = json.get_data()
		if response.success:
			#G._dialog(str("Upload success:", response.message," *File saved at:", response.file_path))
			G.QR_TEXT = str(tx_linkwebsite.text,"uploads/",Last_Pic_Name)
			G.QR_ERROR_CORRECTION = error_correction_level.selected
			G._qr()
		else:
			G._dialog(str("Upload failed:", response.message))
	else:
		G._dialog("Failed to parse server response.")

@onready var file_dialog_pic_path: FileDialog = %FileDialog_pic_path

func _on_btn_pic_path_pressed() -> void:
	file_dialog_pic_path.show()

func _on_file_dialog_pic_path_file_selected(path: String) -> void:
	lb_pic_path.text = path


func _on_file_dialog_pic_path_dir_selected(dir: String) -> void:
	lb_pic_path.text = dir


func _on_btn_connect_pressed() -> void:
	pass # Replace with function body.
