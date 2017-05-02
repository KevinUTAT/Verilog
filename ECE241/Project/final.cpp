#include <FreeSixIMU.h>
#include <FIMU_ADXL345.h>
#include <FIMU_ITG3200.h>

#include <Wire.h>
#include <Servo.h>

Servo sevP;
Servo sevY;

float angles[3]; // yaw pitch roll

// Set the FreeSixIMU object
FreeSixIMU sixDOF = FreeSixIMU();

void setup() { 
  Serial.begin(9600);
  Wire.begin();
  
  delay(5);
  sixDOF.init(); //begin the IMU
  delay(5);

  sevP.attach(6);
  sevY.attach(10, 584, 2400);
}

void loop() {

  int int_angles[3];
  int Pout, Yout;
  
  sixDOF.getEuler(angles);
  
  for (int i = 0; i < 3; i ++) {
    int_angles[i] = (int) angles[i];
  }
  
  Pout = map(int_angles[1], -40, 40, 0, 180);
  Yout = map(int_angles[0], -70, 70, 0, 180);
  
  sevP.write(Yout);
  sevY.write(Pout);
  
  Serial.print(Yout);
  Serial.print(" | ");
  Serial.print(Pout);
  Serial.print(" | ");
  Serial.println(int_angles[2]); 
  
  delay(50); 
}

