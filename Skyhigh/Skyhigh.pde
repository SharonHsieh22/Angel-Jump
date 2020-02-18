import fisica.*;

color black = #000000;
color cyan   = #5CF3F7;
color blue   = #552DFA;
color pink   = #FC73FB;
color purple = #C60DFF;
color green  = #29FFAF;
color red    = color(224, 80, 61);
color orange = #FF920D;
color yellow = #FFFF50;

PImage map;
PImage levi, francis;
PImage[] flyright;
PImage[] flyleft;
PImage[] land;
PImage[] jump;
PImage[] jumpleft;
PImage[] currentAction;
int costumeNum = 0;
int frame = 0;

int x = 0;
int y = 0;
int gridsize = 60;
float vx, vy, zoomfactor, angle;
boolean leftkey, rightkey, akey, dkey, spacekey;

ArrayList<FBox> boxes = new ArrayList<FBox>();

FBox player1, player2;
FWorld world;

void setup() {
  fullScreen(FX2D);
  Fisica.init(this);
  world = new FWorld(-10000, -10000, 10000, 10000);
  world.setGravity(0, 900);
  map = loadImage("map.png");
  levi = loadImage("Levi.png");
  francis = loadImage("francis.png");

  flyright = new PImage[3];
  flyleft = new PImage[3];
  land = new PImage[1];
  jump = new PImage[1];
  jumpleft = new PImage[1];

  flyright[0] = loadImage("francis1.png");
  flyright[1] = loadImage("francis2.png");
  flyright[2] = loadImage("francis3.png");
  
  flyleft[0] = loadImage("hatsume5.png");
  flyleft[1] = loadImage("hatsume6.png");
  flyleft[2] = loadImage("hatsume7.png");
  
  jump[0] = loadImage("francis6.png");
  jumpleft[0] = loadImage("hatsume9.png");

  land[0] = loadImage("francis5.png");

  currentAction = land;

  //load world
  while (y < map.height) {
    color c = map.get(x, y);    
    if (c == black) {
      FBox b = new FBox(gridsize, gridsize);
      b.setFillColor(black);
      b.setPosition(x*gridsize, y*gridsize);
      b.setStatic(true);
      //b.setName("");
      boxes.add(b);
      world.add(b);
    }

    x++;
    if (x == map.width) {
      x = 0;
      y++;
    }
  }

  player1();
}

void draw() {
  background(255);

  pushMatrix();
  translate(-player1.getX() + width/2, -player1.getY() + height/2);
  world.step();
  world.draw();
  popMatrix();

  //left, right movement
  vx = 0;
  if (leftkey) { 
    vx = -500;
    currentAction = flyleft;
  }
  if (rightkey) {
    vx = 500;    
    currentAction = flyright;
  }
  player1.setVelocity(vx, player1.getVelocityY());

  //idle
  if (!leftkey && !rightkey) {    
    currentAction = land;
    costumeNum = 0;
  }

  //jumping
  ArrayList<FContact> contacts = player1.getContacts();
  //if (contacts.size() > 0) {
  //  player1.setVelocity(player1.getVelocityX(), -800);
  //  currentAction = land;
  //  costumeNum = 0;
  //}
  if(contacts.size() == 0 && !leftkey && !rightkey) {
    currentAction = jump;
    costumeNum = 0;
  } 
  if(leftkey && contacts.size() == 0) {
    currentAction = flyleft;
  }
  
  if(rightkey && contacts.size() == 0) {
    currentAction = flyright;
  }
  
  if(player1.getVelocityY() > 20 && !leftkey && !rightkey) {
    currentAction = land;
    costumeNum = 0;
  }
  //if(contacts.contains(""))
  
  player1.attachImage(currentAction[costumeNum]);
   if(frameCount % 10 == 0) {
    costumeNum++;
    if(costumeNum == currentAction.length) costumeNum = 0;
   }

}

void keyPressed() {
  if (keyCode == LEFT) leftkey = true;
  if (keyCode == RIGHT) rightkey = true;
  if (key == 'a' || key == 'A') akey = true;
  if (key == 'd' || key == 'D') dkey = true;
  if (key == ' ') spacekey = true;
}

void keyReleased() {
  if (keyCode == LEFT) leftkey = false;
  if (keyCode == RIGHT) rightkey = false;
  if (key == 'a' || key == 'A') akey = false;
  if (key == 'd' || key == 'D') dkey = false;
  if (key == ' ') spacekey = false;
}
