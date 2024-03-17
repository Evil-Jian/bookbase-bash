#! /usr/bin/bash
displaySeparator(){
	echo "########################################"
}

generateID(){
	line=$( tail -n 1 data.txt )
	ID=${line%% |*}
	finalID=$(echo "$ID" | tr -d '()')
	echo "$(( $finalID + 1 ))"
}

create(){
	displaySeparator
	echo "Needed information: Full Title, Author, Volume, Publisher, Year, Language, Genre, ISBN, Pages"
	echo "Kindly input the information independently in sequence separated by |"
	echo "Example: master of the game|sidney sheldon|2|IBM|1982|english|fiction|0-688-01365-1|495"
	IFS="|"
	local ID=$(generateID)
	read -p "Enter: " title author volume pub year lang genre isbn pages; 
	echo "($ID) | $title | $author | $volume | $pub | $year | $lang | $genre | $isbn | $pages" >> data.txt
	echo "Successfully added!"
}

display(){
	displaySeparator
	read -p "Search: " title
	while read -r CURRENT_LINE; do
		if [[ "$CURRENT_LINE" =~ "$title" ]]; then
			echo "$CURRENT_LINE"
		fi
	done < data.txt
}

update(){
	displaySeparator
	read -p "Input ID: " ID
	while read -r CURRENT_LINE; do			#finds line that has ID number
		if [[ "$CURRENT_LINE" =~ "($ID)" ]]; then	
		echo "$CURRENT_LINE"
		break
		fi
	done < data.txt

	displaySeparator
	echo "Needed information: Full Title, Author, Volume, Publisher, Year, Language, Genre, ISBN, Pages"
	echo "Kindly input the information independently in sequence separated by |"
	echo "Example: master of the game|sidney sheldon|2|IBM|1982|english|fiction|0-688-01365-1|495"
	displaySeparator
	IFS="|"
	read -p "Enter: " title author volume pub year lang genre isbn pages; 
	sed -i "${ID}s/.*/(${ID}) | $title | $author | $volume | $pub | $year | $lang | $genre | $isbn | $pages/" data.txt
	echo "Successfully updated!"
}

delete(){
	displaySeparator
	read -p "Input ID: " ID
	read -p "Are you sure you want to delete? Y/N: " choice
	if [ "$choice" = "Y" ]; then
		sed "/^(${ID})/d" -i data.txt	#delete line that starts with ID
		echo "Successfully Deleted"
	else 
		echo "Cancelled"
	fi;
}

displaySeparator
echo "Welcome to Jian's Book Management System"
displaySeparator
echo "1 - Add a new entry
2 - Browse books based on keywords
3 - Update an existing entry
4 - Delete an existing entry"
echo "What would you like to do?"
read a

if [ "$a" = "1" ]; then
	create
elif [ "$a" = "2" ]; then
	display
elif [ "$a" = "3" ]; then
	update
elif [ "$a" = "4" ]; then
	delete
else
	echo "input a number from 1-4 please!"
fi;
