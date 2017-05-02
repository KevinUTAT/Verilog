/********************************************************************************
* ADXL345 Library Examples- pitch_roll.ino                                      *
*                                                                               *
* Copyright (C) 2012 Anil Motilal Mahtani Mirchandani(anil.mmm@gmail.com)       *
*                                                                               *
* License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html> *
* This is free software: you are free to change and redistribute it.            *
* There is NO WARRANTY, to the extent permitted by law.                         *
*                                                                               *
*********************************************************************************/

#include <Wire.h>
#include <ADXL345.h>
#include <Servo.h>

const float alpha = 0.5;

double fXg = 0;
double fYg = 0;
double fZg = 0;

ADXL345 acc;
Servo Myservo0;
Servo Myservo1;

void setup()
{
	acc.begin();
	Serial.begin(9600);
	delay(100);
	
	Myservo0.attach(9, 1000, 2800);
	Myservo1.attach(10, 1000, 2800);
}


void loop()
{
	double Xg, Yg, Zg;
	int roll, pitch, p, r;
	
	acc.read(&Xg, &Yg, &Zg);

	//Low Pass Filter
	fXg = Xg * alpha + (fXg * (1.0 - alpha));
	fYg = Yg * alpha + (fYg * (1.0 - alpha));
	fZg = Zg * alpha + (fZg * (1.0 - alpha));

	//Roll & Pitch Equations
	roll  = (atan2(-fYg, fZg)*180.0)/M_PI;
	pitch = (atan2(fXg, sqrt(fYg*fYg + fZg*fZg))*180.0)/M_PI;

	Serial.print(pitch);
	Serial.print(":");
	Serial.println(roll);
	
	p = map(pitch, -180, 180, 0, 180);
	r = map(roll, -90, 90, 0, 180);
	
	Myservo0.write(p);
	Myservo1.write(r);

	delay(250);
}
