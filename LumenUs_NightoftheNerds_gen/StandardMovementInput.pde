class StandardMovementInput {
  float x_input;
  float width_input;
  int speed_input;
  int begin_input = 1;
  int end_input = 0;
  int inputAnimationTime = 3000;
  int startTime;

  boolean isFull = false;

  void update() {
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
    }
  }
}