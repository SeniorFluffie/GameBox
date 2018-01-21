/* GameBox
 * Author: Michael Kazman
 * Course: ICS4U
 * Teacher: Mrs. Costin
 * Date: 20/01/2016\
 * Description: The Game Box is a selection of 3 various 
 fun mini-games combined together in one program. The program
 allows you to play KeepUps, the soccer game where you must keep the
 ball in the air, Firing Range where you must shoot the appearing targets,
 and FallDown, where you must fall between the gaps in the platforms. This program
 has both backwards and forwards navigation between menu screens.
 */

import ddf.minim.*;
Minim minim;
//Menu Variables
AudioPlayer MenuSong;
// KeepUps Variables
AudioPlayer kick1, kick2, KeepUpsGameSong, KeepUpsScoreSound;
float KeepUpsX = 310, KeepUpsY = 350, KeepUpsR = 75, velocityX, velocityY, KeepUpsSound, tint = 0;
int KeepUpsScore, KeepUpsHighScore, gameState = 0;
// Firing Range Variables
AudioPlayer shot1, shot2, metal, reload, FiringRangeGameSong;
float FiringRangeR = 50, FiringRangeX = random(FiringRangeR, 600 - 75), FiringRangeY = random(FiringRangeR, 400 - 75), timer, reloadBar;
int FiringRangeScore, FiringRangeHighScore, ammo = 6, FiringRangeSound, time = 0;
boolean check = false, reloadCheck = false;
float arcStart = 0, arcEnd = 0;
//FallDown Variables
AudioPlayer FallDownGameSong, speedUp;
float FallDownBallX, FallDownBallY, FallDownVelocity, platSpeed, gapSize, bottomPlat, rotation =0;
float [] platform = new float[15];
float [] gap = new float [15];
int lineCounter=0, FallDownScore=0, FallDownHighScore = 0;

void setup() { // setup the program
  size(600, 400); // set the canvas size
  smooth(); // make the program run smoother
  minim = new Minim(this); // load in all the music
  //Menu Audio
  MenuSong = minim.loadFile("MenuSong.mp3"); 
  MenuSong.setGain(-5.0); // make the volume quieter
  // KeepUps Audio
  kick1 = minim.loadFile("kick1.mp3"); 
  kick2 = minim.loadFile("kick2.mp3");
  KeepUpsScoreSound = minim.loadFile("highscore.mp3");
  KeepUpsGameSong = minim.loadFile("KeepUpsMusic.mp3");
  KeepUpsGameSong.setGain(-10.0); // make the volume quieter
  // Firing Range Audio
  shot1 = minim.loadFile("shot1.mp3");
  shot2 = minim.loadFile("shot2.mp3");
  metal = minim.loadFile("metal.mp3");
  reload = minim.loadFile("reload.wav");
  FiringRangeGameSong = minim.loadFile("FiringRangeMusic.mp3");
  FiringRangeGameSong.setGain(-5.0);
  //FallDown Audio
  FallDownGameSong = minim.loadFile("FallDownMusic.mp3");
  FallDownGameSong.setGain(-15.0);
  speedUp = minim.loadFile("hurryup.mp3");
}
// Menu Screen
void Screen0() {
  tint(255, tint+=3); // make the program fade in
  background(0); // draw the background
  fill(255, 255, 255);
  textSize(50);
  textAlign(CENTER); // align the text in the center
  PFont Menufont; // load in the font 
  Menufont = loadFont("UniSans-48.vlw");
  textFont(Menufont, 80); // implement the font
  text("GAME BOX!", width / 2, 150); // write the title
  rectMode(CENTER); // center the rectangles
  stroke(255, 255, 255); // make the games outlined white
  // DRAW THE FIRST GAME RECTANGLE WITH THE FONT AND ICON
  fill(0, 255, 0);
  rect(100, 300, 150, 150, 10);
  KeepUpsBall(100, 280, 85);
  PFont KeepUpsfont; // load in the font 
  KeepUpsfont = loadFont("MarkerFelt-Wide-48.vlw");
  textFont(KeepUpsfont, 32);
  fill(0);
  text("KeepUps!", 100, 360);
  // DRAW THE SECOND GAME RECTANGLE WITH THE FONT AND ICON
  fill(243, 247, 129);
  rect(300, 300, 150, 150, 10);
  PImage FiringRangeTarget;
  FiringRangeTarget = loadImage("FiringRangeTarget.png");
  imageMode(CENTER);
  image(FiringRangeTarget, 300, 280, 100, 85);
  PFont FiringRangeFont;
  FiringRangeFont = loadFont("Rustler-48.vlw"); // create new western font
  textFont(FiringRangeFont, 24);
  fill(0);
  text("Firing Range!", 300, 360);
  // DRAW THE THIRD GAME RECTANGLE WITH THE FONT AND ICON
  fill(220, 20, 60);
  rect(500, 300, 150, 150, 10);
  PImage FallDownBall2;
  FallDownBall2 = loadImage("FallDownBall.png");
  imageMode(CENTER);
  image(FallDownBall2, 500, 280, 100, 100);
  PFont FallDownFont;
  FallDownFont = loadFont("PressStart-48.vlw"); // create new western font
  textFont(FallDownFont, 20);
  fill(0);
  text("FALL", 502, 345);
  text("DOWN!", 503, 370);
  // If the mouse is pressed on the game icons then open them
  if (mouseX >= 25 && mouseX <= 175 && mouseY >= 225 && mouseY <= 375 && mousePressed) 
    gameState = 1;
  else if (mouseX >= 225 && mouseX <= 375 && mouseY >= 225 && mouseY <= 375 && mousePressed) 
    gameState = 3;
  else if (mouseX >= 425 && mouseX <= 575 && mouseY >= 225 && mouseY <= 375 && mousePressed)
    gameState = 5;
  // the audio previews when you hover over the games
  MenuSong.play();
  if (mouseX >= 25 && mouseX <= 175 && mouseY >= 225 && mouseY <= 375) {
    KeepUpsGameSong.play();
    MenuSong.pause();
  } else
    KeepUpsGameSong.pause();

  if (mouseX >= 225 && mouseX <= 375 && mouseY >= 225 && mouseY <= 375) {
    FiringRangeGameSong.play();
    MenuSong.pause();
  } else
    FiringRangeGameSong.pause();

  if (mouseX >= 425 && mouseX <= 575 && mouseY >= 225 && mouseY <= 375) {
    FallDownGameSong.play();
    MenuSong.pause();
  } else
    FallDownGameSong.pause();
}

