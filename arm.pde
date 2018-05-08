/* @pjs pauseOnBlur="true"; */

int width = document.getElementById('armCanvas').offsetWidth - 50;
int height = width/1.75;

int background_color = 255;
int alpha = 255;
float dampCons = 0.1;
int numSegs = 10;
int segHeight = 50;
int segWidth = 50;
int armYStart = height/2 - segWidth/2;
int armXStart = 0;
float muscleStren = 0.01;
float supportStren = 0.1;
float shrinkMod = 0.95;

int score = 0;

font = loadFont("FFScala.ttf"); 
textFont(font);
textSize(30); 

ArrayList<MassPoint> upPoints;
ArrayList<MassPoint> downPoints;
ArrayList<MassPoint> tip;

ArrayList<Spring> upSprings;
ArrayList<Spring> downSprings;
ArrayList<Spring> middleSpring;
ArrayList<Spring> top2botSprings;
ArrayList<Spring> bot2topSprings;

MassPoint upAnchor = new MassPoint(armXStart, armYStart, 0, 0, 5);
MassPoint downAnchor = new MassPoint(armXStart, armYStart+segHeight, 0, 0, 5);

MassPoint upNoMove = new MassPoint(armXStart, armYStart, 0, 0, 5);
MassPoint downNoMove = new MassPoint(armXStart, armYStart+segHeight, 0, 0, 5);

char[] upKeys = {'q','w','e','r','t','y','u','i','o','p'};
char[] downKeys = {'a','s','d','f','g','h','j','k','l',';'};

int targetX;
int targetY;

