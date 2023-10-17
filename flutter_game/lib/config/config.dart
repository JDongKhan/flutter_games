import 'package:flame/game.dart';

class Config {
  ///显示外边框
  static const bool showOutline = true;
}

Vector2 cornerBumpDistance(Vector2 directionVector, Vector2 pointA, Vector2 pointB) {
  var dX = pointA.x - pointB.x;
  var dY = pointA.y - pointB.y;
  // The order of the two intersection points differs per corner
  // The following if statements negates the necessary values to make the
  // player move back to the right position
  if (directionVector.x > 0 && directionVector.y < 0) {
    // Top right corner
    dX = -dX;
  } else if (directionVector.x > 0 && directionVector.y > 0) {
    // Bottom right corner
    dX = -dX;
  } else if (directionVector.x < 0 && directionVector.y > 0) {
    // Bottom left corner
    dY = -dY;
  } else if (directionVector.x < 0 && directionVector.y < 0) {
    // Top left corner
    dY = -dY;
  }
  // The absolute smallest of both values determines from which side the player bumps
  // and therefor determines the needed displacement
  if (dX.abs() < dY.abs()) {
    return Vector2(dX, 0);
  } else {
    return Vector2(0, dY);
  }
}