// Keep Ups Methods
void KeepUpsBackground () { // function to load the image of the background
  PImage background;
  background = loadImage("KeepUpsBackground.png");
  imageMode(CORNER);
  image(background, 0, 0);
}

void KeepUpsBall(float x, float y, float r) { // function to load the image of the ball
  PImage Soccerball;
  Soccerball = loadImage("KeepUpsBall.png");
  imageMode(CENTER);
  image(Soccerball, x, y, r, r);
}

void KeepUpsPhysics() {
  KeepUpsX+=velocityX; // add the velocity to the x
  KeepUpsY+=velocityY; // add the velocity to the y
  velocityY+=.3; // make the y velocity constantly increase like gravity
  if (KeepUpsX<35) { // if the ball hits the left side
    velocityX *= -.8; // switch directions and lose velocity
    KeepUpsX = 35; // set the ball to the left side so it doesnt go through the canvas
  } else if (KeepUpsX>width-35) { // if the ball hits the right side
    velocityX *= -.8; // switch directions and lose velocity
    KeepUpsX = width - 35; // set the ball to the right side so it doesnt go through the canvas
  }
  if (KeepUpsY<35) { // if the ball hits the top
    KeepUpsY = 35; // set the ball at the top so it doesnt go through the canvas
    velocityY *= -.8; // switch directions and lose velocity
  } else if (KeepUpsY>height-35) { // if the ball hits the bottom
    KeepUpsY = height - 35; // set the ball at the bottom so it doesnt go through the canvas
    velocityY *= -.8; // switch directions and lose velocity
    KeepUpsScore=0; // set the KeepUpsScore back to 0
  }
  if (KeepUpsScore == 0 && gameState == 2) // once the score hits 0
    KeepUpsScoreSound.rewind(); // the highscore sound will play if you get a highscore
}  

