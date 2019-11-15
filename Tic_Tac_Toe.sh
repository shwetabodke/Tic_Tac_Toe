#!/bin/bash -x
echo "##############################  WELCOME TO TIC TAC TOE  ########################"

# CONSTANTS
declare BOARD_SIZE=9;

# VARIABLES
declare -A board;

# INITIALIZING OR RESETTING BOARD
function initializingBoard() {
	for (( cell=1; $cell <= $BOARD_SIZE; cell++ ));
		do
			board[$cell]="_";
		done

	echo "All Keys" ${!board[@]}
	echo "All Values" ${board[@]}
}

initializingBoard
