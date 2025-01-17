extends CanvasLayer

# QR
var QR_TEXT := ""
var QR_ERROR_CORRECTION := 0


const LABEL_NOTIF = preload("res://label_notif.tscn")
@onready var center: Control = $CENTER
@onready var accept_dialog: AcceptDialog = $AcceptDialog
@onready var color_rect: ColorRect = $ColorRect

@onready var qr_box: VBoxContainer = $AcceptDialog/qr_box
@onready var qr_text: Label = $AcceptDialog/qr_box/qr_text
@onready var qr_code: TextureRect = $AcceptDialog/qr_box/QrCode

func _ready() -> void:
	color_rect.hide()
	accept_dialog.hide()

func _notif(st:String,tim:float = 3.0):
	var u = LABEL_NOTIF.instantiate()
	center.add_child(u)
	u._msg(st,tim)

func _dialog(st:String) -> void:
	qr_box.hide()
	accept_dialog.show()
	accept_dialog.dialog_text = st

func _dark(b:bool) -> void:
	color_rect.visible = b

func _qr() -> void:
	_dialog("")
	
	var qr: QrCode = QrCode.new()
	qr.error_correct_level = QR_ERROR_CORRECTION
	var pic: ImageTexture = qr.get_texture(QR_TEXT)
	qr_text.text = QR_TEXT
	qr_code.texture = pic
	qr_box.show()
