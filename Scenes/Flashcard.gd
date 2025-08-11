extends MarginContainer

var correct_answers = 0

signal flashcards_done

var level1 = preload("res://Resources/level1_list.gd").list1
var level2 = preload("res://Resources/level2_list.gd").list2
var level3 = preload("res://Resources/level3_list.gd").list3

var list = {}
var current_word = ""

# Called when the node enters the scene tree
func _ready():
	# Connect the confirm and submit buttons
	$ConfirmButton.pressed.connect(_on_confirm_pressed)
	$SubmitButton.pressed.connect(_on_submit_pressed)
	
	# Initially hide quiz UI until list is selected
	$SubmitButton.visible = false
	$QuestionLabel.visible = false
	$AnswerInput.visible = false
	$ResultLabel.visible = false

func _on_confirm_pressed():
	var SelectedList = $ListSelect.text
	
	if SelectedList == "1":
		list = words1
	elif SelectedList == "2":
		list = words2
	elif SelectedList == "3":
		list = list3
	else:
		$ResultLabel.text = "Invalid list number. Enter 1 or 2."
		$ResultLabel.visible = true
		return
		
	# Hide selection UI
	$ListSelect.visible = false
	$ConfirmButton.visible = false

	# Show quiz UI
	$SubmitButton.visible = true
	$QuestionLabel.visible = true
	$AnswerInput.visible = true
	$ResultLabel.visible = true

	ask_question()


# Function to ask a new word question
func ask_question():
	var word_keys = list.keys()
	var random_index = randi() % word_keys.size()
	current_word = word_keys[random_index]
	
	# Update UI
	$QuestionLabel.text = "%s" % current_word
	$AnswerInput.text = ""
	$ResultLabel.text = ""

# Called when the submit button is pressed
func _on_submit_pressed():
	var user_answer = $AnswerInput.text.strip_edges().to_lower()
	var correct_answer = list[current_word]
	
	if user_answer == correct_answer:
		$ResultLabel.text = "Correct!"
		correct_answers += 1
	else:
		$ResultLabel.text = "Wrong! Correct answer: %s" % correct_answer
	
	if correct_answers == 3:
		await get_tree().create_timer(3).timeout
		emit_signal("flashcards_done")
		correct_answers = 0
	if correct_answers < 3:
		await get_tree().create_timer(3).timeout
		ask_question()