void Screen1() { // draw the menu for keepups
  tint(255, tint+=1); // make it fade in
  KeepUpsBackground(); // draw the background  
  fill(30, 144, 255);
  strokeWeight(1);
  rect(300, 100, 250, 40); // draw button
  rect(300, 175, 250, 40); // draw button
  rect(300, 250, 250, 40); // draw button
  fill(0);
  textSize(20);
  PFont KeepUpsfont; // load in the font 
  KeepUpsfont = loadFont("MarkerFelt-Wide-48.vlw");
  textFont(KeepUpsfont, 32); // implement the font
  stroke(0);
  text("Play!", 300, 113);
  text("Menu!", 300, 188);
  text("Instructions!", 304, 262);
  if (KeepUpsHighScore > 0) { //after you quit, display the highscore
    text("Your highest score was "+ KeepUpsHighScore + "!", width/2, 350); // when the game ends, display the score
  }
  if (mouseX >= 175 && mouseX <= 425 && mouseY >= 80 && mouseY <= 120 && mousePressed) {// when you press the button
    KeepUpsScore = 0;
    gameState = 2; // make the game start
  } else if (mouseX >= 175 && mouseX <= 425 && mouseY >= 155 && mouseY <= 195 && mousePressed)
    gameState = 0; // make the instruction menu start
  else if (mouseX >= 175 && mouseX <= 425 && mouseY >= 230 && mouseY <= 270 && mousePressed) 
    gameState = 7;
}

void Screen2 () {  // draw the keep ups game
  tint(255, 255); // make it full opacity
  KeepUpsBackground(); // draw background
  fill(255, 0, 0);
  rect(20, 379, 30, 30); // draw the red x box
  line(10, 390, 30, 370);
  line(30, 390, 10, 370);
  textSize(14);
  fill(255, 255, 0);
  text("SCORE: " + KeepUpsScore, width/2, 25); // draw the score
  text("HIGH-SCORE: " + KeepUpsHighScore, width/2, 50); // draw the high score
  KeepUpsBall(KeepUpsX, KeepUpsY, KeepUpsR); // draw ball
  textAlign(CENTER); // center the text
  fill(255, 255, 0);
  KeepUpsPhysics(); // add the physics
  if (mouseX >= 5 && mouseX <= 35 && mouseY >= 365 && mouseY <= 395 && mousePressed) // if you press the red x
    gameState = 1; // go to the keepups menu
}

void Screen7() { // draw the instruction page
  tint(255, 255); // full opacity
  strokeWeight(1);
  KeepUpsBackground(); // draw background
  fill(30, 144, 255);
  rect(300, 50, 250, 40);
  rect(300, 250, 400, 275);
  fill(0);
  text("Back To Game!", 300, 59);
  textSize(23);
  text("Instructions:", 300, 136);
  strokeWeight(3);
  line(235, 140, 355, 140);
  textSize(19);
  text("Welcome to KeepUps. The objective of this game is \n to keep the ball in the air for as long as possible. \n This can be achieved by repeatedly clicking the \n soccer ball that spawns at the bottom of the screen \n with your mouse. Each time you click the ball you are \n awarded a point. Try to reach the highest score \n possible. Click the red exit button at the top to return \n to the game menu. \n \n Good Luck & Enjoy!", 300, 165);
  if (mouseX >= 175 && mouseX <= 425 && mouseY >= 30 && mouseY <= 70 && mousePressed) // if you press the back button
    gameState = 1; // go to the keep ups menu
}

//Firing Range Methods
void FiringRangeBackground () { // function to load the image of the background
  PImage background;
  background = loadImage("FiringRangeBackground.png");
  imageMode(CORNER);
  image(background, 0, 0);
}

