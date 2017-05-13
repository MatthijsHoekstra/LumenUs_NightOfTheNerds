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

  }

  //Event when tube is released

  void isUnTouched(int touchLocation) {

  }

  // Executed every frame, for updating continiously things
  void update() {
    for (int i = glittereffect.size() - 1; i >= 0; i--) {
      GlitterEffect glitterEffect = glittereffect.get(i);

      glitterEffect.update();

      if (!glitterEffect.timeFinished()) {
        glitterEffect.generate();
      }

      if (glitterEffect.animationFinished()) {
        glittereffect.remove(i);
        
        effectSide0 = false;
        effectSide1 = false;
      }
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
      effectSide0 = true;
      effectSide1 = true;
    }
  }
}