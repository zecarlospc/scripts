extends CharacterBody3D

@export_category("Settings Player")
@export var speed = 5.0
@export var jump_force = 4.5

@export_category("Settings Mouse")
@export var mouse_sensivity := 0.2
@export var camera_limit_down := -80.0
@export var camera_limit_up := 60.0

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var cam_ver := 0.0

func _ready() -> void:
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent) -> void:
    if event is InputEventMouseNotion:
        rotate_y(deg_to_rad(-event.relative.x * mouse_sensivity))

        cam_ver -= event.relative.y * mouse_sensivity
        cam_ver = clamp(cam_ver, camera_limit_down, camera_limit_up)
        $head/vertical.rotation_degrees.x = cam_ver

    if Input.is_action_just_pressed("ui_cancel"):
        Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _physics_process(delta: float) -> void:
#gravity
    if not is_on_floor():
        velocity.y -= gravity * delta

#handle jump
    if Input.is_action_just_pressed("ui_accept") and is_on_floor():
        velocity.y = jump_force

#movement
    var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
    var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
    if direction:
        velocity.x = direction.x * speed
        velocity.z = direction.z * speed
    else:
        velocity.x = move_toward(velocity.x, 0, speed)
        velocity.z = move_toward(velocity.z, 0, speed)

    move_and_slice()