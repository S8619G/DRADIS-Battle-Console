extends RefCounted
## Arcade high score table: top entries with three upper-case initials.
## Saved as a small JSON file in Godot's user data folder so it survives
## restarts. Writes go to a temporary file first and are checked before they
## replace the old table; an unreadable table is backed up, never discarded.

const LETTERS := "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

static func clean_initials(text: String) -> String:
	var result := ""
	for character in text.to_upper():
		if LETTERS.contains(character):
			result += character
		if result.length() == 3:
			break
	while result.length() < 3:
		result += "A"
	return result

static func _clean_entries(raw: Variant, slots: int) -> Array:
	var entries: Array = []
	if typeof(raw) != TYPE_ARRAY:
		return entries
	for item in raw:
		if typeof(item) != TYPE_DICTIONARY or not item.has("score"):
			continue
		entries.append({
			"initials": clean_initials(str(item.get("initials", "AAA"))),
			"score": maxi(0, int(item.get("score", 0))),
			"wave": maxi(1, int(item.get("wave", 1))),
			"difficulty": str(item.get("difficulty", "N")) if str(item.get("difficulty", "N")) in ["E", "N", "H"] else "N"
		})
	# Highest first; equal scores keep their saved order.
	var ordered: Array = []
	for entry in entries:
		var index := ordered.size()
		while index > 0 and ordered[index - 1].score < entry.score:
			index -= 1
		ordered.insert(index, entry)
	return ordered.slice(0, maxi(1, slots))

## Returns {"scores": Array, "last_initials": String, "note": String}.
static func load_board(path: String, slots: int = 10) -> Dictionary:
	var board := {"scores": [], "last_initials": "AAA", "note": ""}
	if not FileAccess.file_exists(path):
		return board
	var text := FileAccess.get_file_as_string(path)
	var parsed: Variant = _parse(text)
	if typeof(parsed) != TYPE_DICTIONARY:
		# Keep the unreadable file for recovery instead of overwriting it.
		var backup := path + ".unreadable-%d.bak" % int(Time.get_unix_time_from_system())
		DirAccess.copy_absolute(ProjectSettings.globalize_path(path), ProjectSettings.globalize_path(backup))
		board.note = "HIGH SCORE FILE UNREADABLE | BACKED UP"
		return board
	board.scores = _clean_entries(parsed.get("scores", []), slots)
	board.last_initials = clean_initials(str(parsed.get("last_initials", "AAA")))
	return board

static func qualifies(scores: Array, score: int, slots: int = 10) -> bool:
	if score <= 0:
		return false
	if scores.size() < slots:
		return true
	return score > int(scores[slots - 1].score)

## Inserts below any equal scores. Returns the 0-based row, or -1 if it did not place.
static func insert(scores: Array, initials: String, score: int, wave: int, slots: int = 10, difficulty: String = "N") -> int:
	if not qualifies(scores, score, slots):
		return -1
	var index := scores.size()
	while index > 0 and int(scores[index - 1].score) < score:
		index -= 1
	scores.insert(index, {"initials": clean_initials(initials), "score": score, "wave": maxi(1, wave), "difficulty": difficulty if difficulty in ["E", "N", "H"] else "N"})
	while scores.size() > slots:
		scores.pop_back()
	return index if index < slots else -1

static func save_board(path: String, scores: Array, last_initials: String) -> bool:
	var data := {"version": 1, "last_initials": clean_initials(last_initials), "scores": scores}
	var text := JSON.stringify(data, "  ")
	var temporary := path + ".tmp"
	var file := FileAccess.open(temporary, FileAccess.WRITE)
	if file == null:
		push_warning("High scores could not be saved: %s" % temporary)
		return false
	file.store_string(text)
	file.close()
	# Verify the new copy reads back before it replaces the old table.
	var check: Variant = _parse(FileAccess.get_file_as_string(temporary))
	if typeof(check) != TYPE_DICTIONARY or (check.get("scores", []) as Array).size() != scores.size():
		push_warning("High score save did not verify; previous table kept")
		return false
	var error := DirAccess.rename_absolute(ProjectSettings.globalize_path(temporary), ProjectSettings.globalize_path(path))
	if error != OK:
		push_warning("High score file could not be replaced (error %d); previous table kept" % error)
		return false
	return true


static func _parse(text: String) -> Variant:
	# Quiet parse: a damaged file returns null instead of printing an engine error.
	var json := JSON.new()
	if json.parse(text) != OK:
		return null
	return json.data
