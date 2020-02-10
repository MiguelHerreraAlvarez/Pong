import processing.sound.*;

float ballX, ballY, ballWidth, ballHeight;
float ballSpeedX, ballSpeedY;

int playerWidth, playerHeight, playerSpeed;
int player1X, player1Y, player2X, player2Y;
boolean player1Up, player1Down, player2Up, player2Down;

int player1Score = 0;
int player2Score = 0;
int winScore = 10;

boolean win;

SoundFile bounce;
SoundFile goal;
SoundFile winSong;

PFont font;

void setup() {
  win = true;
  size(1152,640);
  ballX = width/2; 
  ballY = height/2;
  ballWidth = 20;
  ballHeight = 20;
  ballSpeedX = 5.0;
  ballSpeedY = 4.0;
  playerWidth = 30;
  playerHeight = 100;
  player1X = playerWidth;
  player1Y = height/2 - playerHeight/2;
  player2X = width - playerWidth*2;
  player2Y = height/2 - playerHeight/2;
  playerSpeed = 5;
  bounce = new SoundFile(this,"ping_pong_8bit_plop.wav");
  goal = new SoundFile(this,"ping_pong_8bit_beeep.wav");
  winSong = new SoundFile(this,"custers_revenge.wav");
  font = createFont("bit.ttf",32);
}

void draw() {
  drawField(255);
  drawBall();
  moveBall();
  bounceOff();
  drawPlayers();
  movePlayers();
  restrictPlayers();
  contactWithPlayer();
  scores();
  gameOver();
}

void drawField(int n){
  fill(n);
  background(0);
  stroke(1000);
  rect(20,20,width-40,20);
  rect(20,height-40,width-40,20);
  
  for(int i = 2; i <= 52; i+=2)
    rect(width/2,20*i,20,20);
}

void drawBall() {
  rect(ballX, ballY, ballWidth, ballHeight);
}

void moveBall() {
  ballX = ballX + ballSpeedX;
  ballY = ballY + ballSpeedY;
}

void bounceOff() {
 if ( ballX > width - ballWidth) {
    goal.play();
    setup();
    ballSpeedX = -ballSpeedX;
    player1Score = player1Score + 1;
  } else if (ballX < ballWidth/2) {
    goal.play();
    setup();
    player2Score = player2Score + 1;
  }
  
  if ( ballY > height-40 - ballHeight) {
    bounce.play();
    ballSpeedY = -ballSpeedY;
  } else if ( ballY < 40) {
    bounce.play();
    ballSpeedY = -ballSpeedY;
  }
}

void drawPlayers() {
  rect(player1X, player1Y, playerWidth, playerHeight);
  rect(player2X, player2Y, playerWidth, playerHeight);
}

void movePlayers() {
  if (player1Up) {
    player1Y = player1Y - playerSpeed;
  } else if (player1Down) {
    player1Y = player1Y + playerSpeed;
  }
  
  if (player2Up) {
    player2Y = player2Y - playerSpeed;
  } else if (player2Down) {
    player2Y = player2Y + playerSpeed;
  }
}

void restrictPlayers() {
  if (player1Y < 45) {
    player1Y = 45;
  } else if (player1Y + playerHeight > height-45) {
    player1Y = height - (playerHeight + 45);
  }
  
  if (player2Y < 45) {
    player2Y = 45;
  } else if (player2Y + playerHeight > height-45) {
    player2Y = height - (playerHeight + 45);
  }
}

void contactWithPlayer() {
  if (ballX  < player1X + playerWidth && ballY < player1Y + playerHeight && ballY + ballHeight > player1Y ) {
    if (ballSpeedX < 0) {
      bounce.play();
      ballSpeedX = -ballSpeedX*1.05;
    }
  }
  else if (ballX + ballWidth > player2X  && ballY < player2Y + playerHeight && ballY + ballHeight  > player2Y) {
    if (ballSpeedX > 0) {
      bounce.play();
      ballSpeedX = -ballSpeedX*1.05;
    }
  }
}

void scores() {
  textFont(font);
  textSize(100);
  textAlign(CENTER, CENTER);
  text(player1Score, 100, 90);
  text(player2Score, width-100, 90);
}

void gameOver() {
  if(player1Score == winScore) {
    gameOverPage("Player 1 wins!");
  } else if(player2Score == winScore) {
    gameOverPage("Player 2 wins!");
  }
}

void gameOverPage(String text) {
  ballSpeedX = 0.0;
  ballSpeedY = 0.0;
  
  if(win) {
    winSong.play();
    win = false;
  }
  
  drawField(0);
  fill(255);
  textSize(60);
  text("Game over", width/2, height/3 - 40);
  text(text, width/2, height/3);
  text("\nClick to play again", width/2, height/3 + 40);
  
  if(mousePressed){
    player1Score = 0;
    player2Score = 0;
    ballSpeedX = 4.0;
    ballSpeedY = 3.0;
  }
}
 
void keyPressed() {
  if (key == 'w' || key == 'W') {
    player1Up = true;
  } else if (key == 's' || key == 'S') {
    player1Down = true;
  }
  
  if (keyCode == UP) {
    player2Up = true;
  } else if (keyCode == DOWN) {
    player2Down = true;
  }
}

void keyReleased() {
  if (key == 'w' || key == 'W') {
    player1Up = false;
  } else if (key == 's' || key == 'S') {
    player1Down = false;
  }
  
  if (keyCode == UP) {
    player2Up = false;
  } else if (keyCode == DOWN) {
    player2Down = false;
  }
}
