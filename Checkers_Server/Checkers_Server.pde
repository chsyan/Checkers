// server (black) moves first

import processing.net.*;

Server server;

String msgIn, msgOut;

// 2d array for board
int[][] board = new int[8][8];

// variables representing board state
final int EMPTY = 0;
final int WHITE = 1;
final int WHITE_KING = 4;
final int BLACK = 2;
final int BLACK_KING = 5;
final int VALID = 3; // represents a valid move

// to hold currently selected piece
int sx, sy; // coords
boolean selected; // whether a piece is currently selected or not

boolean myTurn; // whether it is 'my turn' or not :D
boolean mustJump;

int gridScl;

void setup() {
  size(300, 300);

  server = new Server(this, 1234);

  gridScl = width/8;

  myTurn = true; // darker side goes first i.e. black

  initBoard(); // setup initial piece positions

  receiveMsg();

  // Temp pieces to test jumping
  board[1][4] = WHITE;
  board[3][4] = WHITE;
  //board[5][4] = WHITE;
}


void draw() {
  drawBoard(); // draw board and pieces
}

void mouseReleased() {
  if (myTurn)
    clicked(int(mouseX/gridScl), int(mouseY/gridScl));
}
