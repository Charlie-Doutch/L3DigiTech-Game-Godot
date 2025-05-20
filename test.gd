extends Node  # The base class for a script attached to a scene node

class_name Flashcard  # Optional: gives your class a global name

# Member variable: fruit-color dictionary
var fruits = {
	"apple": "red",
	"orange": "orange",
	"watermelon": "green",
	"banana": "yellow"
}

func _ready():
	print("Welcome to fruit quiz")
	quiz()

# Quiz method
func quiz():
	while true:
		# Randomly pick a fruit-color pair
		var fruit_keys = fruits.keys()
		var random_index = randi() % fruit_keys.size()
		var fruit = fruit_keys[random_index]
		var color = fruits[fruit]

		print("What is the color of %s?" % fruit)
		
		# Read player input from the terminal (only works in the debugger/console)
		var user_answer = input_prompt("Type your answer: ").to_lower()

		if user_answer == color:
			print("Correct answer")
		else:
			print("Wrong answer")

		var option = int(input_prompt("Enter 0 if you want to play again: "))
		if option != 0:
			break
