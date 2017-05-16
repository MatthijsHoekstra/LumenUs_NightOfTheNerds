class DBZ {

  int tubeModulus;
  int tripodNumber;
  int touchLocation;

  purpleRect p;
  blueRect b;
  sinRect s;
  whiteRect w;

  int startTime;
  int time;

  DBZ (int tubeModulus, int tripodNumber, int touchLocation) {
    this.tubeModulus = tubeModulus;
    this.tripodNumber = tripodNumber;

    this.touchLocation = touchLocation;

    p = new purpleRect();
    b = new blueRect();
    s = new sinRect();
    w = new whiteRect();

    startTime = millis();
  }

  void update() {
    pushMatrix();

    translate(this.tubeModulus * (numLEDsPerTube * rectWidth) + (this.tubeModulus * 20 + 20), this.tripodNumber * 21 + 21);

    //background(255);
    time = millis()-startTime;

    p.update();
    b.update();
    if (time >= 1000 && time <=4000) {
      s.update();
    }
    if (time >= 4000 && time <= 6000) {
      w.update();
    }
    popMatrix();
  }

  class blueRect {

    int startTime;
    int interTime;
    int endTime;

    blueRect() {
      startTime = millis();
      interTime = 1000;
      endTime = 6000;
    }

    void update() {
      pushStyle();
      noStroke();
      fill (0, 0, 255);
      if (millis() <= startTime + endTime) {
        float currentTime = constrain(map (millis(), startTime, startTime + interTime, 0, tubeLength/2), 0, tubeLength/2);
        rect(0, 0, currentTime, rectHeight);
      }
      popStyle();
    }
  }

  class purpleRect {

    int startTime;
    int interTime;
    int endTime;

    purpleRect() {
      startTime = millis();
      interTime = 1000;
      endTime = 6000;
    }

    void update() {
      pushStyle();
      noStroke();
      fill (255, 0, 255);
      if (millis() <= startTime + endTime) {
        float currentTime = map (millis(), startTime, startTime + interTime, 0, -tubeLength/2);
        rect(800, 0, currentTime, rectHeight);
      }
      popStyle();
    }
  }

  class sinRect {

    int rectHeight;

    int startTime;
    int interTime;
    int endTime;

    float sinLength;
    float a;

    sinRect() {

      startTime = millis();
      interTime = 2000;
      endTime = 4000;
    }

    void update() {
      pushStyle();
      noStroke();
      a = map(millis(), 0, 1000, 0, PI/2);
      sinLength = 150*sin(a);

      if (sinLength <= 0) {
        fill(255, 0, 255);
      } else if (sinLength >= 0) {
        fill(0, 0, 255);
      }

      rect(tubeLength/2, 0, sinLength, rectHeight);
      popStyle();
    }
  }

  class whiteRect {
    int startTime;
    int interTime;
    int endTime;

    int rectHeight;
    float sinLength;

    float x;
    float x2;

    whiteRect() {

      rectHeight = 70;

      startTime = millis();
      interTime = 2000;
      endTime = 4000;
    }

    void update () {
      pushStyle();
      noStroke();
      fill(255);

      x = map(millis()-startTime, 4000, 6000, 0, 20);
      x2 = sq(x);

      rect(tubeLength/2, 0, x2, rectHeight);
      rect(tubeLength/2, 0, -x2, rectHeight);
      popStyle();
    }
  }
}