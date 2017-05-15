// utility functions like drawRaster and showFrameRate

void drawRaster() {
  pushStyle();
  noFill();
  stroke(0, 102, 153);

  pushMatrix();
  translate(20, 21);  

  for (int j = 0; j < numTripods; j ++) {
    for (int i = 0; i < numLEDsPerTube; i ++) {
      rect(x, y, rectWidth, rectHeight);
      x += rectWidth;
    }

    x += 20;

    for (int i = 0; i < numLEDsPerTube; i ++) {
      rect(x, y, rectWidth, rectHeight);
      x += rectWidth;
    }

    x += 20;

    for (int i = 0; i < numLEDsPerTube; i ++) {
      rect(x, y, rectWidth, rectHeight);
      x += rectWidth;
    }
    x = 0;
    y += 21;
  }

  x = 0;
  y = 0;
  popMatrix();
  popStyle();
}

void ShowFrameRate() {
  pushStyle();
  fill(200);
  text(int(frameRate) + " " + currentSelectedTube + " " + currentSelectedTripod, 5, 16);
  popStyle();
}

int currentSelectedTube = 0;
int currentSelectedTripod = 0;

void selectingSystem() {
  //Keep selecting system within raster
  if (currentSelectedTube < 0) {
    currentSelectedTube = 0;
  }
  if (currentSelectedTube > 2) {
    currentSelectedTube = 2;
  }
  if (currentSelectedTripod < 0) {
    currentSelectedTripod = 0;
  }
  if (currentSelectedTripod >= numTripods) {
    currentSelectedTripod = numTripods - 1;
  }

  //Create rectangle for indicating which tube / tripod is selected
  pushMatrix();
  translate(currentSelectedTube * (numLEDsPerTube * rectWidth) + (currentSelectedTube * 20 + 20), currentSelectedTripod * 21 + 21); 

  pushStyle();
  noFill();

  stroke(0, 255, 0);
  rect(x-5, y-5, tubeLength+8, rectHeight+9);

  popStyle();
  popMatrix();
}

void addButtons() {

  cp5 = new ControlP5(this);

  cp5.addBang("startTimerELM")
    .setPosition(100, height-150)
    .setSize(450, 50);
}

void startTimerELM() {
  startTimeTimer = millis();
  startTimer = true;

  for (int i = 0; i < rainboweffectinstallation.size(); i++) {
    RainBowEffectCompleteInstallation effectsCompleteInstallation = rainboweffectinstallation.get(i); 

    effectsCompleteInstallation.doFadeOut();
  }
}

int startTimeTimer;
boolean startTimer = false;

//14.5 minutes 

int durationTimer = 120000;

int minutes = 0;

void timerELM() {
  if (startTimer) {
    if (millis() < startTimeTimer + 2000) {

      float currentTime = map(millis(), startTimeTimer, startTimeTimer + 2000, 0, 1);
      float interValue = AULib.ease(AULib.EASE_IN_OUT_CUBIC, currentTime);

      float opacity = int(map(interValue, 0, 1, 255, 0));

      pushStyle();
      fill(0, 0, 0, opacity);
      rect(0, 0, width, height/3);
      popStyle();
    }

    String timerToDisplay;

    int currentSeconds = ((millis() - startTimeTimer) / 1000)-(60*minutes);

    if (currentSeconds == 60) {
      minutes ++;
    }

    timerToDisplay = minutes + " : " + currentSeconds;

    pushStyle();
    fill(255);
    textSize(18);
    text("Current time timer: " + timerToDisplay, 100, height-200);
    popStyle();

    if (millis() - startTimeTimer > durationTimer - 10000 - 1000 - 1000) {

      float currentTime = map(millis(), startTimeTimer + durationTimer - 10000 - 1000 - 1000, startTimeTimer + durationTimer - 10000 - 1000, 0, 1);
      float interValue = AULib.ease(AULib.EASE_IN_OUT_CUBIC, currentTime);

      float opacity = int(map(interValue, 0, 1, 0, 255));

      pushStyle();
      fill(0, 0, 0, opacity);
      rect(0, 0, width, height/3);
      popStyle();

      if (opacity >= 255) {
        rainboweffectinstallation.add(new RainBowEffectCompleteInstallation(0));
        startTimer = false;
      }
    }
  } else {
    minutes = 0;
    pushStyle();
    fill(0, 0, 0, 255);
    rect(0, 0, width, height/3);
    popStyle();
  }
}