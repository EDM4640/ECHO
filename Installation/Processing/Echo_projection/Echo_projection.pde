import netP5.*;
import oscP5.*;

import processing.pdf.*;

// Audrey Lamoureux
// Giacomo Ferron
// Hugo Déziel
// Samuel Nadeau
//
// Syntaxe Processing version 3.2.1
// Mercredi 19 Octobre 2016


// E C H O
//
// Une exploration sur 
// les relations interpersonnelles.


/*====== Variables globales ===========================================*/

  //Visuels
  int backgroundColor = 0;
  int historiqueHeight = 580;
  
  int lightR = 0;
  int lightG = 0;
  int lightB = 255;
  
  //Segments
  int nombreSegmentHorizontal = 5;
  int nombreHistorique = 60;
  float segmentWidth, segmentHeight;
  int[][] historique;
  
  //Interaction
  float vitesseAugmentationLumiere = 6;
  float vitesseDiminutionLumiere = 1;
  
  //Functionnality
  boolean pdfCapture = false;
  
  //OSC
  OscP5 oscP5;
  NetAddress remoteOSCtarget;
  float oscValue = 0;
  
/*========== INITIALISATION ========================================*/

  void setup(){
    
    //Initialisation de la scène
    size(550, 650);
    background(backgroundColor);
    
    //Initialise l'historique
    historique = new int[nombreHistorique][nombreSegmentHorizontal];
    
    for(int indexHistorique = 0; indexHistorique < historique.length; indexHistorique++)
    {
      for(int indexSegment = 0; indexSegment < historique[indexHistorique].length; indexSegment++)
      {
        historique[indexHistorique][indexSegment] = 1;
      }
    }
    
    segmentWidth = (width/nombreSegmentHorizontal);
    segmentHeight = (historiqueHeight/nombreHistorique);
    
    //Setting OSC
    //oscP5 = new OscP5(this, 5555); //Listening for incoming messages
  }


/*========== INTERFRAME ============================================*/

  void draw(){
   
    //Screenshot of the current frame 
    if(pdfCapture)
    beginRecord(PDF, "Screenshots/Waves_####.pdf"); 
    
    background(backgroundColor);
    
    if(millis()%30 == 1)
    interactionSimulation();
    
    dectectionTemporaire();
    drawHistorique();

    if(pdfCapture)
    {
      endRecord();
      pdfCapture = false;
    }
  }
  
  void drawHistorique()
  {
    for(int indexHistorique = 0; indexHistorique < historique.length; indexHistorique++)
    {
      for(int indexSegment = 0; indexSegment < historique[indexHistorique].length; indexSegment++)
      {
          noStroke();
          
          color c = color(lightR, lightG, lightB, historique[indexHistorique][indexSegment]);
          fill(c);
          rect(indexSegment*(segmentWidth), indexHistorique*(segmentHeight), segmentWidth, segmentHeight);
      }
    }
  }
  
  void dectectionTemporaire()
  {
      //Mets à jour le dernier historique du tableau
      /*for(int indexSegment = 0; indexSegment < historique[historique.length-1].length; indexSegment++)
      {
          float posXsegment = indexSegment*(segmentWidth);
          
          //Augmentation de la luminosité
          if((mouseX > posXsegment) && (mouseX < (posXsegment+segmentWidth)))
          {
              if(historique[historique.length-1][indexSegment] < 255)
                historique[historique.length-1][indexSegment] += vitesseAugmentationLumiere;
              if(historique[historique.length-1][indexSegment] > 255)
                historique[historique.length-1][indexSegment] = 255;
          }
          //Diminution de la luminosité
          else{
              if(historique[historique.length-1][indexSegment] > 1)
                historique[historique.length-1][indexSegment] -= vitesseDiminutionLumiere;
              if(historique[historique.length-1][indexSegment] < 1)
                historique[historique.length-1][indexSegment] = 1;
          }
      }*/
      
      //Déplace les historiques vers le haut
      for(int indexHistorique = 0; indexHistorique < historique.length; indexHistorique++)
      {
        for(int indexSegment2 = 0; indexSegment2 < historique[indexHistorique].length; indexSegment2++)
        {
            if((indexHistorique+1) < historique.length)
            historique[indexHistorique][indexSegment2] = historique[indexHistorique+1][indexSegment2];
        }
      }
  }
  
  void interactionSimulation()
  {
    historique[historique.length-1][0] = (int)random(1,255);
    historique[historique.length-1][1] = (int)random(1,255);
    historique[historique.length-1][2] = (int)random(1,255);
    historique[historique.length-1][3] = (int)random(1,255);
    historique[historique.length-1][4] = (int)random(1,255);
  }

/*========== ÉVÉNEMENT / INTERACTION ==================================*/

  void oscEvent(OscMessage theOscMessage)
  {
    //Incoming OSC message
    /* Print the address pattern and the typetag of the received OscMessage */
    print("### received an osc message.");
    println(" addrpattern: "+theOscMessage.addrPattern());
    
    
    String messageOSC = theOscMessage.addrPattern();
    String[] userIDinfos = split(messageOSC, '/');
 
    historique[historique.length-1][0] = int(userIDinfos[1]);
    historique[historique.length-1][1] = int(userIDinfos[2]);
    historique[historique.length-1][2] = int(userIDinfos[3]);
    historique[historique.length-1][3] = int(userIDinfos[4]);
    historique[historique.length-1][4] = int(userIDinfos[5]);
  }
  
  void keyPressed()
  {
    //Pressing space bar
    if(key == 32)
      pdfCapture = true;
  }