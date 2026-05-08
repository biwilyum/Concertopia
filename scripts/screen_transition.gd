extends CanvasLayer
# Horizontal-only slide transition. Pure X-axis movement, no Y involvement.
# Usage: ScreenTransition.go("res://screens/foo.tscn", "left" or "right")

var _active      : bool   = false
var _committing  : bool   = false
var _dragging    : bool   = false
var _auto_commit : bool   = false

var _ignore_until_release : bool = false

var _direction   : String = "left"
var _target_path : String = ""

var _vp_w         : float = 0.0
var _vp_h         : float = 0.0
var _drag_start_x : float = 0.0
var _current_x    : float = 0.0

var _clip       : Control = null
var _cur_wrap   : Control = null
var _nxt_wrap   : Control = null
var _snap_tween : Tween   = null

const SLIDE_DUR : float = 0.35
const SNAP_DUR  : float = 0.28
const THRESHOLD : float = 0.5

func _ready() -> void:
	layer        = 128
	process_mode = Node.PROCESS_MODE_ALWAYS
	offset       = Vector2(0.0, 0.0)

# ── Public ─────────────────────────────────────────────────────────────────────

func go(target_path: String, direction: String) -> void:
	if _active or _committing:
		return

	_direction   = direction
	_target_path = target_path

	var vp_rect : Rect2 = get_viewport().get_visible_rect()
	_vp_w = vp_rect.size.x
	_vp_h = vp_rect.size.y
	offset = Vector2(0.0, 0.0)

	# Hide real scene so it cannot bleed through the overlay
	var real_scene : Node = get_tree().current_scene
	if real_scene is CanvasItem:
		(real_scene as CanvasItem).visible = false

	# ── Clip container ────────────────────────────────────────────────────────
	_clip               = Control.new()
	_clip.set_anchors_preset(Control.PRESET_TOP_LEFT)
	_clip.position      = Vector2(0.0, 0.0)
	_clip.size          = Vector2(_vp_w, _vp_h)
	_clip.clip_contents = true
	_clip.mouse_filter  = Control.MOUSE_FILTER_IGNORE
	add_child(_clip)

	# ── Current scene wrapper ─────────────────────────────────────────────────
	var cur_inner : Control = _load_scene(real_scene.scene_file_path)
	_cur_wrap = _make_wrapper(Vector2(0.0, 0.0), cur_inner)
	_clip.add_child(_cur_wrap)

	# ── Next scene wrapper ────────────────────────────────────────────────────
	var nxt_inner : Control = _load_scene(target_path)
	_nxt_wrap = _make_wrapper(Vector2(_nxt_start_x(), 0.0), nxt_inner)
	_clip.add_child(_nxt_wrap)

	_active               = true
	_dragging             = false
	_current_x            = 0.0
	_auto_commit          = true
	_ignore_until_release = true

# ── Scene loader ──────────────────────────────────────────────────────────────

func _load_scene(path: String) -> Control:
	var res   : PackedScene = load(path) as PackedScene
	var inner : Control     = res.instantiate() as Control
	# Strip all anchor influence — position+size are the sole layout authority.
	# This prevents anchor math introducing Y offset inside the wrapper.
	inner.anchor_left   = 0.0
	inner.anchor_top    = 0.0
	inner.anchor_right  = 0.0
	inner.anchor_bottom = 0.0
	inner.offset_left   = 0.0
	inner.offset_top    = 0.0
	inner.offset_right  = 0.0
	inner.offset_bottom = 0.0
	inner.position      = Vector2(0.0, 0.0)
	inner.size          = Vector2(_vp_w, _vp_h)
	return inner

func _make_wrapper(pos: Vector2, inner: Control) -> Control:
	var wrap : Control = Control.new()
	wrap.set_anchors_preset(Control.PRESET_TOP_LEFT)
	wrap.position      = pos
	wrap.size          = Vector2(_vp_w, _vp_h)
	wrap.clip_contents = false
	wrap.mouse_filter  = Control.MOUSE_FILTER_IGNORE
	wrap.add_child(inner)
	return wrap

func _nxt_start_x() -> float:
	return _vp_w if _direction == "left" else -_vp_w

# ── Process ───────────────────────────────────────────────────────────────────

func _process(_dt: float) -> void:
	if _active and _auto_commit and not _dragging and not _committing:
		_auto_commit = false
		_commit()

# ── Input ─────────────────────────────────────────────────────────────────────

func _input(event: InputEvent) -> void:
	if not _active or _committing:
		return

	if _ignore_until_release:
		var released : bool = false
		if event is InputEventScreenTouch:
			released = not (event as InputEventScreenTouch).pressed
		elif event is InputEventMouseButton:
			released = not (event as InputEventMouseButton).pressed
		if released:
			_ignore_until_release = false
		return

	if event is InputEventScreenTouch:
		var e : InputEventScreenTouch = event
		if e.pressed:
			_auto_commit = false
			_drag_start(e.position.x)
		else:
			_drag_end()

	elif event is InputEventScreenDrag:
		var e : InputEventScreenDrag = event
		_auto_commit = false
		_drag_move(e.position.x)

	elif event is InputEventMouseButton:
		var e : InputEventMouseButton = event
		if e.button_index == MOUSE_BUTTON_LEFT:
			if e.pressed:
				_auto_commit = false
				_drag_start(e.position.x)
			else:
				_drag_end()

	elif event is InputEventMouseMotion:
		var e : InputEventMouseMotion = event
		if _dragging:
			_auto_commit = false
			_drag_move(e.position.x)

