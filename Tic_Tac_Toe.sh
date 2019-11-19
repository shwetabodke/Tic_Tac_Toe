#!/bin/bash -x
echo "##############################  WELCOME TO TIC TAC TOE  ########################"

# CONSTANTS
declare BOARD_SIZE=9;
declare MATRIX_SIZE=3;
declare CROSS_SYMBOL=X;
declare ZERO_SYMBOL=0;
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
	cell=1;
	for (( i=1; i <= $MATRIX_SIZE; i++ ));
		do
			echo "							+---+---+---+";
			echo "							| ${board[$cell]} | ${board[$(($cell+1))]} | ${board[$(($cell+2))]} |"
			cell=$(($cell+3))
		done
			echo "							+---+---+---+";
}

# INITIALIZING SYMBOL TO PLAYERS
function assignSymbol() {
	randomCheck=$((RANDOM%2))
   if [ $randomCheck -eq 0 ];
	then
		playerSymbol=$CROSS_SYMBOL
      computerSymbol=$ZERO_SYMBOL
	else
		computerSymbol=$ZERO_SYMBOL
		playerSymbol=$CROSS_SYMBOL
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
	flag=1;
	for (( cell=1; $cell <= $BOARD_SIZE; cell++ ));
	do
		if [[ ${board[$cell]} == '_' ]];
		then
			flag=$(( $flag - 1 ));
			break;
		fi
	done
	echo $flag;
}

# CHECKING IF CELL IS EMPTY OR NOT
function checkCell() {
	if [[ ${board[$1]} == $playerSymbol || ${board[$1]} == $computerSymbol ]];
	then
		echo $TRUE;
	else
		echo $FALSE;
	fi
}

