//global vars //<>//
int shipw=70;
int shiph=35;
color shipc=color(0,255,0);
int shipx=300-shipw;
int shipy=800-shiph;
int shipxvel;
int shipyvel;
int targetspeed=1;
int targetradius=25;
color targetcolor=color(255,0,0); 
int ntargets=12;
targets[] enemies=new targets[ntargets];
boolean once=false;
boolean shooting=false;
ArrayList<pew> bullets=new ArrayList<pew>();
boolean running=false;
boolean hit=false;
boolean detect=false;
color shipcolor;
color defaultc=color(255,0,0);
int defaultr=15;
color currenttargetc=color(255,0,0);
int currenttarrgetr=15;
int start=millis();
int[] highest=new int[999];
String background="black";
IntList scores=new IntList();

void setup() {
  background(0);
  size(600,800);
  brcShowMessages(true);
  //enemies = new ArrayList<targets>(); 
}

void draw() {
  brc();
  
  if (background.equals("black")) {
    background(0);
  }
  if (background.equals("sky")) {
    sky(); 
  }
  if (background.equals("space")) {
    space();
  }
  
  
  
  //background(0); //use brc
  stroke(0);
  
  //brc variables
  String name = brcChanged(); 
  
  //starts
  if (name.equals("start")) {
    start=millis();
    running=true;
    brcSetMonitor("score",((millis()-start)/1000));
  }
  
  //restart
  if (name.equals("restart")) {
      if (background.equals("black")) {
    background(0);
  }
  if (background.equals("sky")) {
    sky(); 
  }
  if (background.equals("space")) {
    space();
  }
    sky();
    shipxvel=0;
    shipyvel=0;
    displayship();
    for (int i=0;i<ntargets;i++) {
      enemies[i].targetx=int(random(width));
      enemies[i].targety=int(random(0,height/2));
      enemies[i].display(); 
      //change time
    }
     brcSetMonitor("score",((millis()-start)/1000));
     scores.append(millis()-start);
     start=millis();
  }

  //stops
  if (!running) return;
  
  //1=slow, 2=med, 3=fast (state variables)
  if (name.equals("speed")) {
    String speed = brcValue("speed");
    if (speed.equals("S")) {
      targetspeed=1;
    }
    if (speed.equals("M")) {
      targetspeed=2;
    }
    if (speed.equals("L")) {
      targetspeed=3;
    }
  }
  
  
  if (name.equals("bg")) {
    String bg=brcValue("bg");
    if (bg.equals("S")) {
     // sky();
      background="sky";
    }
    if (bg.equals("SP")) {
     // space();
      background="space";
    }
    if (bg.equals("B")) {
      //black();
      background="black";
    }
  }

//high score
  if (scores.size()>=1) {
    scores.sortReverse();
    int highest=scores.get(0)/1000;
    brcSetMonitor("highest",highest);
  }
  

  //decides which color the enemy ships are
  if (name.equals("colors")) {
    String colors = brcValue("colors"); 
    decideColor(colors);
  }
  
  //decides how big the enemy ships are
    if (name.equals("size")) {
    String radius = brcValue("size"); 
    decideRadius(radius);
  }
  
  //makes slots the enemies in an array
  if (once==false) {
    for (int i=0; i<ntargets; i++) {
      enemies[i] = new targets(defaultr, defaultc);  
    }
  once=true;
  }
  
  //displays the enemies and makes them move down
  for (int i=0; i<ntargets; i++) {
    enemies[i].display();
    enemies[i].move(targetspeed);
  }
  
  //creating the ship
  fill(shipc);
  rect(shipx,shipy,shipw,shiph);
  
  //movement
  shipx += shipxvel;
  shipy += shipyvel;
  
  //ship stops at borders
  if (shipx < 0) //left wall
    shipxvel = 0;
  if (shipx+shipw >= width) //right wall
    shipxvel = 0;
  if (shipy < 0) //top
    shipyvel = 0;
  if (shipy+shiph>= height) //bottom
    shipyvel = 0;
   
   //bullet detection if it hits an enemy target
   if (shooting) {
     for (int i = 0; i < bullets.size(); i++) {
        pew bullet = (pew) bullets.get(i);
        bullet.display();
        sky();
          if (background.equals("black")) {
    background(0);
  }
  if (background.equals("sky")) {
    sky(); 
  }
  if (background.equals("space")) {
    space();
  }
        display();
        displayship();
        bullet.move();
        bullet.display();          
        for (int q=0; q<ntargets; q++) {
          bullet.detect(enemies[q]); //changes detect to true in which the next display changes it to black
          if (detect==true) {
            enemies[q].targetx=int(random(width));
            enemies[q].targety=int(random(height/3));
                detect=false;
        }
        }
        detect=false;
     }
}

if (shipx<0 || shipy+shiph>height || shipy<0 || shipx+shipw>width) {
  if (background.equals("black")) {
    background(0);
  }
  if (background.equals("sky")) {
    sky(); 
  }
  if (background.equals("space")) {
    space();
  }
  reset();
  shipx=300-shipw;
  shipy=800-shiph;
  displayship();
  brcSetMonitor("score",((millis()-start)/1000));
  scores.append(millis()-start);
  start=millis();
}

}


  //ship controls
