% theta is rotate from North to East according to 3GPP (in rad)
function new = CoordinatesRotation(old, theta)
rotationMatrix = [sin(theta) -cos(theta);cos(theta) sin(theta)];
new = old *rotationMatrix;