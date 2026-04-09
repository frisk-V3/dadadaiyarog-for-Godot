extends CanvasLayer

@onready var face_rect: TextureRect = $Panel/HBoxContainer/TextureRect
@onready var name_label: Label = $Panel/HBoxContainer/VBoxContainer/NameLabel
@onready var text_label: RichTextLabel = $Panel/HBoxContainer/VBoxContainer/TextLabel

# ここを「システム紹介」っぽい無難な内容に差し替えました
var dialog = [
	{
		"name": "案内人",
		"text": "ようこそ。ここは、新しい物語を構築するためのテストルームです。",
		"face": "res://faces/unknown.png"
	},
	{
		"name": "案内人",
		"text": "このシステムを使えば、簡単にキャラクターの会話を実装できますよ。",
		"face": "res://faces/unknown_smile.png"
	},
	{
		"name": "プレイヤー",
		"text": "なるほど……。このテキストは、後から自由に変更できるわけだね。",
		"face": "res://faces/you.png"
	}
]

var current_index := 0
var char_index := 0
var full_text := ""
var is_typing := false
var type_speed := 0.03
var time_accum := 0.0

func _ready() -> void:
	show_line()

func show_line() -> void:
	if current_index >= dialog.size():
		queue_free()
		return
	
	var line = dialog[current_index]
	
	if line.has("face"):
		# 実行時にエラーが出ないよう、ファイルがあるか確認する処理を入れるとより親切です
		if ResourceLoader.exists(line["face"]):
			face_rect.texture = load(line["face"])
	
	name_label.text = line["name"]
	full_text = line["text"]
	text_label.text = ""
	
	char_index = 0
	is_typing = true
	time_accum = 0.0

func _process(delta: float) -> void:
	if not is_typing:
		return
	
	time_accum += delta
	while time_accum >= type_speed and is_typing:
		time_accum -= type_speed
		if char_index < full_text.length():
			text_label.text += full_text[char_index]
			char_index += 1
		else:
			is_typing = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		if is_typing:
			text_label.text = full_text
			is_typing = false
		else:
			current_index += 1
			show_line()
