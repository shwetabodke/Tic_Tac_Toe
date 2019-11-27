#!/bin/bash -x

# CONSTANTS
declare BOARD_SIZE=9;
declare MATRIX_SIZE=3;
declare TRUE=1
declare FALSE=0

# VARIABLES
declare playerSymbol;
declare computerSymbol;
declare winningFlag=0;

# DICTIONARY
declare -A board;

# INITIALIZING OR RESETTING BOARD
function resettingBoard() {
	for (( cell=1; $cell <= $BOARD_SIZE; cell++ ));
		do
			board[$cell]="_";
		done
}

# PRINTING BOARD
function printBoard() {
	echo -e "                   	 ************************************************************************"
	echo -e "                    	 ******************************  TIC TAC TOE  ***************************"
	echo -e "                    	 ************************************************************************"
	cell=1;
	for (( i=1; i <= $MATRIX_SIZE; i++ ));
		do
			echo "   							+---+---+---+";
			echo "	   						| ${board[$cell]} | ${board[$(($cell+1))]} | ${board[$(($cell+2))]} |"
			cell=$(($cell+3))
		done
			echo "		   					+---+---+---+";
}

# INITIALIZING SYMBOL TO PLAYERS
function assignSymbol() {
	randomCheck=$((RANDOM%2))
   if [ $randomCheck -eq 0 ];
	then
		playerSymbol=X
      computerSymbol=0
	else
		computerSymbol=0
		playerSymbol=X
	fi
}

# TOSSING TO CHOOSE WHO WILL PLAY FIRST
function toss() {
	declare tossWinningPlayer=0
	randomCheck=$((RANDOM%2))
	if [ $randomCheck -eq 0 ];
	then
		echo $(( $tossWinningPlayer + 1 ));
	else
		echo $tossWinningPlayer;
	fi
}


# CHECKING IF BOARD IS FULL OR NOT
function isBoardFull() {
	if [[ $winningFlag -eq $TRUE ]];
	then
		flag=$TRUE;
		for (( cell=1; $cell <= $BOARD_SIZE; cell++ ));
		do
			if [[ ${board[$cell]} == "_" ]];
			then
				flag=$(( $flag - 1 ));
				break;
			fi
		done

		if [[ $flag -eq $TRUE ]];
		then
			winningFlag=$TRUE;
      			echo "*************** Game is tied as board is full  ****************";
		fi
	fi
}

# PLAYER IS PLAYING 
function playerTurn() {
	echo "Player's turn"
	echo "Enter the cell no from 1 to 9 to mark $playerSymbol"
	read cellNumber;
	if [ ${board[$cellNumber]} == '_' ];
	then
		board[$cellNumber]=$playerSymbol
	else
		echo "As it has already being marked. Please select some other cell between 0 to 9"
     	playerTurn
	fi
}

# CHECKING WINNING CONDITION FOR COMPUTER IN ROW
function checkRowWinningCondition() {
	cell=1;
	cellNumber=0;
	for (( i=0; i < $MATRIX_SIZE; i++ ));
		do
			cellNumber=$(getCellNumber $cell $(($cell+1)) $(($cell+2)) $1)
			if [[ $cellNumber != 0 ]];
			then
				break;
			else
				cell=$(($cell+3))
			fi
		done
	echo $cellNumber;
}

# CHECKING WINNING CONDITION FOR COMPUTER IN COLUMN
function checkColumnWinningCondition() {
   cellNumber=0;
   for (( i=1; i <= $MATRIX_SIZE; i++ ));
      do
         cellNumber=$(getCellNumber $i $(($i+3)) $(($i+6)) $1)
         if [[ $cellNumber != 0 ]];
         then
            break;
         else
            cell=$(($i+3))
         fi
      done
   echo $cellNumber;
}

#CHECK WINNING CONDITION FOR COMPUTER IN DIAGONALS
function checkDiagonalWinningCondition() {
	i=1;
	j=3;
	cellNumber=0;
	cellNumber=$(getCellNumber $i $(($i+4)) $(($i+8)) $1)
	if [[ $cellNumber != 0 ]];
	then
		echo $cellNumber;
	else
		cellNumber=$(getCellNumber $j $(($j+2)) $(($j+4)) $1)
		if [[ $cellNumber != 0 ]];
		then
			echo $cellNumber;
		else
			echo $cellNumber;
		fi
	fi
}

# CHECK WINNING CONDITIONS
function checkWinningConditions() {
	cellNumber=0;
	cellNumber=$(checkRowWinningCondition $1);
	if [[ $cellNumber == 0 ]];
	then
		cellNumber=$(checkColumnWinningCondition $1);
		if [[ $cellNumber == 0 ]];
		then
			cellNumber=$(checkDiagonalWinningCondition $1);
		fi
	fi
	echo $cellNumber;
}

