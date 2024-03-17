extends Node2D

@onready var anima_player = $anima_player
@onready var audio_footstep = $"../audio_footstep"
@onready var timer = $"../Timer"

@onready var anima_painting = $"../Animation/anima_painting"
@onready var anima_broken = $"../Animation/anima_broken"
@onready var anima_artist = $"../Animation/anima_artist"
@onready var anima_writing = $"../Animation/anima_writing"



var frame_rate = 5.0
var audio_on = false
var painting_play_time = 0
var artist_ready = false


# Called when the node enters the scene tree for the first time.
func _ready():
	anima_painting.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	play_animation()
	play_loop_audio()
	play_artist_animation()
	
	

func play_animation():
	if frame_rate <= 24:
		if Input.is_anything_pressed():
			anima_player.play("Running")
			anima_player.sprite_frames.set_animation_speed("Running", frame_rate)
			frame_rate = frame_rate + 1.0
			self.scale = scale * 0.9
			audio_on = true
			
	else:
		if Input.is_anything_pressed():
			anima_player.stop()
			audio_footstep.stop()
			audio_on = false
			play_painting_frame()
			
func play_loop_audio():
	if audio_on and timer.time_left <=0:
		audio_footstep.pitch_scale = randf_range(0.8, 1.2)
		audio_footstep.play()
		timer.start(0.3)

func play_painting_frame():
	if painting_play_time == 0:
		anima_painting.visible = true
		anima_painting.play("set_up")
		painting_play_time = painting_play_time + 1

func play_artist_animation():
	if artist_ready and Input.is_anything_pressed():
		anima_artist.play("open")
		anima_writing.visible = true
		anima_writing.play("writing")
	else:
		anima_artist.play("idle")

func _on_anima_painting_animation_finished():
	anima_broken.visible = true
	anima_broken.play("broken")


func _on_anima_broken_animation_finished():
	anima_artist.visible = true
	anima_artist.play("showup")
	artist_ready = true
