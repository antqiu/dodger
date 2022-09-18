class targets {
  //variables
  int targetx;
  int targety;
  int targetxvel=0;
  int targetyvel=0;
  color targetc; 
  int radius;
  
  //constructor
  targets(int radius_t, color color_t) {
    targetx=int(random(width));
    targety=int(random(0,height/1.5));
    radius=radius_t;
    targetc=color_t;
  }

  void display() {
    //draws enemy ships
    fill(targetc);
    fill(currenttargetc);
    radius=currenttarrgetr;
    noStroke();
    circle(targetx,targety,2*radius);
    //calculates if ship and the target intersect
    if (((Math.abs(targetx-shipx-shipw/2)-shipw/2)*(Math.abs(targetx-shipx-shipw/2)-shipw/2))+((Math.abs(targety-shipy-shiph/2)-shiph/2)*(Math.abs(targety-shipy-shiph/2)-shiph/2)) <= pow((currenttarrgetr),2)) {
       shipx=300-shipw;
       shipy=800-shiph;
       shipxvel=0;
       shipyvel=0;
       reset();
       display();
       //updates the monitor
       brcSetMonitor("score",((millis()-start)/1000));
       scores.append(millis()-start);
       start=millis();
    }
  }
  
//movement
  void move(int speed_t) {
    targetxvel=int(random(-2,2));
    //1=slow, 2=med, 3=fast
    if (speed_t==1) {
      targetyvel=int(random(1,4));
    }
    if (speed_t==2) {
      targetyvel=int(random(3,6));
    }
    if (speed_t==3) {
      targetyvel=int(random(5,8));
    }
    targetx+=targetxvel;
    targety+=targetyvel;
    
    if (targety>=height) {
      targetx=int(random(width));
      targety=0;
    }
  }

//enemy ships that reach the end go back up to the top
  void restart() {
     if (targety>=height) {
      targetx=int(random(width));
      targety=0;
    }
  }
}