# PLAYER IS PLAYING 
function playerTurn() {
	echo "Player's turn"
	printBoard;
	echo "Enter the cell no from 1 to 9 to mark $playerSymbol"
	read cellNumber;
	cellCheck=$(checkCell $cellNumber)
	if [ $cellCheck -eq $FALSE ];
	then
		board[$cellNumber]=$playerSymbol
		printBoard
	else
		verifiedBoard=$(isBoardFull)
      if [[ $verifiedBoard -eq $TRUE ]];
      then
         winningFlag=$(( $winningFlag + 1)) 
         echo "*************** Game is Drawed as no space is left ****************"
      else
			echo "As it has already being marked. Please select some other cell between 0 to 9"
      	playerTurn
      fi
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
	if [[ $cellnumber != 0 ]];
	then
		echo $cellNumber;
	else
		cellNumber=$(getCellNumber $j $(($j+2)) $(($j+4)))
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
			if [[ $cellNumber == 0 ]];
			then
				echo 0;
			else
				echo $cellNumber;
			fi
		else
			echo $cellNumber;
		fi
	else
		echo $cellNumber;
	fi
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
	cell=1;
	cellNumber=0;
	for (( i=0; i<4; i++ ));
	do
		if [[ ${board[$cell]} == '_' ]];
		then
			cellNumber=$cell;
			break;
		else
			if [[ $cell == 3 ]];
			then
				cell=$(($cell*2+1));
			else
				cell=$(($cell+2));
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

# COMPUTER IS PLAYING
function computerTurn() {
	echo "Computer's Turn marking $computerSymbol"
	#randomCellNumber=$((RANDOM % 9 + 1))

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

	cellCheck=$(checkCell $randomCellNumber)
   if [[ $cellCheck -eq $FALSE ]];
   then
      board[$randomCellNumber]=$computerSymbol
   	printBoard
   else
		verifiedBoard=$(isBoardFull)
      if [[ $verifiedBoard -eq $TRUE ]];
      then
			winningFlag=$(( $winningFlag + 1)) 
         echo "*************** Game is Drawed as no space is left ****************"
     	else
         computerTurn
		fi
	fi
}

function checkRow() {
	cell=1;
	for(( i=1; i<=$MATRIX_SIZE; i++ ));
		do
			verifiedRowColumn=$(checkRowColumn ${board[$cell]} ${board[$(( $cell + 1 ))]} ${board[$(( $cell + 2 ))]})
			if [[ $verifiedRowColumn -eq $TRUE ]];
			then
				echo $TRUE;
				break;
			else
				cell=$(( $cell + 3));
			fi
		done
}

function checkColumn() {
	for(( i=1; i<=$MATRIX_SIZE; i++ ));
      do
         verifiedRowColumn=$(checkRowColumn ${board[$i]} ${board[$(( $i + 3 ))]} ${board[$(( $i + 6 ))]})
         if [ $verifiedRowColumn -eq $TRUE ];
         then
            echo $TRUE;
				break;
			fi
      done
}

function checkDiagonals() {
	i=1;
	j=3;
	verifiedDiagonal1=$(checkRowColumn ${board[$i]} ${board[$(( $i + 4 ))]} ${board[$(( $i + 8 ))]})
	verifiedDiagonal2=$(checkRowColumn ${board[$j]} ${board[$(( $j + 2 ))]} ${board[$(( $j + 4 ))]})

	if [[ $verifiedDiagonal1 -eq $TRUE || $verifiedDiagonal2 -eq $TRUE ]];
	then
		echo $TRUE
	else
		echo $FALSE
	fi
}

function checkRowColumn() {
	if [[ $1 != '_' && $1 == $2 && $2 == $3 ]];
	then
		echo $TRUE
	else
		echo $FALSE
	fi
}

# CHECKING FOR WINNING CONDITIONS
function checkWinner() {
	verifiedRow=$(checkRow)
	verifiedColumn=$(checkColumn)
  	verifiedDiagonals=$(checkDiagonals)
	if [[ $verifiedRow == $TRUE || $verifiedColumn == $TRUE || $verifiedDiagonals == $TRUE ]];
	then
		echo $TRUE;
	else
		echo $FALSE;
	fi
}


# STARTED PLAYING GAME
function play() {

		while [[ $winningFlag -eq $FALSE ]];
		do
			verifiedBoard=$(isBoardFull)
			if [[ $verifiedBoard -eq $TRUE ]];
			then
				echo "*************** Game is Drawed as no space is left ****************";
				break;
			fi

			if [[ $1 -eq 1 ]];
			then
				playerTurn
				winningFlag=$(checkWinner)
   	      if [[ $winningFlag -eq $TRUE ]];
      	   then
         	   echo -e "\n\n *****************\U1F603  Player won the game  \U1F603***************** \n\n";
            	break;
         	fi
			else
				computerTurn
				winningFlag=$(checkWinner)
	         if [[ $winningFlag -eq $TRUE ]];
   	      then
      	      echo -e "\n\n *****************\U1F603  Computer won the game  \U1F603*****************\n\n";
         	   break;
         	fi

			fi

			verifiedBoard=$(isBoardFull)
         if [[ $verifiedBoard -eq $TRUE ]];
         then
            echo "*************** Game is Drawed as no space is left ****************";
            break;
         fi

			if [[ $1 -eq 1 ]];
			then
				computerTurn
				winningFlag=$(checkWinner)
         	if [[ $winningFlag -eq $TRUE ]];
         	then
            	echo -e "\n\n*****************\U1F603  Computer won the game  \U1F603***************** \n\n";
            	break;
         	fi
			else
				playerTurn
				winningFlag=$(checkWinner)
         	if [[ $winningFlag -eq $TRUE ]];
         	then
            	echo -e "\n\n *****************\U1F603  Player won the game  \U1F603*****************\n\n";
            	break;
         	fi
			fi
		done
}

resettingBoard
printBoard
assignSymbol
echo "PLayer : $playerSymbol | COMPUTER : $computerSymbol "
tossWinningPlayer=$(toss)
echo "PLayer : $playerSymbol | COMPUTER : $computerSymbol "
play $tossWinningPlayer
