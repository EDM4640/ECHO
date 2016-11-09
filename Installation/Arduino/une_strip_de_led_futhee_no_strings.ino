
#include <Adafruit_NeoPixel.h>
#include <Messenger.h>
#ifdef __AVR__
#include <avr/power.h>
#endif

#define PIN            6

#define NUMPIXELS      60
Messenger messenger = Messenger();


Adafruit_NeoPixel pixels = Adafruit_NeoPixel(NUMPIXELS, PIN, NEO_GRB + NEO_KHZ800);
int valeur1;
int valeur2;
int valeur3;
int valeur4;
int valeur5;

int incomingByte = 0;   // for incoming serial data

void setup() {

  pixels.begin();
  Serial.begin(57600);
 messenger.attach(messageReceived); 
}

void messageReceived() {

 //Serial.println("test Message received");

if(messenger.checkString("leap")){
  valeur1 =  messenger.readInt();;
   valeur2 =  messenger.readInt();;
    valeur3 =  messenger.readInt();;
     valeur4 =  messenger.readInt();;
      valeur5 =  messenger.readInt();;
}

}
void loop() {


//========================================================================//
  // send data only when you receive data:
  while (Serial.available() > 0) {
    // read the incoming byte:
     messenger.process( Serial.read( ) ); // FOURNIR LES DONNEES SERIES RECUES A L'INSTANCE DE Messenger
  }
//========================================================================//


  //section 1
  for (int i = 0; i < 12; i++) {

    pixels.setPixelColor(i, pixels.Color(0, 0, valeur1));

    //pixels.show(); // This sends the updated pixel color to the hardware.

  } //fin section 1

  //====================================================================================//

  //section 2
  for (int i = 12; i < 24; i++) {

    pixels.setPixelColor(i, pixels.Color(0, 0, valeur2));

    //pixels.show();

  }
  //====================================================================================//

  //section 3
  for (int i = 24; i < 36; i++) {

    pixels.setPixelColor(i, pixels.Color(0, 0, valeur3));

    //pixels.show();

  }
  //====================================================================================//

  //section 4
  for (int i = 36; i < 48; i++) {

    pixels.setPixelColor(i, pixels.Color(0, 0, valeur4));


    //pixels.show();

  }
  //====================================================================================//

  //section 5
  for (int i = 48; i < 60; i++) {

    pixels.setPixelColor(i, pixels.Color(0, 0, valeur5));

   

  }

 pixels.show();


} // fin du loop()



