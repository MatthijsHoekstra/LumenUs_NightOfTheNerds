/* The Lighteffect class is the mediator of the entire code
 lighteffect.update is the only function that is CONSTANTLY running
 .update checks the tubes that are active, decides what light-effect they should show and exectues the corrosponding functions
 */

//import toxi.util.events.*;

class Tube {
  private int tubeNumber;
  private int tubeModulus;
  private int tripodNumber;
  private int startTime;

  float x_input;
  float width_input;
  int speed_input;
  int begin_input = 0;
  int end_input = 1;
  int inputAnimationTime = 3000;
  boolean isFull = false;
  boolean isSynchronously = true;

  ArrayList<Block> blocks = new ArrayList<Block>();
  ArrayList<GlitterEffect> glittereffect = new ArrayList<GlitterEffect>();
  ArrayList<DBZ> dbz = new ArrayList<DBZ>();

  boolean effectSide0 = false;
  boolean effectSide1 = false;

  Tube(int tubeNumber) {
    this.tubeNumber = tubeNumber; //0 - numTubes
    this.tubeModulus = tubeNumber % 3; // 0, 1, 2
    this.tripodNumber = tubeNumber / 3; //0 - numTubes / 3

    startTime = millis();
    speed_input = inputAnimationTime;
  }

  void isTouched(int touchLocation) {
    if (touchLocation == 0) {
      effectSide0 = true;
    }
    if (touchLocation == 1) {
      effectSide1 = true;
    }
  }

  //Event when tube is touched

  void isUnTouched(int touchLocation) {
    if (touchLocation == 0) {
      effectSide0 = false;
    }
    if (touchLocation == 1) {
      effectSide1 = false;
    }
  }


  // Executed every frame, for updating continiously things
  void update() {
    input_update();

    for (int i = glittereffect.size() - 1; i >= 0; i--) {
      GlitterEffect glitterEffect = glittereffect.get(i);

      glitterEffect.update();


      if (!glitterEffect.timeFinished()) {
        glitterEffect.generate();
      }

      if (glitterEffect.animationFinished()) {
        glittereffect.remove(i);

        //effectSide0 = false;
        //effectSide1 = false;
      }
    }

    for (int i = dbz.size() - 1; i >= 0; i--) {
      DBZ dbzs = dbz.get(i);

      dbzs.update();
    }
  }

  void summon(String Effect) {

    int effectNumberRandom = -1;
    boolean randomEffectChosen = false;

    if (Effect.equals("random") == true) {
      effectNumberRandom = AULib.chooseOneWeighted(effectNumberArray, EffectsWeights);
      randomEffectChosen = true;

      println("random effect: " + EffectsAvailable[effectNumberRandom] + " chosen");
    }

    // The number of effectNumberRandom is the number of the position of the effect in the array effectsAvailable
    if ((effectNumberRandom == 0) || (!randomEffectChosen && Effect.equals("glitter"))) {
      println("GlitterEffect summoned");
      glittereffect.add(new GlitterEffect(this.tripodNumber, this.tubeModulus));

      //To indicate that something is running in tube, we don't want to effects overlying eachother, set to false when removing effect
      //effectSide0 = true;
      //effectSide1 = true;
    }

  }

  void input_update() {
    float intervalue2 = map(speed_input, inputAnimationTime, 0, 0, 1);
    float intervalue3 = AULib.ease(AULib.EASE_IN_CUBIC, intervalue2);
    width_input = map(intervalue3, 0, 1, rectWidth*4, tubeLength);

    float currentTime = map(millis(), startTime, startTime + speed_input, begin_input, end_input);
    float intervalue1 = AULib.ease(AULib.EASE_IN_OUT_CUBIC, currentTime);
    x_input = map(intervalue1, 0, 1, 0, tubeLength-width_input/4);

    if (intervalue1 >= 1) {
      startTime = millis();
      begin_input = 1;
      end_input = 0;
    }

    if (intervalue1 <= 0) {
      startTime = millis();
      begin_input = 0;
      end_input = 1;
    }

    if (speed_input <= 0) {
      speed_input = inputAnimationTime;
      isFull = true;
    } else if ((effectSide0 == false && effectSide1 == false) && (speed_input < inputAnimationTime+40) && isSynchronously==false) {
      speed_input+= 10;
    } else if ((effectSide0 == false && effectSide1 == false) && speed_input >= inputAnimationTime + 40 && isSynchronously==false) {
      if (x_input <= standardMovementInput.x_input+1 && x_input >= standardMovementInput.x_input) {
        speed_input = inputAnimationTime;
        x_input = standardMovementInput.x_input;
        isSynchronously = true;
      }
    }

    if (effectSide0 == true || effectSide1 == true) {
      speed_input -= 20 ;
      isSynchronously = false;
    }

    pushMatrix();
    translate(this.tubeModulus * (numLEDsPerTube * rectWidth) + (this.tubeModulus * 20 + 20), this.tripodNumber * 21 + 21);
    pushStyle();

    fill(255);
    rect(x_input, 0, width_input/4, rectHeight);

    if (isFull == true) {
      fill(255);
      rect(0, 0, tubeLength, rectHeight);
      summon("random");
      isFull = false;
    }

    popStyle();
    popMatrix();
  }
}