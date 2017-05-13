/* The Lighteffect class is the mediator of the entire code
 lighteffect.update is the only function that is CONSTANTLY running
 .update checks the tubes that are active, decides what light-effect they should show and exectues the corrosponding functions
 */

//import toxi.util.events.*;

class Tube {
  private int tubeNumber;
  private int tubeModulus;
  private int tripodNumber;

  ArrayList<Block> blocks = new ArrayList<Block>();
  ArrayList<GlitterEffect> glittereffect = new ArrayList<GlitterEffect>();

  boolean effectSide0 = false;
  boolean effectSide1 = false;

  Tube(int tubeNumber) {
    this.tubeNumber = tubeNumber; //0 - numTubes
    this.tubeModulus = tubeNumber % 3; // 0, 1, 2
    this.tripodNumber = tubeNumber / 3; //0 - numTubes / 3
  }

  //Event when tube is touched

  void isTouched(int touchLocation) {
    if (touchLocation == 0 && effectSide0 == false) {
      blocks.add(new Block(tubeModulus, tripodNumber, 0));

      effectSide0 = true;
    }

    if (touchLocation == 1 && effectSide1 == false) {
      blocks.add(new Block(tubeModulus, tripodNumber, 1));

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

    for (int i = 0; i < blocks.size(); i++) {
      Block block = blocks.get(i);

      block.display();
    }
  }

  void summon(String Effect) {
    
    int effectNumberRandom = -1;
    boolean randomEffectChosen = false;

    if (Effect.equals("random") == true) {
      effectNumberRandom = AULib.chooseOneWeighted(effectNumberArray,  EffectsWeights);
      randomEffectChosen = true;
      
      println("random effect: " + EffectsAvailable[effectNumberRandom] + " chosen");
    }
    
    if ((Effect.equals(EffectsAvailable[effectNumberRandom]) == true) || (!randomEffectChosen && Effect.equals("glitter"))){
      glittereffect.add(new GlitterEffect(this.tripodNumber, this.tubeModulus));
    }
  }
}