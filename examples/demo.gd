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
	
	obs_websocket.establish_connection()
	
	await obs_websocket.connection_authenticated
	
	obs_websocket.send_command("GetVersion")
	
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
