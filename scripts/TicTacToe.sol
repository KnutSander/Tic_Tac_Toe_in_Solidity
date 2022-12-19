//SPDX-License-Identifier: Unlicense
pragma solidity ^0.4.24;

/**
 * @title TicTacToe contract
 **/
contract TicTacToe {
    address[2] public players;

    /**
     turn
     1 - players[0]'s turn
     2 - players[1]'s turn
     */
    uint public turn = 1;

    /**
     status
     0 - ongoing
     1 - players[0] won
     2 - players[1] won
     3 - draw
     */
    uint public status;

    /**
    board status
     0    1    2
     3    4    5
     6    7    8
     */
    uint[9] private board;

    /**
      * @dev Deploy the contract to create a new game
      * @param opponent The address of player2
      **/
    constructor(address opponent) public {
        require(msg.sender != opponent, "No self play");
        players = [msg.sender, opponent];
    }

    /**
      * @dev Check a, b, c in a line are the same
      * _threeInALine doesn't check if a, b, c are in a line
      * @param a position a
      * @param b position b
      * @param c position c
      * DONE
      **/    
    function _threeInALine(uint a, uint b, uint c) private view returns (bool){
        return a == b && b == c;
    }

    /**
     * @dev get the status of the game
     * @param pos the position the player places at
     * @return the status of the game
     * DONE
     */
    function _getStatus(uint pos) private view returns (uint) {
      return status;
    }

    /**
     * @dev ensure the game is still ongoing before a player moving
     * update the status of the game after a player moving
     * @param pos the position the player places at
     * DONE?
     */
    modifier _checkStatus(uint pos) {
      // Game must be ongoing 
      require(status == 0, "GAME OVER: The game is over");
        
      _;
      
      // Check rows
      for(uint i = 0; i < 9; i += 3){
        if(_threeInALine(board[i], board[i+1], board[i+2]) && board[i] != 0){
          status = board[i];
        }
      }
          
      // Check columns
      for(uint j = 0; j < 3; j++){
        if(_threeInALine(board[j], board[j+3], board[j+6]) && board[i] != 0){
          status = board[j];
        }
      }

      // Check diagonals
      if((_threeInALine(board[0], board[4], board[8]) || 
         _threeInALine(board[2], board[4], board[6])) && board[4] != 0){
          status = board[4];
      }
      
      // Check for draw
      for(uint k = 0; k < 9; k++){
        if(board[k] == 0){
          break;
        } else if (k == 8){
          status = 3;
        }
      }
    }

    /**
     * @dev check if it's msg.sender's turn
     * @return true if it's msg.sender's turn otherwise false
     * DONE
     */
    function myTurn() public view returns (bool) {
      return players[turn-1] == msg.sender;
    }

    /**
     * @dev ensure it's a msg.sender's turn
     * update the turn after a move
     * DONE
     */
    modifier _myTurn() {
      require(players[turn-1] == msg.sender);
      _;
      turn = turn == 1 ? 2 : 1;
    }

    /**
     * @dev check a move is valid
     * @param pos the position the player places at
     * @return true if valid otherwise false
     * DONE
     */
    function validMove(uint pos) public view returns (bool) {
      return board[pos] == 0 && (pos >= 0 && pos < 9);
    }

    /**
     * @dev ensure a move is valid
     * @param pos the position the player places at
     * DONE
     */
    modifier _validMove(uint pos) {
      require(pos >= 0 && pos < 9,
        "INVALID MOVE: Moves must be between board positions 0 and 8");

      require(board[pos] == 0,
        "INVALID MOVE: Board position already occupied");
      
      _;
    }

    /**
     * @dev a player makes a move
     * @param pos the position the player places at
     * DONE
     */
    function move(uint pos) public _validMove(pos) _checkStatus(pos) _myTurn {
      board[pos] = turn;
    }

    /**
     * @dev show the current board
     * @return board
     * DONE
     */
    function showBoard() public view returns (uint[9]) {
      return board;
    }
}
