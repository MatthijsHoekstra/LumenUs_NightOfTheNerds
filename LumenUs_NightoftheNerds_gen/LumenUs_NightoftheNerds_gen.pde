import AULib.*;
import spout.*;
import controlP5.*;


// ----------

String[] EffectsAvailable = {"Glitter"};
float[] EffectsWeights =    {5, 1};

int numberEffectsAvailable = EffectsAvailable.length;

int[] effectNumberArray = new int[EffectsAvailable.length];

ArrayList<RainBowEffectCompleteInstallation> rainboweffectinstallation = new ArrayList<RainBowEffectCompleteInstallation>();

// ----------



int numTripods = 4;
int numTubes = numTripods * 3;
int numLEDsPerTube = 56;

int rectWidth = 9;
int rectHeight = 8;
int tubeLength = rectWidth * numLEDsPerTube;

int x;
int y;

int selectedTube, tubeNumber;

Tube[] tubes = new Tube[numTubes];

StandardMovementInput standardMovementInput = new StandardMovementInput();

Spout spout;

ControlP5 cp5;

void setup() {
  size(1600, 300, OPENGL);

  frameRate(60);
  background(0);
  noStroke();
  noSmooth();

  for (int i=0; i< numTubes; i++) {
    tubes[i] = new Tube(i);
  }

  //drawRaster(); // drawRaster helps us with the LED mapping in ELM

  // Setup MQTT

  client = new MQTTClient(this);
  client.connect("mqtt://10.0.0.1", "processing");
  //client.subscribe("tripods/" + 0 + "/tube/" + 0 + "/side/" + 0);

  for (int i = 0; i < numTripods; i++) {
    for (int j = 0; j < 3; j++) {
      for (int k = 0; k < 2; k++) {
        //println(
        client.subscribe("tripods/" + i + "/tube/" + j + "/side/" + k);
      }
    }
  }
  
  client.unsubscribe("tripods/1/tube/0/side/0");

  spout = new Spout(this);

  addButtons();

  //Get array of numbers of Effects
  for (int i = 0; i < numberEffectsAvailable; i++) {
    effectNumberArray[i] = i;
  }
}

void draw() {

  background(0);

  for (int i=0; i<numTubes; i++) {
    tubes[i].update();
  }

  ShowFrameRate();

  selectingSystem();

  //drawRaster();

  timerELM();

  for (int i = 0; i < rainboweffectinstallation.size(); i++) {
    RainBowEffectCompleteInstallation effectsCompleteInstallation = rainboweffectinstallation.get(i);  

    effectsCompleteInstallation.display();

    if (effectsCompleteInstallation.finishedEffect && !effectsCompleteInstallation.eventPassed) {      

      effectsCompleteInstallation.eventPassed = true;

      if (effectsCompleteInstallation.id < colorArray.length - 1) {
        rainboweffectinstallation.add(new RainBowEffectCompleteInstallation(effectsCompleteInstallation.id+1));
      }
    }

    if (effectsCompleteInstallation.fadeOut) {
      if (effectsCompleteInstallation.finished()) {
        rainboweffectinstallation.remove(i);
      }
    }
  }

  spout.sendTexture();

  standardMovementInput.update();
}

void keyPressed() {

  int tubeNumber = currentSelectedTube + currentSelectedTripod * 3; 

  //Selecting system for adding objects
  if (key == CODED) {
    if (keyCode == LEFT) {
      currentSelectedTube --;
    }
    if (keyCode == RIGHT) {
      currentSelectedTube ++;
    }
    if (keyCode == UP) {
      currentSelectedTripod --;
    }
    if (keyCode == DOWN) {
      currentSelectedTripod ++;
    }
  }

  if (key == '9') {
    for (int i=0; i<numTubes; i++) {
      tubes[i].isTouched(0); 
      tubes[i].isTouched(1);
    }
  }

  if (key == '0') {
    for (int i=0; i<numTubes; i++) {
      tubes[i].isUnTouched(0); 
      tubes[i].isUnTouched(1);
    }
  }

  if (key == '1') {
    tubes[tubeNumber].isTouched(0);
  }

  if (key == '2') {
    tubes[tubeNumber].isTouched(1);
  }

  if (key == 'q') {
    tubes[tubeNumber].summon("random");
  }

  if (key == 'w') {
    rainboweffectinstallation.add(new RainBowEffectCompleteInstallation(0));
  }
}

//Simulating the sensor input 0 - released

void keyReleased() {
  int tubeNumber = currentSelectedTube + currentSelectedTripod * 3; 

  if (key == '1') {
    tubes[tubeNumber].isUnTouched(0);
  }

  if (key == '2') {
    tubes[tubeNumber].isUnTouched(1);
  }
}