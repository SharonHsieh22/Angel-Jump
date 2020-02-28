void player1() {
  player1 = new FBox(gridsize*2-8, gridsize*2);
  player1.setPosition(width/6, 6800);

  //set physical properties
  player1.setStatic(false);
  player1.setDensity(.5);
  player1.setFriction(0);
  player1.setRestitution(1);
  player1.setRotatable(false);
  

  //add to world
  world.add(player1);
}