// Firing Range Methods
class Target { // object to load the image of the target
  float a, b, c;
  Target(float FiringRangeX, float FiringRangeY, float FiringRangeR) {
    this.a = FiringRangeX;
    this.b = FiringRangeY;
    this.c = FiringRangeR;
  }
  void display() {
    ellipseMode(CENTER);    
    noStroke();
    fill(255, 0, 0);
    ellipse(a, b, c*1.85, c * 1.85);
    fill(255, 255, 255);
    ellipse(a, b, c*1.4, c * 1.42);
    fill(255, 0, 0);
    ellipse(a, b, c*1.1, c * 1.16); 
    fill(255, 255, 255);
    ellipse(a, b, c*0.89, c * 0.91);
    fill(255, 0, 0);
    ellipse(a, b, c*0.58, c* 0.61);
    fill(255, 255, 255);
    ellipse(a, b, c*0.32, c * 0.35);

    if (check == false && FiringRangeR<75) // make the target expand intitially
      FiringRangeR+=1.4;
    else if (FiringRangeR >= 75 || check == true && FiringRangeR > 0) { // make the target contract
      check = true;
      FiringRangeR-=1.6;
    }
    if (FiringRangeR <= 0) { // when the target is 0, spawn a new one
      FiringRangeX = random(FiringRangeR, 600 - 75);
      FiringRangeY = random(FiringRangeR, 400 - 75);
      FiringRangeR = 50;
      FiringRangeR+=0.5;
      check = false;
    }
  }
}

void cursor() { // create the cursor
  strokeWeight(1);
  stroke(0);
  line(mouseX - 20, mouseY, mouseX + 20, mouseY);
  line(mouseX, mouseY - 20, mouseX, mouseY + 20);
  noFill();
  ellipse(mouseX, mouseY, 20, 20);
}

void Screen3() { // draw the menu screen
  tint(255, tint+=1);
  FiringRangeBackground(); // draw the background
  timer = 100; // set the timer back to 100
  ammo = 6; // set the ammo to 8
  stroke(255, 102, 0);
  strokeWeight(1);
  fill(243, 247, 129);
  rect(300, 100, 250, 40); // draw button
  rect(300, 175, 250, 40); // draw button
  rect(300, 250, 250, 40); // draw button
  fill(0);
  textSize(20);
  PFont font;
  font = loadFont("Rustler-48.vlw"); // create new western font
  textFont(font, 32); // implement the font
  textAlign(CENTER);
  text("Play!", 300, 113);
  text("Menu!", 300, 188);
  text("Instructions!", 304, 262);
  if (FiringRangeScore > 0) // display the score after you play
    text("Your score was "+ FiringRangeScore + "!", width/2, 350); // when the game ends, display the score
  if (mouseX >= 175 && mouseX <= 425 && mouseY >= 80 && mouseY <= 120 && mousePressed) {  // if you press the play
    gameState = 4; // start the game
    FiringRangeScore=0;
  } else if (mouseX >= 175 && mouseX <= 425 && mouseY >= 155 && mouseY <= 195 && mousePressed) // if you press the menu
    gameState = 0; //go to start menu
  else if (mouseX >= 175 && mouseX <= 425 && mouseY >= 230 && mouseY <= 270 && mousePressed) // if you press instructions
    gameState = 8; // go to instructions
}

void Screen4() { // draw the firing range game
  Target d = new Target(FiringRangeX, FiringRangeY, FiringRangeR); // create a new target
  Target e = new Target(FiringRangeX, FiringRangeY, FiringRangeR); // create a new target ontop of that target
  timer -= 0.08; // make the timer go down
  tint(255, 255); // make it full opacity
  FiringRangeBackground(); // draw background
  d.display(); // display the target
  e.display(); // display the target
  fill(255, 0, 0);
  stroke(0);
  strokeWeight(1);
  rect(20, 379, 30, 30); // draw the red x box
  fill(0); 
  line(10, 390, 30, 370);
  line(30, 390, 10, 370);
  cursor(); // draw the cursor
  fill(0); 
  textSize(20);
  text("SCORE: " + FiringRangeScore, width/2, 25); // draw the score
  text("HIGH-SCORE: " + FiringRangeHighScore, width/2, 50); // draw the high score
  text("AMMO: " + ammo, 35, 20); // draw the ammo counter
  if (mouseX >= 5 && mouseX <= 35 && mouseY >= 365 && mouseY <= 395 && mousePressed) // if you press the red x
    gameState = 3; // go to the firing range menu
  if (timer <= 100 && timer > 50) // make the timer turn green 
    fill(0, 255, 0);
  else if (timer <= 50 && timer > 25) // make the timer turn yellow
    fill(255, 255, 0);
  else if (timer <= 25 && timer > 0) // make the timer turn red
    fill(255, 0, 0);
  else if (timer <= 0) // end the game
    gameState = 3; 
  rect(250, 60, timer, 10);// draw the timer bar
  textAlign(CENTER); // center the text
  fill(255, 0, 0);

  if (ammo == 0) { // if you have no ammo
    textSize(35);
    fill(0);
    text("PRESS SHIFT TO RELOAD!", width/2, 225); // give ammo warning
    if (ammo == 0 && reloadCheck == true) {
      stroke(255, 255, 255);
      fill(255, 255, 255, 100);
      arc(mouseX, mouseY, 20, 20, radians(arcStart), radians(arcEnd + 360)); // reload when the animation finishes
      arcStart += 10;
    }
    if (arcStart >= 405) { // create the reloading circle animation
      ammo = 6;
      reloadCheck = false;
      arcStart = radians(0);
      arcEnd = radians(360);
    }
  }
}

