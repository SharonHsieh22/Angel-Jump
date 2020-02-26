class coin {
  float x, y;
  coin() {
    
  }

  void exist() {
    image(coin[coinNum], x, y);
    if (frameCount % 10 == 0) {
      coinNum++;
      if (coinNum == coin.length) coinNum = 0;
    }
  }
}
