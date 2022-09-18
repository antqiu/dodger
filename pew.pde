class pew {
  int bulletx;
  int bullety;
  int radius=20;
  int change=30;
  color bulletc=color(255,255,0);
  //boolean detect=false;
  
  pew(int bulletx_t, int bullety_t) {
    bulletx=bulletx_t;
    bullety=bullety_t;
  }
  
  void move() {
    bullety-=change;
  }
  
  void display() {
    fill(bulletc);
    if (detect==true) {
      fill(0);
    }
    noStroke();
    circle(bulletx,bullety-20,2*radius);
  }
  
  //detects if the bullet touches an enemy ship
  void detect(targets a) {
    if (dist(a.targetx,a.targety,bulletx,bullety) < currenttarrgetr+radius) detect=true;
}

}