# GENERATING CELL NUMBER
function getCellNumber() {
		if [[ ${board[$1]} == $4 && ${board[$2]} == $4 || 
				${board[$2]} == $4 && ${board[$3]} == $4 || 
				${board[$3]} == $4 && ${board[$1]} == $4 ]];
		then
			if [[ ${board[$1]} == '_' ]];
			then
				echo $1;
			elif [[ ${board[$2]} == '_' ]];
			then
				echo $2;
			elif [[ ${board[$3]} == '_' ]];
			then
				echo $3;
			else
				echo 0;
			fi
	   else
			echo 0;
		fi
}

# CHECKING FOR CORNERS
function checkCorners() {
	cellNumber=0;
	for (( i=1; i<=$BOARD_SIZE; i=$(($i+2)) ));
	do
		if [[ ${board[$i]} == '_' ]];
		then
			cellNumber=$i;
			break;
		else
			if [[ $i == 3 ]];
			then
				i=$(($i+2));
			fi
		fi
	done
	echo $cellNumber;
}

# CHECK FOR CENTRE
function checkCentre() {
	cell=0;
   if [[ ${board[5]} == '_' ]];
	then
		 echo $(($cell+5));
	else
		for ((i=2; i<$BOARD_SIZE; i=$((i+2)) ));
		do
			if [[ ${board[$i]} == '_' ]];
			then
				cell=$i;
				break;
			fi
		done
	echo $cell;
	fi
}

# CHECK FOR COMPUTER WINNING OR BLOCKING OPPONENT CONDITIONS
function winningOrBlockingConditions() {
	randomCellNumber=$(checkWinningConditions $computerSymbol)
   if [[ $randomCellNumber == 0 ]];
   then
      randomCellNumber=$(checkWinningConditions $playerSymbol)
      if [[ $randomCellNumber == 0 ]];
      then
         randomCellNumber=$(checkCorners);
         if [[ $randomCellNumber == 0 ]];
         then
            randomCellNumber=$(checkCentre);
         fi
      fi
   fi
	echo $randomCellNumber;
}

# COMPUTER IS PLAYING
function computerTurn() {
	echo "Computer's Turn"
	randomCellNumber=$(winningOrBlockingConditions)
   if [[ ${board[$randomCellNumber]} == '_' ]];
   then
      board[$randomCellNumber]=$computerSymbol
   else
      computerTurn
	fi
}

#CHECKING FOR ROW CHARACTER
function checkRow() {
	cell=1;
	for(( i=1; i<=$MATRIX_SIZE; i++ ));
		do
			if [[ $(checkRowColumn $cell $(( $cell + 1 )) $(( $cell + 2 )) ) -eq $TRUE ]];
			then
				echo $TRUE;
				break;
			else
				cell=$(( $cell + 3));
			fi
		done
}

#CHECKING FOR COLUMN CHARACTER
function checkColumn() {
	for(( i=1; i<=$MATRIX_SIZE; i++ ));
      do
			if [ $(checkRowColumn $i $(( $i + 3 )) $(( $i + 6 )) ) -eq $TRUE ];
         then
            echo $TRUE;
				break;
			fi
      done
}

# CHECKING FOR DIAGONAL CHARACTERS
function checkDiagonals() {
	i=1;
	j=3;
	if [[ $(checkRowColumn $i $(( $i + 4 )) $(( $i + 8 )) ) -eq $TRUE || 
			$(checkRowColumn $j $(( $j + 2 )) $(( $j + 4 )) ) -eq $TRUE ]];
	then
		echo $TRUE
	fi
}

# CHECKING FOR CHARACTERS ARE EQUAL OR NOT
function checkRowColumn() {
	if [[ ${board[$1]} != '_' && ${board[$1]} == ${board[$2]} && ${board[$2]} == ${board[$3]} ]];
	then
		echo $TRUE
	else
		echo $FALSE
	fi
}

# CHECKING FOR WINNING CONDITIONS
function checkWinner() {
	if [[ $(checkRow) == $TRUE || $(checkColumn) == $TRUE || $(checkDiagonals) == $TRUE ]];
	then
		winningFlag=$TRUE;
		printWinningMessage $1
	fi
}


# STARTED PLAYING GAME
function play() {
		currentPlayer=$1;
		while [[ $winningFlag -eq $FALSE ]];
		do
			#isBoardFull
			if [[ $currentPlayer -eq 1 ]];
			then
				playerTurn
				clear
				printBoard
				currentPlayer=0;
			else
				computerTurn
				clear
				printBoard
				currentPlayer=1;
			fi
      	                checkWinner $currentPlayer
			isBoardFull 
      done
}

function printWinningMessage() {
	if [[ $1 == 1 ]];
	then
      echo -e "\n\n *****************  \U1F603  Computer won the game  \U1F603  *****************\n\n"
	else
      echo -e "\n\n *****************  \U1F603  Player won the game  \U1F603  *****************\n\n"
	fi
}


resettingBoard
printBoard
assignSymbol
tossWinningPlayer=$(toss)
play $tossWinningPlayer