void Screen8() { // draw the instruction page
  tint(255, 255);
  strokeWeight(1);
  FiringRangeBackground(); // draw background
  fill(243, 247, 129);
  rect(300, 50, 250, 40);
  rect(300, 250, 400, 275);
  fill(0);
  text("Back To Game!", 300, 59);
  textSize(24);
  text("Instructions:", 300, 140);
  strokeWeight(3);
  line(235, 145, 355, 145);
  textSize(22);
  text("Welcome to the Firing Range. The objective \n of this game is to shoot as many targets \n before the time runs out. This can be \n achieved by shooting targets that \n randomly appear by clicking, while hovering \n over a target with your mouse cursor. \n Each time you shoot, you utilize a bullet. \n Once the ammo counter reaches 0, you must \n press shift and reload the pistol. Each \n target you shoot awards 1 point, a bullseye \n awards 2 points.  \n Good Luck and Enjoy!", 300, 166);
  if (mouseX >= 175 && mouseX <= 425 && mouseY >= 30 && mouseY <= 70 && mousePressed)
    gameState = 3;
}

// FallDown Methods
void platformSetup() // intialize the array of platforms
{
  platform[0]=600;
  for (int a=1; a<15; a++)
  {
    platform[a]=platform[a-1]+80; // make the platforms 80 size apart
    gapSize=random(60, width-60); // make the gap 120 pixels wide
    gap[a]=gapSize;
  }
}

void physics()
{
  if (FallDownBallY<=(platform[lineCounter]-20) && FallDownBallY<height) // if the ball is in 20 pixels of the gap
    gravity();// then make it fall
  else
    collision(); // otherwise let it sit on the platforms
  if (FallDownBallY>height - 13) // make the ball stay in the bottom boundary
    FallDownBallY=height - 13;
}

void collision()
{
  if (FallDownBallX>gap[lineCounter] && FallDownBallX<gap[lineCounter]+120 && FallDownBallY<height) // if the ball is on a gap (between the 120 pixels) and not the bottom of the screen
  {
    lineCounter+=1; // add one to the line count
    FallDownScore=FallDownScore+1; // add a point
    gravity(); // then add gravity 
    if (FallDownHighScore <= FallDownScore) // if the score is greater than the highscore
      FallDownHighScore = FallDownScore; // set the highscore to the score
    if (lineCounter==15) // if you pass the last line
    {
      lineCounter=0; // set the counter to 0
      speedUp.rewind(); // rewind the sound
      speedUp.play();// play the hurry up sound
      platSpeed*=1.1; // make the platforms go faster
    }
  } else {
    FallDownBallY=platform[lineCounter]-20; // make the ball stay on the platform (and due to the image dimensions the ball has to be 20 units above the platform to look like its on the platform)
    FallDownVelocity=0; // change the velocity to 0 on the platform
  }
}

void displayBall() //function to load the image of the ball
{
  PImage FallDownBall;
  FallDownBall = loadImage("FallDownBall.png");
  if (keyPressed&&keyCode==LEFT)
    rotation-=0.3;
  else if (keyPressed&&keyCode==RIGHT)
    rotation+=0.3;
  pushMatrix();
  translate(FallDownBallX, FallDownBallY);
  rotate(rotation);
  image(FallDownBall, 0, 0, 30, 30);
  popMatrix();
}

void gravity () // if the ball is in the gravity state, make it go down and increase velocity
{
  FallDownVelocity+=0.1;
  FallDownBallY+=FallDownVelocity;
}

