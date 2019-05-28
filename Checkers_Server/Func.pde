void initBoard() {
  for (int y = 0; y < 8; y++)
    for (int x = 0; x < 8; x++) {
      if (y == 3)
        y = 5;
      if ((y%2==0 && x%2!=0) || (y%2!=0 && x%2==0)) {
        if (y < 3)
          board[x][y] = WHITE;
        else board[x][y] = BLACK;
      }
    }
}

void drawBoard() {
  for (int x = 0; x < board.length; x++)
    for (int y = 0; y < board[0].length; y++) {
      // Draw Board
      if (selected && x==sx && y==sy) 
        // if a piece is selected and its coords equal the current coords
        // in the loop, make the tile blue
        fill(0, 0, 255);
      else if (board[x][y] == VALID)
        fill(255, 0, 0);
      else if ((y%2==0 && x%2!=0) || y%2!=0 && x%2==0) 
        fill(185, 95, 34);
      else fill(230, 180, 140);
      rect(x * gridScl, y * gridScl, gridScl, gridScl);

      // Draw pieces
      if (board[x][y] == BLACK)
        fill(0);
      else if (board[x][y] == WHITE)
        fill(255);
      if (board[x][y] == BLACK || board[x][y] == WHITE)
        ellipse(x * gridScl + gridScl/2, y * gridScl + gridScl/2, gridScl * 0.8, gridScl * 0.8);
    }


  // Unrelated to draw board
  // Find if any jump moves are valid and mark them -> if a jump move is available then player must jump
  mustJump = false;
  for (int x = 0; x < board.length; x++)
    for (int y = 0; y < board[0].length; y++)
      if (board[x][y] == BLACK && findValidJump(x, y)) {
        mustJump = true;
        break;
      }
}

void clicked(int x, int y) {
  //attempt to select a piece
  if (board[x][y] == BLACK) { // since server is black, only black piece may be selected
    clearValid(); // clear any remaining valid moves
    selected = true; // set selected to true since a piece is now 'selected'
    // set the selected (x, y) to the current (x, y)
    sx = x;
    sy = y;
    findValid(sx, sy); // find valid moves for position (sx, sy)
  }
  // a piece is already selected, attempt to move, deselect, or select another piece
  if (isValid(x, y)) { // if (x, y) is a valid move, then move
    if (mustJump) { // if mustJump is true, then that means the valid move is a jump and the captured piece must be removed
      if (x > sx) { //test if jumping to the right
        board[sx+1][sy-1] = EMPTY;
      } else { // otherwise must be jumping to the left 
        board[sx-1][sy-1] = EMPTY;
      }
    }
    clearValid(); // clear all valid moves
    board[sx][sy] = EMPTY; // set the selected piece to empty
    board[x][y] = BLACK; // 'move' to piece to (x, y) and set it to black -> server is black
    selected = false; // set 'selected' back to false since there is no longer a piece that is selected
    //myTurn = false;
  }
}

void findValid(int x, int y) {
  boolean jump = false;
  if (board[x][y] == BLACK && y > 0) {
    // jump over a piece
    if (x < 6 && board[x+1][y-1] == WHITE && board[x+2][y-2] == EMPTY) {
      board[x+2][y-2] = VALID;
      jump = true;
    }
    if (x > 1 && board[x-1][y-1] == WHITE && board[x-2][y-2] == EMPTY) {
      board[x-2][y-2] = VALID;
      jump = true;
    }

    // standard diagnol move -> only if jump move is not available
    if (!mustJump && !jump) {
      if (board[x+1][y-1] == EMPTY)
        board[x+1][y-1] = VALID;
      if (board[x-1][y-1] == EMPTY)
        board[x-1][y-1] = VALID;
    }
  } else if (board[x][y] == WHITE) {
  }
}

boolean findValidJump(int x, int y) {
  boolean jump = false;
  if (board[x][y] == BLACK && y > 0) {
    // jump over a piece
    if (x < 7 && board[x+1][y-1] == WHITE)
      if (x < 6 && board[x+2][y-2] == EMPTY)
        jump = true;

    if (x > 0 && board[x-1][y-1] == WHITE)
      if (x > 1 && board[x-2][y-2] == EMPTY) 
        jump = true;
  }
  return jump;
}

void clearValid() {
  for (int x = 0; x < 8; x++)
    for (int y = 0; y < 8; y++)
      if (board[x][y] == VALID)
        board[x][y] = EMPTY;
}

void movePiece(int x1, int y1, int x2, int y2) { // used for client-side moves -> server-side is baked directly into clicked()
}

boolean isValid(int x, int y) {
  return board[x][y] == VALID;
}
