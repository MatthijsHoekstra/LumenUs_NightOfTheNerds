color[] colorArray = {#ff0000, #ff2700, #c46606, #21ff00, #00fffa, #0000ff, #fa00ff};

class RainBowEffectCompleteInstallation {

  private int durationAnimation, startAnimation;

  private int lengthOneRect = (tubeLength*4)/colorArray.length;

  private int totalLengthRect;
  private int currentLengthRect;

  private color rectColor;

  boolean finishedEffect = false;
  boolean eventPassed = false;
  boolean fadeOut = false;

  int opacity = 255;
  int startFadeOut;

  int id;

  RainBowEffectCompleteInstallation(int id) {

    this.id = id;

    startAnimation = millis();

    rectColor = colorArray[this.id];

    durationAnimation = 15000 / colorArray.length;

    totalLengthRect = (tubeLength*4) - (this.id*lengthOneRect);

    //println(totalLengthRect);
  }

  void display() {
    int tubeModulus = 0;
    int tripodNumber = 0;

    float currentTime = map(millis(), startAnimation, startAnimation + durationAnimation, 0, 1);
    float interValue = AULib.ease(AULib.EASE_IN_OUT_CUBIC, currentTime);

    currentLengthRect = int(map(interValue, 0, 1, 0, totalLengthRect));
    //println(currentLengthRect);

    for (int i = 0; i < 3; i++) {
      if (i > 0) {
        tubeModulus++;
      }
      pushMatrix();
      pushStyle();
      translate(tubeModulus * (numLEDsPerTube * rectWidth) + (tubeModulus * 20 + 20), tripodNumber * 21 + 21);

      fill(rectColor, opacity);
      rect(0, 0, constrain(currentLengthRect, 0, tubeLength), rectHeight);

      popStyle();
      popMatrix();
    }

    tubeModulus = 0;


    if (currentLengthRect >= tubeLength) {
      // println("running 2");
      tripodNumber++;

      for (int i = 0; i < 3; i++) {
        if (i > 0) {
          tubeModulus++;
        }

        //println(tubeModulus);

        pushMatrix();
        pushStyle();
        translate(tubeModulus * (numLEDsPerTube * rectWidth) + (tubeModulus * 20 + 20), tripodNumber * 21 + 21);

        fill(rectColor, opacity);
        rect(0, 0, constrain(currentLengthRect - (tubeLength*1), 0, tubeLength), rectHeight);

        popStyle();
        popMatrix();
      }

      tubeModulus = 0;
    }

    if (currentLengthRect >= tubeLength*2) {
      tripodNumber++;   

      for (int i = 0; i < 3; i++) {
        if (i > 0) {
          tubeModulus++;
        }
        // println("running 3");


        pushMatrix();
        pushStyle();
        translate(tubeModulus * (numLEDsPerTube * rectWidth) + (tubeModulus * 20 + 20), tripodNumber * 21 + 21);

        fill(rectColor, opacity);
        rect(0, 0, constrain(currentLengthRect - (tubeLength*2), 0, tubeLength), rectHeight);

        popStyle();
        popMatrix();
      }
      tubeModulus = 0;
    }

    if (currentLengthRect >= tubeLength*2) {
      tripodNumber++;  
      for (int i = 0; i < 3; i++) {
        if (i > 0) {
          tubeModulus++;
        }
        //println("running 4");


        pushMatrix();
        pushStyle();
        translate(tubeModulus * (numLEDsPerTube * rectWidth) + (tubeModulus * 20 + 20), tripodNumber * 21 + 21);

        fill(rectColor, opacity);
        rect(0, 0, constrain(currentLengthRect - (tubeLength*3), 0, tubeLength), rectHeight);

        popStyle();
        popMatrix();
      }
      tubeModulus = 0;
    }

    if (currentLengthRect >= totalLengthRect - ((colorArray.length*75)-(this.id*50)) && !eventPassed) {
      println("effectFinished rainbowcompleteinstallation" + id);
      finishedEffect = true;
    }
  }

  boolean finished() {
    float currentTime = map(millis(), startTimeTimer, startTimeTimer + 2000, 0, 1);
    float interValue = AULib.ease(AULib.EASE_IN_OUT_CUBIC, currentTime);

    opacity = int(map(interValue, 0, 1, 255, 0));

    if (opacity <= 0) {
      return true;
    } else {
      return false;
    }
  }

  void doFadeOut() {
    startFadeOut = millis();
    fadeOut = true;
  }
}