void displayPlatforms()                    
{
  for (int a=0; a<platform.length; a++)
  {
    if (platform[a]<=0) // if a platform reaches the top
    {
      platform[a]=bottomPlat + 80;  // set it to be at the bottom of the array with 80 pixels of space between the each platform
      gapSize=random(60, width-60); // create the gap in the platforms thats 120 pixels
      gap[a]=gapSize; // add the gap to the array
    }
    strokeWeight(6);
    stroke(random(0, 255), random(0, 255), random(0, 255)); // random color for the platforms
    line (0, platform[a]-5, width, platform[a]-5); // draw the rainbow platforms
    strokeWeight(12);
    stroke(0, 0, 0);
    line (gap[a], platform[a]-5, gap[a]+120, platform[a]-5); // draw the gap
    platform[a]-=platSpeed; // make the platforms go up
    bottomPlat=platform[a]; // keeps track of the last platform that was created
  }
}

void arrowkeys()
{
  if (keyPressed && (key == CODED)) // if you press the arrow keys
  {
    if (keyCode == RIGHT && FallDownBallX<width-15) // move the ball and make it stay in boundaries
      FallDownBallX=FallDownBallX+3.5;
    else if (keyCode== LEFT && FallDownBallX>15) // move the ball and make it stay in boundaries
      FallDownBallX=FallDownBallX-3.5;
  }
}

void Screen5() { // draw the menu screen
  tint(255, tint+=1); // make it fade in
  platformSetup(); // intialize everything and set the variables back to default
  platSpeed=1;
  FallDownVelocity=0;
  FallDownBallX=width / 2;
  FallDownBallY=0;
  lineCounter=0;
  background(0);
  fill(220, 20, 60);
  rectMode(CENTER);
  stroke(0, 255, 0);
  rect(300, 100, 250, 40);
  rect(300, 175, 250, 40);
  rect(300, 250, 250, 40);
  fill(0);
  textSize(20);
  strokeWeight(1);
  text("PLAY!", 305, 110);
  text("MENU!", 305, 185);
  textSize(18);
  text("INSTRUCTIONS!", 303, 260);
  if (FallDownScore > 0) { // if you played
    fill(255, 0, 0);
    text("YOUR SCORE WAS: " + FallDownScore + "!", width/2, 350); // display the score
  }
  if (mouseX >= 175 && mouseX <= 425 && mouseY >= 80 && mouseY <= 120 && mousePressed) {  //if you press play
    gameState = 6; // start the game
    FallDownScore=0;
  } else if (mouseX >= 175 && mouseX <= 425 && mouseY >= 155 && mouseY <= 195 && mousePressed) // if you press menu
    gameState = 0; // go to  the start menu
  else if (mouseX >= 175 && mouseX <= 425 && mouseY >= 230 && mouseY <= 270 && mousePressed)  // if you press instructions
    gameState = 9; // load the instruction page
}

void Screen6() { // draw the game stage
  background(0);
  tint(255, 255); // make it full opacity
  displayPlatforms(); // draw platforms
  
  displayBall(); // draw ball
  arrowkeys(); // allow arrowkey input
  physics(); // allow physics
  fill(220, 20, 60);
  textSize(20);
  text("SCORE: " + FallDownScore, width/2, 25);
  text("HIGH-SCORE: " + FallDownHighScore, width/2, 50);
  if (FallDownBallY < 0) { // if you lose
    gameState = 5; // go back to the menu
  }
}

void Screen9() { // draw the instruction page
  tint(255, 255);
  strokeWeight(1);
  background(0); // draw background
  fill(220, 20, 60);
  rect(300, 50, 250, 40);
  rect(300, 250, 425, 275);
  fill(0);
  textSize(18);
  text("Back To Game!", 300, 59);
  textSize(22);
  text("Instructions:", 300, 140);
  strokeWeight(3);
  line(155, 145, 425, 145);
  textSize(14);
  text("Welcome to FallDown. The \n objective of this game is to \n roll the ball through the \n holes for as long as possible. \n This can be achieved by moving \n the red ball with the arrow \n keys. Each time you go through \n a hole, you are awarded \n a point. Try to reach \n the highest score possible. \n \n Good Luck & Enjoy!", 300, 178);
  if (mouseX >= 175 && mouseX <= 425 && mouseY >= 30 && mouseY <= 70 && mousePressed) // if you press back
    gameState = 5; // go back to the menu
}