# ── Drag ──────────────────────────────────────────────────────────────────────

func _drag_start(x: float) -> void:
	if _snap_tween != null and _snap_tween.is_running():
		_snap_tween.kill()
	_dragging     = true
	_drag_start_x = x

func _drag_move(x: float) -> void:
	if not _dragging:
		return
	var raw : float = x - _drag_start_x
	var lo  : float = -_vp_w if _direction == "left" else 0.0
	var hi  : float = 0.0    if _direction == "left" else _vp_w
	_current_x = clampf(raw, lo, hi)
	_slide_panels(_current_x)

func _drag_end() -> void:
	if not _dragging:
		return
	_dragging = false
	var progress : float = absf(_current_x) / _vp_w
	if progress >= THRESHOLD:
		_commit()
	else:
		_snap_back()

# ── Panel movement — X only, Y locked to 0.0 ─────────────────────────────────

func _slide_panels(slide_x: float) -> void:
	if _cur_wrap == null or _nxt_wrap == null:
		return
	_cur_wrap.position = Vector2(slide_x, 0.0)
	_nxt_wrap.position = Vector2(_nxt_start_x() + slide_x, 0.0)

# ── Snap back ─────────────────────────────────────────────────────────────────

func _snap_back() -> void:
	_snap_tween = create_tween()
	_snap_tween.set_ease(Tween.EASE_OUT)
	_snap_tween.set_trans(Tween.TRANS_CUBIC)
	_snap_tween.set_parallel(true)
	_snap_tween.tween_property(
		_cur_wrap, "position:x", 0.0, SNAP_DUR
	)
	_snap_tween.tween_property(
		_nxt_wrap, "position:x", _nxt_start_x(), SNAP_DUR
	)
	_snap_tween.set_parallel(false)
	await _snap_tween.finished
	_restore_real_scene()
	_teardown()

# ── Commit ────────────────────────────────────────────────────────────────────
# Safe scene-change sequence:
#   1. Slide tween plays to completion (await is safe — no tree mutation yet)
#   2. call_deferred schedules the scene change for the END of this frame,
#      after all coroutines have yielded. This avoids mutating the tree while
#      _commit() is still on the call stack.
#   3. The overlay stays alive (layer=128) covering the load gap.
#   4. A tween_callback on a fresh tween fires _teardown() one frame later,
#      after the new scene's _ready() has run. No await needed — no coroutine
#      resumes on a freed context.

func _commit() -> void:
	_committing  = true
	_auto_commit = false
	var done_x : float = -_vp_w if _direction == "left" else _vp_w

	# Step 1 — slide to completion
	_snap_tween = create_tween()
	_snap_tween.set_ease(Tween.EASE_OUT)
	_snap_tween.set_trans(Tween.TRANS_CUBIC)
	_snap_tween.set_parallel(true)
	_snap_tween.tween_property(
		_cur_wrap, "position:x", done_x, SLIDE_DUR
	)
	_snap_tween.tween_property(
		_nxt_wrap, "position:x", 0.0, SLIDE_DUR
	)
	_snap_tween.set_parallel(false)
	await _snap_tween.finished

	# Step 2 — schedule the scene change safely at end-of-frame.
	# call_deferred ensures no tree mutation while this coroutine is live.
	get_tree().change_scene_to_file.call_deferred(_target_path)

	# Step 3 — wait two frames via a fresh tween (no await on process_frame
	# which can resume on a stale coroutine context after scene swap).
	# Frame 1: scene tree swap completes.
	# Frame 2: new scene _ready() and deferred calls have run.
	# Then teardown — overlay drops with new scene already rendered under it.
	var wait_tween : Tween = create_tween()
	wait_tween.tween_interval(0.0)
	await wait_tween.finished
	var wait_tween2 : Tween = create_tween()
	wait_tween2.tween_interval(0.0)
	await wait_tween2.finished

	_teardown()

# ── Restore real scene on snap-back ──────────────────────────────────────────

func _restore_real_scene() -> void:
	var real_scene : Node = get_tree().current_scene
	if real_scene is CanvasItem:
		(real_scene as CanvasItem).visible = true

# ── Cleanup ───────────────────────────────────────────────────────────────────

func _teardown() -> void:
	_cur_wrap = null
	_nxt_wrap = null
	if _clip != null:
		_clip.queue_free()
		_clip = null
	_active               = false
	_committing           = false
	_dragging             = false
	_auto_commit          = false
	_ignore_until_release = false
