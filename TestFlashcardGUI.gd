extends Control

# Dictionary of fruits and their colors
var fruits = {
	"apple": "red",
	"orange": "orange",
	"watermelon": "green",
	"banana": "yellow"
}

var current_fruit = ""

# Called when the node enters the scene tree
func _ready():
	# Connect the button signal
	$SubmitButton.pressed.connect(_on_submit_pressed)
	ask_question()

# Function to ask a new fruit question
func ask_question():
	var fruit_keys = fruits.keys()
	var random_index = randi() % fruit_keys.size()
	current_fruit = fruit_keys[random_index]
	
	# Update UI
	$QuestionLabel.text = "What is the color of %s?" % current_fruit
	$AnswerInput.text = ""
	$ResultLabel.text = ""

# Called when the submit button is pressed
func _on_submit_pressed():
	var user_answer = $AnswerInput.text.strip_edges().to_lower()
	var correct_answer = fruits[current_fruit]
	
	if user_answer == correct_answer:
		$ResultLabel.text = "✅ Correct!"
	else:
		$ResultLabel.text = "❌ Wrong! Correct answer: %s" % correct_answer
	
	# Ask next question after a short delay
	await get_tree().create_timer(1.5).timeout
	ask_question()
