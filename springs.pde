MassPoint mpS = new MassPoint(100, 100, 0, PI, 20);
MassPoint mp0 = new MassPoint(100, 100, 0, PI, 20);
MassPoint mp1 = new MassPoint(50,  100, 0, PI, 10);
MassPoint mp2 = new MassPoint(50, 150, 1, PI, 5);
Spring s1 = new Spring(mp0,mp1,50,0.0001);
Spring s2 = new Spring(mp1,mp2,50,0.0001);
int background_color = 64;
int alpha = 255;

// Setup the Processing Canvas
void setup(){
  size(screen.width, screen.height);
  strokeWeight(1);
  stroke(#000000);
  //frameRate( 15 );
  background(background_color);
  fill(#FFFFFF,alpha);

}

// Main draw loop
void draw(){
    background(background_color);

    // Spring 0 is static and cannot move
    mp0.xPos = mpS.xPos;
    mp0.yPos = mpS.yPos;

    // Spring 1 and 2 can move
    mp1.move();
    mp2.move();
    s1.move();
    s2.move();

    // Red when compressed, green when stretched
    stroke( constrain(127-4*round(s1.springStretch),0,255),constrain(4*round(s1.springStretch)-127,0,255), 0 );
    line(mp0.xPos, mp0.yPos, mp1.xPos, mp1.yPos);

    stroke( constrain(127-4*round(s2.springStretch),0,255),constrain(4*round(s2.springStretch)-127,0,255), 0 );
    line(mp1.xPos, mp1.yPos, mp2.xPos, mp2.yPos);

    stroke(0);
    fill(1);
    ellipse(mp0.xPos, mp0.yPos, mp0.mass, mp0.mass);
    ellipse(mp1.xPos, mp1.yPos, mp1.mass, mp1.mass);
    ellipse(mp2.xPos, mp2.yPos, mp2.mass, mp2.mass);

    //println(mp1.xPos);
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
  MassPoint mp1, mp2;

  Spring (MassPoint mp1, MassPoint mp2, float l, float s) {  
    this.mp1 = mp1;
    this.mp2 = mp2;
    springLength = l; 
    springStrength = s; 
    springStretch = 0;
  } 
  void move(){
    float xDelta = mp2.xPos - mp1.xPos;
    float yDelta = mp2.yPos - mp1.yPos;
    float dist = sqrt( (xDelta*xDelta) + (yDelta*yDelta) );
    springStretch = (dist-springLength);
    float power = springStretch * springStrength;
    mp1.applyForce(  xDelta*power,  yDelta*power );
    mp2.applyForce( -xDelta*power, -yDelta*power );
  }
}