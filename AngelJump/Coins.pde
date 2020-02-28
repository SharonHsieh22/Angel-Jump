class coin extends GameObject {
  float x, y;
  coin(float _x, float _y) {
    x = _x;
    y = _y;
    lives = 1;
  }

  void exist() {
    pushMatrix();
    translate(-player1.getX() + width/2, -player1.getY() + height/2);
    image(coin[coinNum], x, y, 40, 40);
    if (frameCount % 10 == 0) {
      coinNum++;
      if (coinNum == coin.length) coinNum = 0;
    }    
    popMatrix();    
    for (int i = 0; i < gameObjects.size(); i++) {
      GameObject myObj = gameObjects.get(i);
      if (myObj instanceof coin) {
        if (dist(player1.getX(), player1.getY(), x, y) < 40) {
          points++;
          lives = 0;
        }
      }
    }
  }
}