void draw() {
  
  if (gameState == 0)  // load menu
    Screen0(); 
  else if (gameState == 1)  // load keepups menu
    Screen1();
  else if (gameState == 2) // load keepups game
    Screen2();
  else if (gameState == 3) // load firing range menu
    Screen3();
  else if (gameState == 4) // load firing range game
    Screen4();
  else if (gameState == 5) // load falldown menu
    Screen5();
  else if (gameState == 6) // load falldown game
    Screen6();
  else if (gameState == 7) // load keepups instruction
    Screen7();
  else if (gameState == 8) // load firing range instruction
    Screen8();
  else if (gameState == 9) // load falldown instruction
    Screen9();

  if (MenuSong.position() >= 202187)
    MenuSong.rewind();

  if (KeepUpsGameSong.position() >= 259761)
    KeepUpsGameSong.rewind();

  if (FiringRangeGameSong.position() >= 171546)
    KeepUpsGameSong.rewind();

  if (FallDownGameSong.position() >= 148897) 
    FallDownGameSong.rewind();
} 

void mousePressed() {
  if (mouseX>KeepUpsX-35 && mouseX < KeepUpsX + 35 && mouseY > KeepUpsY - 35 && mouseY < KeepUpsY + 35 && mousePressed && gameState == 2) { // if the mouse is on the ball and it is pressed
    KeepUpsSound = floor(random(1, 3)); // make a random number between 1 and 2 for the sounds
    if (KeepUpsSound ==1) { // play the 1st kick
      kick1.rewind(); // rewind the sound so you can play it again
      kick1.play(); // play the sound
    } else if (KeepUpsSound ==2) { // play the 2nd kick
      kick2.rewind(); // rewind the sound so u can play it again
      kick2.play(); // play the sound
    }
    velocityY=-10; // change to y velocity to go upwards
    velocityX=-(mouseX-KeepUpsX)/4; // make the ball go either left or right depending on where u click it
    KeepUpsScore=KeepUpsScore+1; // add a point 
    if (KeepUpsScore > KeepUpsHighScore) {// if the KeepUpsScore is higher than the highKeepUpsScore
      KeepUpsHighScore = KeepUpsScore; // set the highscore to be the score
      KeepUpsScoreSound.play(); // play the sound
    }
  }
  if (ammo > 0 && gameState == 4) { // if the game is playing and u have ammo and shoot
    FiringRangeSound = floor(random(1, 3)); // make a random number between 1 and 2 for the sounds
    if (FiringRangeSound ==1) { // play the 1st shot
      shot1.rewind(); // rewind the sound so you can play it again
      shot1.play(); // play the sound
    } else if (FiringRangeSound ==2) { // play the 2nd shot
      shot2.rewind(); // rewind the sound so u can play it again
      shot2.play(); // play the sound
    }
    if (mouseX > FiringRangeX - FiringRangeR && mouseX < FiringRangeX + FiringRangeR && mouseY > FiringRangeY - FiringRangeR && mouseY < FiringRangeY + FiringRangeR) { // if the mouse is pressed and you shoot the target
      metal.rewind(); //rewind the sound so you can play it again
      metal.play(); // play the sound
      if (mouseX > FiringRangeX - 10 && mouseX < FiringRangeX + 10 && mouseY > FiringRangeY - 10 && mouseY < FiringRangeY + 10) 
        FiringRangeScore+=1;
      FiringRangeScore+=+1; // add a point
      fill(0); // make a black cursor on the target when you sucessfully hit one
      ellipse(mouseX, mouseY, 20, 20);
      FiringRangeR = -3; // set the target to a negative value so it makes a new one when you shoot it
      if (FiringRangeScore > FiringRangeHighScore) // if the score is higher than the highscore
        FiringRangeHighScore = FiringRangeScore; // make the score the new highscore
    }
    ammo--; // lose a bullet
  } else if (ammo == 0) { // if theres no ammo play the empty magazine sound
    reload.rewind(); // rewind the sound so u can play it again
    reload.play(); // play the sound
  }
}

void keyReleased() {
  if (keyCode == SHIFT && ammo == 0 && reloadCheck ==false)  // if you press shift refill ammo and set the reload animation to default value
    reloadCheck = true;
}