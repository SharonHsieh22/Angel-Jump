import fisica.*;

color black = #000000;
color white = #FFFFFF;
color cyan   = #5CF3F7;
color blue   = #552DFA;
color pink   = #FC73FB;
color purple = #C60DFF;
color green  = #29FFAF;
color red    = #FF0000;
color orange = #FF920D;
color yellow = #FFFF50;

PImage map;
PImage francis, bg;
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
int gridsize = 30;
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
  francis = loadImage("francis.png");
  bg = loadImage("bgindustry.jpg");

  flyright = new PImage[4];
  flyleft = new PImage[4];
  land = new PImage[1];
  jump = new PImage[1];
  jumpleft = new PImage[1];

  flyright[0] = loadImage("francis1.png");
  flyright[1] = loadImage("francis2.png");
  flyright[2] = loadImage("francis3.png");
  flyright[3] = loadImage("francis4.png");
  
  flyleft[0] = loadImage("francis7.png");
  flyleft[1] = loadImage("francis8.png");
  flyleft[2] = loadImage("francis9.png");
  flyleft[3] = loadImage("francis10.png");
  
  jump[0] = loadImage("francis6.png");

  land[0] = loadImage("francis5.png");

  currentAction = land;

  //load world
  while (y < map.height) {
    color c = map.get(x, y);    
    if (c == black) {
      FBox b = new FBox(gridsize, gridsize);
      b.setFillColor(white);
      b.setStrokeColor(white);
      b.setPosition(x*gridsize, y*gridsize);
      b.setStatic(true);
      b.setName("top");
      boxes.add(b);
      world.add(b);
    }
    if (c == red) {
      FBox b = new FBox(gridsize, gridsize);
      b.setFillColor(white);
      b.setStrokeColor(white);
      b.setPosition(x*gridsize, y*gridsize);
      b.setStatic(true);
      b.setName("bottom");
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
  image(bg, 0, -100, 1500, 1500);

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
  if (contacts.size() > 0) {
    for(FContact pc: contacts) {
      if(pc.contains("top")) {
        player1.setVelocity(player1.getVelocityX(), -800);
        for(int i = 0; i < boxes.size(); i++) {
         FBox b = boxes.get(i);
         
        }
      }
    }
    
  }
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
