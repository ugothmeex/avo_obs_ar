extends CanvasLayer
class_name Class_OBS

const ObsWebsocket: GDScript = preload("res://addons/obs-websocket-gd/obs_websocket.gd")
#const ObsUi: PackedScene = preload("res://addons/obs_websocket_gd/obs_ui.tscn")

var obs_websocket: Node
var obs_ui: Control

###############################################################################
# Builtin functions                                                           #
###############################################################################

func _ready() -> void:
	
	
	obs_websocket = ObsWebsocket.new()
	add_child(obs_websocket)
	
	#obs_websocket.connect("data_received", Callable(self,"_on_obs_data_received"))
	#obs_websocket.data_received.connect(func(data) -> void:
		#print(data)
	#)
	
	#obs_websocket.establish_connection()
	#
	#await obs_websocket.connection_authenticated
	#
	#obs_websocket.send_command("GetVersion")
	
	#prints("==>",obs_websocket.send_command("obs_frontend_get_streaming_service"))

###############################################################################
# Connections                                                                 #
###############################################################################

###############################################################################
# Private functions                                                           #
###############################################################################

###############################################################################
# Public functions                                                            #
###############################################################################

@onready var tx_ip: LineEdit = %tx_ip
@onready var tx_password: LineEdit = %tx_password
@onready var tx_port: LineEdit = %tx_port

func _on_btn_connect_pressed() -> void:
	obs_websocket.host = str(tx_ip.text)
	obs_websocket.password = str(tx_password.text)
	obs_websocket.port = str(tx_port.text)
	
	obs_websocket.establish_connection()
	await obs_websocket.connection_authenticated
	obs_websocket.send_command("GetVersion")