// Setup the Processing Canvas
void setup(){
  size(width, height);
  strokeWeight(1);
  stroke(#000000);
  //frameRate( 15 );
  background(#FFFFFF);
  fill(#FFFFFF,alpha);

  upPoints = new ArrayList<MassPoint>();
  downPoints = new ArrayList<MassPoint>();

  tip = new ArrayList<MassPoint>();

  upSprings = new ArrayList<Spring>();
  downSprings = new ArrayList<Spring>();
  middleSpring = new ArrayList<Spring>();
  top2botSprings = new ArrayList<Spring>();
  bot2topSprings = new ArrayList<Spring>();

  targetX = random(width/4, width/2 + 50 );

  if(random(1)>0.5){
    targetY = random(100, height/2 - 100);
  }
  else{
    targetY = random(height/2 + 100, height-100);
  }

  for (int i = 0; i < numSegs; i++) {
    float newSegHeight = (segHeight)*pow(shrinkMod,(i));

    upPoints.add(new MassPoint((i+1)*segWidth+armXStart, armYStart, 0, 0, 5));
    downPoints.add(new MassPoint((i+1)*segWidth+armXStart, armYStart+newSegHeight, 0, 0, 5));
  }

  tip.add(upPoints.get(numSegs-1));
  tip.add(upPoints.get(numSegs-2));
  tip.add(downPoints.get(numSegs-1));
  tip.add(downPoints.get(numSegs-2));

  for (int i = 0; i < numSegs; i++) {
    float newSegHeight = (segHeight)*pow(shrinkMod,(i));
    if(i == 0){
      upSprings.add(new Spring(upAnchor,upPoints.get(i), segWidth, muscleStren));
      downSprings.add(new Spring(downAnchor,downPoints.get(i), segWidth, muscleStren));
      middleSpring.add(new Spring(upAnchor,downAnchor, newSegHeight, supportStren));
      middleSpring.add(new Spring(upPoints.get(i),downPoints.get(i), segWidth, supportStren));
      top2botSprings.add(new Spring(upAnchor,downPoints.get(i), dist(upAnchor,downPoints.get(i)), supportStren));
      bot2topSprings.add(new Spring(downAnchor,upPoints.get(i), dist(downAnchor,upPoints.get(i)), supportStren));
    }
    else{
      upSprings.add(new Spring(upPoints.get(i-1),upPoints.get(i), segWidth, muscleStren));
      downSprings.add(new Spring(downPoints.get(i-1),downPoints.get(i), segWidth, muscleStren));
      middleSpring.add(new Spring(upPoints.get(i),downPoints.get(i), newSegHeight, supportStren));
      top2botSprings.add(new Spring(upPoints.get(i-1),downPoints.get(i), dist(upPoints.get(i-1),downPoints.get(i)), supportStren));
      bot2topSprings.add(new Spring(downPoints.get(i-1),upPoints.get(i), dist(downPoints.get(i-1),upPoints.get(i)), supportStren));
    }
  }
}

// Main draw loop
void draw(){
  background(background_color);

  upAnchor = upNoMove;
  downAnchor = downNoMove;

  stroke(0);
  fill(1);

  for (Spring spring : upSprings) {
    if(spring.active & (spring.springLength > 10)){
      spring.springLength -= 1
    }
    else{
      spring.restore()
    }
    spring.move();
    line(spring.mp1.xPos, spring.mp1.yPos, spring.mp2.xPos, spring.mp2.yPos);
  }
  for (Spring spring : downSprings) {
    if(spring.active & (spring.springLength > 10)){
      spring.springLength -= 1
    }
    else{
      spring.restore()
    }
    spring.move();
    line(spring.mp1.xPos, spring.mp1.yPos, spring.mp2.xPos, spring.mp2.yPos);
  }
  for (Spring spring : middleSpring) {
    spring.move();
    line(spring.mp1.xPos, spring.mp1.yPos, spring.mp2.xPos, spring.mp2.yPos);
  }
  for (Spring spring : top2botSprings) {
    spring.move();
    line(spring.mp1.xPos, spring.mp1.yPos, spring.mp2.xPos, spring.mp2.yPos);
  }
  for (Spring spring : bot2topSprings) {
    spring.move();
    line(spring.mp1.xPos, spring.mp1.yPos, spring.mp2.xPos, spring.mp2.yPos);
  }

  ellipse(upAnchor.xPos, upAnchor.yPos, upAnchor.mass, upAnchor.mass);
  ellipse(downAnchor.xPos, downAnchor.yPos, downAnchor.mass, downAnchor.mass);

   for (MassPoint point : upPoints) {
     point.move();
     ellipse(point.xPos, point.yPos, point.mass, point.mass);
   }
   for (MassPoint point : downPoints) {
     point.move();
     ellipse(point.xPos, point.yPos, point.mass, point.mass);
   }
   stroke(#1390C6);
   fill(#1390C6);
   for (MassPoint point : tip) {
     point.move();
     ellipse(point.xPos, point.yPos, point.mass, point.mass);
   }
    
   rect(width-125, height-50, 125, 50);
   fill(#FFFFFF);
   text("Restart", width-112, height-15); 

   if(!focused){
     ellipse(width/2, height/2, 200, 200);
     fill(#1390C6);
     text("Click to Start", width/2-85, height/2+10); 
   }

   fill(#1390C6);
   text(str(score), width-50, 50); 

   ellipse(targetX, targetY, 10, 10);

   checkTarget();    
}

float dist(MassPoint mp1, MassPoint mp2){
  return(sqrt(pow((mp1.xPos-mp2.xPos),2)+pow((mp1.yPos-mp2.yPos),2)))
}

void keyPressed() {
  setMove(keyCode, true);
}
 
void keyReleased() {
  setMove(keyCode, false);
}

boolean setMove(int k, boolean b) {
  for (int i = 0; i < numSegs; i++){
    if(key == upKeys[i]){
      upSprings.get(i).active = b;
    }

    if(key == downKeys[i]){
      downSprings.get(i).active = b;
    }
  }
}

void mouseClicked() {
  if(mouseX > (width-125) & mouseX < (width) & mouseY > (height-50) & mouseY < height){
    setup();
  }
}

void checkTarget(){

  int maxX = 0;
  int minX = width;
  int maxY = 0;
  int minY = height;

  for (MassPoint point : tip) {
    maxX = max(maxX,point.xPos);
    minX = min(minX,point.xPos);
    maxY = max(maxY,point.yPos);
    minY = min(minY,point.yPos);
  }

  if(minX < targetX & targetX < maxX & minY < targetY & targetY < maxY){
    score += 1;
    setup();
  }
}

class MassPoint { 
  float xPos,yPos,mass; 
  float xSpeed,ySpeed;

  MassPoint (int x, int y, float s, float a, int m) {  
    xPos = x; 
    yPos = y;
    xSpeed =  (s * sin(a)); 
    ySpeed = -(s * cos(a)); 
    mass = m; 
  } 

  void move(){
    xPos += xSpeed;
    yPos += ySpeed;
    point(xPos,yPos);
  }

  void applyForce( float fx, float fy )
  {  
    float x = fx / mass;
    float y = fy / mass;
    xSpeed = xSpeed + x;
    ySpeed = ySpeed + y;
    xPos = xPos + x;
    yPos = yPos + y;
  }
}

class Spring { 
  float springLength, springStrength, springStretch;
  boolean active;
  MassPoint mp1, mp2;

  Spring (MassPoint mp1, MassPoint mp2, float l, float s) {  
    this.mp1 = mp1;
    this.mp2 = mp2;
    springOrigLength = l; 
    springLength = l; 
    springStrength = s; 
    springStretch = 0;
    active = false;
  } 
  void move(){
    float xDelta = mp2.xPos - mp1.xPos;
    float yDelta = mp2.yPos - mp1.yPos;
    float dist = sqrt( (xDelta*xDelta) + (yDelta*yDelta) );
    springStretch = (dist-springLength);// * 0.01;//1-exp(dampCons);
    float power = springStretch * springStrength * dampCons;
    mp1.applyForce(  xDelta*power,  yDelta*power );
    mp2.applyForce( -xDelta*power, -yDelta*power );
  }
  void restore(){
    if(springLength < springOrigLength){
      springLength += 0.5;
    }
  }
}