void keyPressed() {
  //checks if the Vel is greater than max before it can move
    if (key == 'w' && shipyvel >= -1) 
      shipyvel -= 1;
    if (key == 'a' && shipxvel >= -1 ) 
      shipxvel -= 1; 
    if (key == 's' && shipyvel <=  1) 
      shipyvel += 1;
    if (key == 'd' && shipxvel <= 1) 
      shipxvel += 1;
  }
 
//makes a bullet
void mousePressed() {
   pew b = new pew(shipx+shipw/2,shipy);
   bullets.add(b);
   shooting=true;
}

void reset() {
    for (int i=0; i<ntargets; i++) {
    enemies[i].targety=int(random(height/2));
  }
}

//function to re-display the enemies
void display() {
    for (int i=0; i<ntargets; i++) {
    enemies[i].display();
  }
}

//function to re-display the ship
void displayship() {
  fill(shipc);
  rect(shipx,shipy,shipw,shiph);
}

//decides the color of the enemy ships
void decideColor(String a) {
    if (a.equals("RD")) {
      currenttargetc=color(int(random(255)), int(random(255)), int(random(255)));
    }
    if (a.equals("R")) {
      currenttargetc=color(255,0,0);
    }
    if (a.equals("O")) {
      currenttargetc=color(255,165,0);
    }
    if (a.equals("B")) {
      currenttargetc=color(0,0,255);
    } 
  }
  
//decides the radius of the enemy ships
void decideRadius(String p) {
      if (p.equals("S")) {
        currenttarrgetr=15;
      }
      if (p.equals("M")) {
        currenttarrgetr=25;
      }
      if (p.equals("L")) {
        currenttarrgetr=35;
      }
  }

void sky() {
  background(173,216,230);
  fill(255,255,153);
  noStroke();
  circle(0,0,200);
  stroke(255,255,153);
  fill(255);
  stroke(255);
  circle(425,85,50);
  circle(455,65,70);
  circle(500,85,60);
  circle(465,75,80);
  fill(86,125,70);
  ellipse(0,height,800,300);
  ellipse(width,height,800,300);
}

//Star function taken from Processing Reference Page (https://processing.org/examples/star.html)
void star(float x, float y, float radius1, float radius2, int npoints) {
  float angle = TWO_PI / npoints;
  float halfAngle = angle/2.0;
  beginShape();
  for (float a = 0; a < TWO_PI; a += angle) {
    float sx = x + cos(a) * radius2;
    float sy = y + sin(a) * radius2;
    vertex(sx, sy);
    sx = x + cos(a+halfAngle) * radius1;
    sy = y + sin(a+halfAngle) * radius1;
    vertex(sx, sy);
  }
  endShape(CLOSE);
}

void space() {
  background(50);
  fill(255);
  circle(0,0,500);
  fill(255,255,0);
  star(50, 330, 7, 12, 5); 
  star(90, 450, 7, 11, 5);
  star(20, 700, 7, 11, 5);
  star(210, 625, 7, 11, 5);
  star(300, 750, 7, 11, 5);
  star(210, 300, 7, 11, 5);
  star(300, 200, 7, 11, 5);
  star(400, 450, 7, 11, 5);
  star(435, 650, 7, 11, 5);
  star(525, 200, 7, 11, 5);
  star(485, 385, 7, 11, 5);
}
