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
  int speed_input = 2000;
  int begin_input = 0;
  int end_input = 1;

  ArrayList<Block> blocks = new ArrayList<Block>();

  boolean effectSide0 = false;
  boolean effectSide1 = false;

  Tube(int tubeNumber) {
    this.tubeNumber = tubeNumber; //0 - numTubes
    this.tubeModulus = tubeNumber % 3; // 0, 1, 2
    this.tripodNumber = tubeNumber / 3; //0 - numTubes / 3

    startTime = millis();
  }

  //Event when tube is touched

  void isTouched(int touchLocation) {
    if (touchLocation == 0 && effectSide0 == false) {
      //blocks.add(new Block(tubeModulus, tripodNumber, 0));

      effectSide0 = true;
    }

    if (touchLocation == 1 && effectSide1 == false) {
      //blocks.add(new Block(tubeModulus, tripodNumber, 1));

      effectSide1 = true;
    }
  }

  //Event when tube is released

  void isUnTouched(int touchLocation) {
    for (int i = 0; i < blocks.size(); i++) {
      Block block = blocks.get(i);

      if (block.touchLocation == touchLocation) {
        blocks.remove(i);

        if (touchLocation == 0) {
          effectSide0 = false;
        }
        if (touchLocation == 1) {
          effectSide1 = false;
        }
      }
    }
  }

  // Executed every frame, for updating continiously things
  void update() {

    input_update();

    for (int i = 0; i < blocks.size(); i++) {
      Block block = blocks.get(i);

      block.display();
    }
  }

  void input_update() {
    float intervalue2 = map(speed_input, 2000, 0, 0, 1);
    float intervalue3 = AULib.ease(AULib.EASE_IN_CUBIC, intervalue2);
    width_input = map(intervalue3, 0, 1, rectWidth, tubeLength);

    float currentTime = map(millis(), startTime, startTime + speed_input, begin_input, end_input);
    float intervalue1 = AULib.ease(AULib.EASE_IN_OUT_CUBIC, currentTime);
    x_input = map(intervalue1, 0, 1, 0, tubeLength-width_input);

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

    if (effectSide0 == true || effectSide1 == true) {
      speed_input -= 10;
    }

    if (speed_input <= 0) {
      speed_input = 0;
    }

    pushMatrix();
    translate(this.tubeModulus * (numLEDsPerTube * rectWidth) + (this.tubeModulus * 20 + 20), this.tripodNumber * 21 + 21);
    pushStyle();

    fill(255);
    rect(x_input, 0, width_input, rectHeight);

    popStyle();
    popMatrix();
  }
}