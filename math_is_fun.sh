#!/bin/bash

function print_problem () {
	echo "What is $1 $3 $2 ?"
}

function get_operation () {
	local my_result=$1
	if [ $my_result == 1 ]; then
		my_result='+'
	elif [ $my_result == 2 ]; then
		my_result='-'
	elif [ $my_result == 3 ]; then
		my_result='/'
	else
		my_result='x'
	fi
	echo "$my_result"
}

play_again='y'

while [ $play_again = 'y' ]
do

echo "USER'S ANSWERS" > users_answers.txt
echo "ACTUAL ANSWERS" > actual_answers.txt
echo "QUESTIONS" > questions.txt

echo "How many math problems would you like?"
read num_probs

while [ $num_probs -lt 1 ]
do
	echo "Please enter a number greater than 0."
	read num_probs
done

echo "What difficulty? (1 = Hard, 2 = Med, 3 = Easy)"
read difficulty

while  [ 1 ]
do
	if [[ $difficulty == 1 || $difficulty == 2 || $difficulty == 3 ]]; then
		break
	else
		echo "Please enter an acceptable difficulty value"
		read difficulty
	fi
done


echo " "
echo "-----------------Instructions------------------"
echo "1. Input your answer and press enter"
echo "2. Give answer to one decimal for all division questions (i.e. 2.0, .3)."
echo "3. Input undef for all divide by 0."
echo " "

max=4
min=1
range=$(($max-$min+1))

# ask questions and store responses
for (( i=0; i < num_probs; i++))
do
	# Determine the integers to output
	div=$((10 ** (difficulty + 1)))
	val1=$(($RANDOM / $div)) 
	val2=$(($RANDOM / $div))

	# Determine the operation to output
	result_prelim=$RANDOM
	let "result_prelim %= $range"
	result=$(($result_prelim+$min)) # result = (1, 2, 3 or 4)
	operation=$(get_operation $result)

	# Compute and store the correct solution
	if [[ $val2 == 0 && $operation == '/' ]]; then
		echo "undef" >> actual_answers.txt
	elif [[ $operation == 'x' ]]; then
		echo "$val1 * $val2" | bc >> actual_answers.txt
	else
		 echo "scale=1; $val1 $operation  $val2" | bc >> actual_answers.txt
	
	fi
	
	# Prompt user with quetion and store response
	echo "Question $(($i+1)):"
	echo "$(print_problem $val1 $val2 $operation)" >> questions.txt
	print_problem $val1 $val2 $operation
	read guess
	echo $guess >> users_answers.txt
done 

echo " "
echo "-------Correct Answers to Missed Problems--------"
echo " "

# Compare results from the two .txt files
correct=0
for ((j=0; j < num_probs; j++))
do
	user=$(sed -n $(($j+2))'p' users_answers.txt)
	actual=$(sed -n $(($j+2))'p' actual_answers.txt)

	if [ $user == $actual ]; then
		correct=$((correct+1))
	else
		echo "Question $(($j+1)):"
		echo "$(sed -n $(($j+2))'p' questions.txt)"
                echo "User: $user || Actual: $actual"
		echo " "
	fi
done

if [ $correct == $num_probs ]; then
	echo "No problems missed!!"
	echo " "
fi


# Print results
echo "--------------------Results----------------------"
echo " "

percentage_dec=$(echo "scale=3; $correct/$num_probs" | bc)
percentage=$(echo "$percentage_dec*100" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//')


echo "You got $correct/$num_probs problems correct ($percentage%)"

echo " "

echo "Do you want another quiz [y/n] ?"
read play_again
done
