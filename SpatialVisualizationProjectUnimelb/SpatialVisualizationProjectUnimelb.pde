// Library which enables translating Longitude and Latitude co-ordinates from WebMercator to screen 
import org.gicentre.utils.spatial.*;

// -----------------Global Variables-------------------------
// Tables: declaring MainTable from CSV datasets of GPS, Model_output and Habitat 
Table GPS;
Table Model_output;
Table Habitat;
Table MainTable;

// Map
// Background png image of Schiermonnikoog, Top Left and Bottom Right Co-ordinates 
PImage backgroundMap;        
PVector tlCorner,brCorner;   
WebMercator proj;         

// The Netherlands map
PImage nethermap;

// Icons
PImage off, on; // switches
PImage up, down; // up and down buttons for days

PImage birds, seasons, day, time, activities; // Icons next to titles on sidebars

PImage bird1, bodycare, fly, forage, sit, stand; //bird icons facing right
PImage bird2, bodycare2, fly2, forage2, sit2, stand2; //bird icons facing left

PImage imgcalendar, imgsummer, imgwinter, imgtime; // Summer and Winter

// Booleans for visual switches
boolean boobirdy1 = true; 
boolean boobirdy2 = false;
boolean boosummer = true;
boolean boowinter = false;
boolean boodays = true;
boolean boonights = false;

boolean boostand = true;
boolean boosit = true;
boolean booforage = true;
boolean boobodycare = true;
boolean boofly = true;

// Setting global variables of the buttons parameters and searchable criteria to be matched with MainTable row's data
int [] bird = {166,0}; // birdID 166, 169.
Boolean season = true; // Summer, Winter.
String month = "Jul"; // 20/July and 09/August for summer, 01-21/March for winter.
int daysummer = 20; // 20-31 July to 01-09 August (3 Weeks)
int daywinter = 0; // 01-21 March. (3 Weeks)
String [] timebutton = {"Day", " "}; // Day and Night.
String [] activityButton = {"stand", "sit", "forage", "body care", "fly"};

// ------------------------------------------
void setup(){
  size(1280,850);      // Canvas data frame size
  background(255);     // Makes background of the canvas black
  noLoop();            // Prevents the continuous refresh, redrawing of the data
  readData();          // Imports all of the csv files and compliles table functions
  loadicons();         // Loads all the icons
  texts();             // The text which corresponds with the menu buttons
  keybuttons();        // Function for the frames for the activities buttons in the sidebar
  boxes();             // Function for all of frames for the buttons in the sidebar aside from activities
  colours();           // Draw the colour dots in activities buttons           
  smooth(8);           // Removes jagged edges of graphics
}
//----------------------------------------------
void draw(){
  backg();         // Draws the background map
  nether();        // Draws The Netherlands map
  bars();          // Draws the top and bottom bars
  noStroke();      // To stop the stroke occurring
  // Load on and off switches
  birdone();       // Bird 1 switch
  birdtwo();       // Bird 2 switch
  ssummer();       // Summer switch
  wwinter();       // Winter switch
  dday();          // Day switch
  nnight();        // Night switch
  sstand();        // Stand switch
  ssit();          // Sit switch
  fforage();       // Forage switch
  bbodycare();     // Body care switch
  ffly();          // Fly switch
  drawPoints();    // Draw the bird points on the map
  drawInfo();      // Draw the bottom left text
  mapdisp();       // Draw the map display text
}

void mouseClicked(){  
// For toggling switches
  // This process is repeated for every button to toggle
  // Bird 1 toggle                      
  if (mouseX > 1100 && mouseX < 1100+180 && mouseY > 50 && mouseY < 50+35){ // Set parameters of where the button can be clicked
    if((boobirdy1 == true) && (boobirdy2 == true)){                               // Allows switch to be turned off
      boobirdy1 = !boobirdy1;
    } 
    else if((boobirdy1 == false) && (boobirdy2 == true)){                         // Allows button to be turned on       
      boobirdy1 = !boobirdy1;
    }
  }                                                                         // These statements prevent both switches being turned off
  // Bird 2 toggle
  else if (mouseX > 1100 && mouseX < 1100+180 && mouseY > 95 && mouseY < 95+35){
    if((boobirdy1 == true) && (boobirdy2 == true)){  
      boobirdy2 = !boobirdy2;
    } 
    else if((boobirdy1 == true) && (boobirdy2 == false)){
      boobirdy2 = !boobirdy2;
    }
  }
  // Summer and winter toggle
  else if (mouseX > 1100 && mouseX < 1100+180 && mouseY > 175 && mouseY < 175+35){
    if (boosummer == false){  
      boosummer = !boosummer;
      boowinter = !boowinter;
    } 
  }
  else if (mouseX > 1100 && mouseX < 1100+180 && mouseY > 220 && mouseY < 220+35){
      if (boowinter == false){  
        boowinter = !boowinter;
        boosummer = !boosummer;
      }
  }
  // Day and night toggle
  else if (mouseX > 1100 && mouseX < 1100+180 && mouseY > 470 && mouseY < 470+35){
    if ((boodays == true) && (boonights == true)){
      boodays = !boodays;
    }
    else if((boodays == false) && (boonights == true)){
      boodays = !boodays;
    } 
  }
  else if (mouseX > 1100 && mouseX < 1100+180 && mouseY > 515 && mouseY < 515+35){   
    if ((boodays == true) && (boonights == true)){
      boonights = !boonights;
    }
    else if((boodays == true) && (boonights == false)){
      boonights = !boonights;
    }   
  }
  // Activities toggles
  else if (mouseX > 1100 && mouseX < 1100+180 && mouseY > 600 && mouseY < 600+35){
    if (boostand == false){  
      boostand = !boostand;  // Allows switch to be turned on
    }
    else if((boostand == true) && (boosit == false) && (booforage == false) && (boobodycare == false) && (boofly == false)){
      boostand = true; // Prevents stand from being turned off if all other activities switches are off
    }
    else{
      boostand = !boostand; // Allows switch to be turned off
    }
  }                         // This is repeated for all activities switches
  else if (mouseX > 1100 && mouseX < 1100+180 && mouseY > 645 && mouseY < 645+35){
    if (boosit == false){
      boosit = !boosit;
    }
    else if((boostand == false) && (boosit == true) && (booforage == false) && (boobodycare == false) && (boofly == false)){
      boosit = true;
    }
    else{
      boosit = !boosit;
    }
  }
  else if (mouseX > 1100 && mouseX < 1100+180 && mouseY > 690 && mouseY < 690+35){
    if (booforage == false){
      booforage = !booforage;
    }
    else if((boostand == false) && (boosit == false) && (booforage == true) && (boobodycare == false) && (boofly == false)){
      booforage = true;
    }
    else{
      booforage = !booforage;
    }
  }
  else if (mouseX > 1100 && mouseX < 1100+180 && mouseY > 735 && mouseY < 735+35){
    if (boobodycare == false){
      boobodycare = !boobodycare;
    }
    else if((boostand == false) && (boosit == false) && (booforage == false) && (boobodycare == true) && (boofly == false)){
      boobodycare = true;
    }
    else{
      boobodycare = !boobodycare;
    }
  }
  else if (mouseX > 1100 && mouseX < 1100+180 && mouseY > 780 && mouseY < 780+35){
    if (boofly == false){
      boofly = !boofly;
    }
    else if((boostand == false) && (boosit == false) && (booforage == false) && (boobodycare == false) && (boofly == true)){
      boofly = true;
    }
    else{
      boofly = !boofly;
    }
  }
  
// The following is to allow the data to be changed when the buttons are clicked  
  // Button for the Bird 1 (166). Default On.
  if(mouseX > 1100 && mouseX < 1230 && mouseY > 50 && mouseY < 85){ // Parameters corresponding to Bird 1 button
    if((bird[0] == 166) && (bird[1] == 169)){  // Stipulating that one bird must be selected at all times
      bird[0] = 0;
    } 
    else if((bird[0] == 0) && (bird[1] == 169)){ //Turning Bird 1 on if it is off
      bird[0] = 166;
    }
  }
  
  // Equal and oppositie to the Bird 1 button above
  else if(mouseX > 1100 && mouseX < 1230 && mouseY > 95 && mouseY < 130){
    if((bird[0] == 166) && (bird[1] == 169)){  
      bird[1] = 0;
    } 
    else if((bird[0] == 166) && (bird[1] == 0)){
      bird[1] = 169;
    }
  }    
      
/*Button to indicate to increase a day for either summer or winter seasons global
variables indicated by the arrow up button. Summer data is shown by default.*/
  else if(mouseX > 1153 && mouseX < 1213 && mouseY > 300 && mouseY < 360){
    if(daysummer!= 0){         // If the Summer day counter global variable does not equal zero (opposite of Winter) display Summer date.
      if (daysummer == 31){    // Condition to set the day counter to the 1st of August when clicked on the 31st of July.
        month = "Aug";         // August contains days 1-9 once it reaches 9 it cycles through to July 20 - 31. Changes to the correspondant month as well.
        daysummer = 1;
    }
    else if(daysummer == 9){   // Condition to set the day counter to the 20th of July when clicked on the 9th of August.
      month = "Jul";
      daysummer = 20;
    }
    else {
      daysummer++;            // Increase a day to the Summer days counter. 
    }      
   }
   if (daywinter != 0){      // If the Winter day counter global variable does not equal zero (opposite of Summer) display Winter date.
     if (daywinter == 20){   // Goes to the first date (1st of March) when reaches the last date (20th of March).
        daywinter = 1;
    }  
      else{
        daywinter++;         // Increase a day to the Winter days counter.
      }
    }
  }
  // Button to indicate to decrease a day for either summer or winter seasons global variables indicated by the arrow down button. Summer data is shown by default.
  else if(mouseX > 1153 && mouseX < 1213 && mouseY > 370 && mouseY < 430){
    if(daysummer!= 0){  // If the Summer day counter global variable does not equal zero (opposite of Winter) display Summer date.
      if (daysummer == 20){ // Condition to set the Summer day counter to the 9th of August when clicked on the 20th of July.
        month = "Aug";      // Changes to the correspondant month as well.
        daysummer = 9;
    }
      else if (daysummer == 1){ // Condition to set the Summer day counter to the 31st of July when clicked on the 1st of August.
        month = "Jul";          // Changes to the correspondant month as well.
        daysummer = 31;
        }
      else{
        daysummer--;            // Decrease a day to the Winter days counter.
      }
    }
    if(daywinter!= 0){          // If the Winter day counter global variable does not equal zero (opposite of Summer) display Winter date.
      if(daywinter == 1){       // Condition to set the Winter day counter to the 20th of August when clicked on the 1st of August.
        daywinter = 20;
      }
      else{
        daywinter--;             // Decrease a day to the Winter days counter.
      }
     }
    }
 
//  Button which corresponds with the changing of the seasons, this particular buttons changes the data shown correspondant to Summer. Default season is Summer.
  else if(mouseX > 1100 && mouseX < 1230 && mouseY > 175 && mouseY < 210){
      if(season == false){  // Changes to Summer season only if season global variable is false.
        season = true;       
        daysummer = 20;     // Starts on the first day of Summer day counter global variable each time.
        daywinter = 0;      // Turns off Winter day counter when Summer season is activated.
        month = "Jul";      // Loop allows all days in 'Summer' to allign with days in July and August.
      }
  }
//  Button which corresponds with the changing of the seasons, this particular buttons changes the data shown correspondant to Winter.
  else if(mouseX > 1100 && mouseX < 1230 && mouseY > 220 && mouseY < 255){
      if(season == true){   // Changes to Summer season only if season global variable is true.
        season = false;
        daywinter = 1;      // Starts on the first day of Winter day counter global variable each time.
        daysummer = 0;      // Turns off Summer day counter when Winter season is activated.
        month = "Mar";      // Loop allows all days in 'Winter' to allign with days in March.
      }
  }
 // Changes the value of the timebutton[0] global varible to either "Day" or " ".
  else if(mouseX > 1100 && mouseX < 1230 && mouseY > 470 && mouseY < 470+35){
    if((timebutton[0].equals("Day")==true) && (timebutton[1].equals("Night")==true)){ // Prevents that both timebutton[0] and timebutton[1] have " " as value at  the same time.  
      timebutton[0] = " ";
      }
    else if((timebutton[0].equals(" ")==true) && (timebutton[1].equals("Night")==true)){ // Prevents that both timebutton[0] and timebutton[1] have " " as value at  the same time.
      timebutton[0] = "Day";
      } 
  }
   // Changes the value of the timebutton[0] global variable to either "Night" or " ".        
  else if(mouseX > 1100 && mouseX < 1230 && mouseY > 515 && mouseY < 515+35){
    if((timebutton[0].equals("Day")==true) && (timebutton[1].equals("Night")==true)){  // Prevents that both timebutton[0] and timebutton[1] have " " as value at  the same time. 
      timebutton[1] = " ";
    } 
  else if((timebutton[0].equals("Day")==true) && (timebutton[1].equals(" ")==true)){ // Prevents that both timebutton[0] and timebutton[1] have " " as value at  the same time.
      timebutton[1] = "Night";
      }     
  }
  // Changes the value of the activityButton[0] global variable to either "stand" or " ".
  else if(mouseX > 1100 && mouseX < 1230 &&  mouseY > 600 && mouseY < 600+35){ 
    if(activityButton[0].equals(" ") == true) {
       activityButton[0] = "stand";
     }
     //Prevents that a activityButton[0] turns to " " when all the other variables of the activityButton array are equal to " ".
     else if((activityButton[0].equals("stand") == true) && (activityButton[1].equals(" ") == true) && (activityButton[2].equals(" ") == true) && (activityButton[3].equals(" ")  == true) && (activityButton[4].equals(" ")  == true)){
       activityButton[0] = "stand";
     }
     else{
       activityButton[0] = " ";
     }
  }  
  
   // Changes the value of the activityButton[1] global variable to either "sit" or " ".
  else if(mouseX > 1100 && mouseX < 1230 && mouseY > 645 && mouseY < 645+35){
     if(activityButton[1].equals(" ") == true) {
       activityButton[1] = "sit";
     }
     //Prevents that a activityButton[1] turns to " " when all the other variables of the activityButton array are equal to " ".
     else if((activityButton[0].equals(" ") == true) && (activityButton[1].equals("sit") == true) && (activityButton[2].equals(" ") == true) && (activityButton[3].equals(" ")  == true) && (activityButton[4].equals(" ")  == true)){
       activityButton[1] = "sit";
     }
     else{
       activityButton[1] = " ";
     }
  }
  
  // Changes the value of the activityButton[1] global variable to either "forage" or " ".
  else if(mouseX > 1100 && mouseX < 1230 && mouseY > 690 && mouseY < 690+35){
     if(activityButton[2].equals(" ") == true) {
       activityButton[2] = "forage";
     }
     //Prevents that a activityButton[2] turns to " " when all the other variables of the activityButton array are equal to " ".
     else if((activityButton[0].equals(" ") == true) && (activityButton[1].equals(" ") == true) && (activityButton[2].equals("forage") == true) && (activityButton[3].equals(" ")  == true) && (activityButton[4].equals(" ")  == true)){
       activityButton[2] = "forage";
     }
     else{
       activityButton[2] = " ";
     }
  }
  
  // Changes the value of the activityButton[1] global variable to either "body care" or " ".
  else if(mouseX > 1100 && mouseX < 1230 && mouseY > 735 && mouseY < 735+35){
     if(activityButton[3].equals(" ") == true) {
       activityButton[3] = "body care";
     }
     //Prevents that a activityButton[3] turns to " " when all the other variables of the activityButton array are equal to " ".
     else if((activityButton[0].equals(" ") == true) && (activityButton[1].equals(" ") == true) && (activityButton[2].equals(" ") == true) && (activityButton[3].equals("body care")  == true) && (activityButton[4].equals(" ")  == true)){
       activityButton[3] = "body care";
     }
     else{
       activityButton[3] = " ";
     }
  }
  
  // Changes the value of the activityButton[1] global variable to either "fly" or " ".
  else if(mouseX > 1100 && mouseX < 1230 && mouseY > 780 && mouseY < 780+35){
     if(activityButton[4].equals(" ") == true) {
       activityButton[4] = "fly";
     }
     //Prevents that a activityButton[4] turns to " " when all the other variables of the activityButton array are equal to " ".
     else if((activityButton[0].equals(" ") == true) && (activityButton[1].equals(" ") == true) && (activityButton[2].equals(" ") == true) && (activityButton[3].equals(" ")  == true) && (activityButton[4].equals("fly")  == true)){
       activityButton[4] = "fly";
     }
     else{
       activityButton[4] = " ";
     }
  }
  drawPoints();  /* calls the drawPoints function every time one of the buttons in the interface is clicked, assuming 
                 that the values of the global variables were changed, different data should be drawn in the map.*/
  redraw();      
}
  
//---------Graphic Aesthetics---------------------
// Function to load and draw the background map
void backg(){
  backgroundMap = loadImage("map.PNG");
  image(backgroundMap,0,0,1080,850);
}

// The size and shape of each of the button boxes in the menu bar. Fill and Strokeweight for bar and borders. (Except for Activities)
void boxes(){
  //Sidebar  
  fill(0,10);
  rect(1080,0,201,850);
  //Bird buttons
    //Bird 1
  noFill();
  strokeWeight(2);
  rect(1100,50,130,35,5);
    //Bird 2
  rect(1100,95,130,35,5);
  //Season buttons
    //Summer
  rect(1100,175,130,35,5); 
    //Winter
  rect(1100,220,130,35,5);
  //Time buttons
  rect(1100,470,130,35,5); //Day
  rect(1100,515,130,35,5); //Night
}

// Text attributed to each of the buttons. Fill, size and location.
void texts(){
  //Birds
  fill(0);
  textSize(24);
  text("Birds", 1140, 40); //Birds title
  //Birds button labels
  textSize(22);
  text("Bird 1", 1145, 77); //Bird 1 button text
  text("Bird 2", 1145, 122); //Bird 2 button text
  
  //Seasons
  textSize(24);
  text("Seasons", 1140, 165); //Seasons title
  //Seasons button labels
  textSize(22);
  text("Summer", 1122, 202); //Summer button text
  text("Winter", 1132, 247); //Bird 2 button text
  
  //Day
  textSize(24);
  text("Day", 1140, 290); //Day title
  
  //Time
  text("Time", 1140, 460);
  //Time button labels
  textSize(22);
  text("Day", 1145, 497); //Summer button text
  text("Night", 1138, 542); //Winter button text
  
  //Activities
  textSize(24);
  text("Activities", 1140, 587);
  //Activities button labels
  textSize(22);
  text("Stand", 1150, 627);
  text("Sit", 1165, 672);
  text("Forage", 1150, 717);
  textSize(16);
  text("Body Care", 1145,760);
  textSize(22);
  text("Fly", 1170, 807);
}

// Load each of the imported data graphics for buttons and arrows
void loadicons(){
  // All icons are under Creative Commons
  off = loadImage("off.png"); // Source: http://thenounproject.com/term/switch/29573/
  on = loadImage("on.png");  // Source: http://thenounproject.com/term/switch/29574/
  
  up = loadImage("up.png"); // Source: http://thenounproject.com/term/up/8302/
  down = loadImage("down.png"); // Source: http://thenounproject.com/term/down/8303/
  
  birds = loadImage("birds.png"); // Source: http://thenounproject.com/term/bird/5935/
  seasons = loadImage("seasons.png"); // Source: http://thenounproject.com/term/all-season-tire/14196/
  day = loadImage("day.png"); // Source: http://thenounproject.com/term/day/50516/
  time = loadImage("time.png"); // Source: http://thenounproject.com/term/clock/6408/
  activities = loadImage("activities.png"); // Source: http://thenounproject.com/term/pulse/9212/
  
  bird1 = loadImage("bird1.png"); // Source: http://thenounproject.com/term/seagull/20203/
  bird2 = loadImage("bird2.png"); // Source: http://thenounproject.com/term/seagull/20203/  
  
  stand = loadImage("stand1.png"); // Source: http://thenounproject.com/term/seagull/20203/
  sit = loadImage("sit1.png"); // Source: http://thenounproject.com/term/seagull/20203/
  forage = loadImage("forage1.png"); // Source: http://thenounproject.com/term/seagull/20203/
  bodycare =loadImage("bodycare1.png"); // Source: http://thenounproject.com/term/seagull/20203/
  fly = loadImage("fly1.png"); // Source: http://thenounproject.com/term/seagull/20203/  
  
  stand2 = loadImage("stand2.png"); // Source: http://thenounproject.com/term/seagull/20203/
  sit2 = loadImage("sit2.png"); // Source: http://thenounproject.com/term/seagull/20203/
  forage2 = loadImage("forage2.png"); // Source: http://thenounproject.com/term/seagull/20203/
  bodycare2 =loadImage("bodycare2.png"); // Source: http://thenounproject.com/term/seagull/20203/
  fly2 = loadImage("fly2.png"); // Source: http://thenounproject.com/term/seagull/20203/  
  
  // Location and size of where to load each icon
  // Birds title icon
  image(birds, 1100, 13, 35, 35);
  // Bird 1
  image(bird1, 1105, 51, 35, 35); // Bird 1 icon

  // Bird 2
  image(bird2, 1105, 96, 35, 35); // Bird 2 icon
  
  // Seasons title icon
  image(seasons, 1100, 139, 35, 35);
  
  // Day title icon  
  image(day, 1100, 264, 35, 35);  
  // Up button for days
  image(up, 1153, 300, 60, 60);
  // Down button for days
  image(down, 1153, 370, 60, 60);

  // Time title icon
  image(time, 1100, 430, 35, 35);

  // Activities title icon
  image(activities, 1100, 561, 35, 35);
}

// Function to quickly create the activities button boxes
void keybuttons(){
  noFill();
  strokeWeight(2);
  for (int i = 0; i < 225; i = i + 45){  // For loop to make rectangles evenly spaced
    rect(1100,600+i,130,35,5);
  }
}

// Function to make the coloured circles for activities key
void colours(){
  noStroke();
  fill(227, 225, 20);
  ellipse(1122, 618, 25, 25);
  fill(227, 156, 20);
  ellipse(1122, 618+45, 25, 25);
  fill(84, 198, 40);
  ellipse(1122, 618+90, 25, 25);
  fill(181, 44, 125);
  ellipse(1122, 618+135, 25, 25);
  fill(212, 47, 47);
  ellipse(1122, 618+180, 25, 25);
}

//---------Functions to animate the switches---------
// Switches in the birds section
// Bird 1 switch
void birdone(){                     // Following comments relates to all switch functions below  
    if (boobirdy1 == true){         // If the boolean is true, it shows the on switch
      fill(245,245,245);            // Fill to sidebar colour
      rect(1235, 32, 70, 70);       // Small rectangle needed to overlay the previous image, other off switch will still be drawn 
      image(on, 1220, 32, 70, 70);  // Draw the on switch
    }
    else if (boobirdy1 == false){   // If the boolean is true, it shows the off switch
      fill(245,245,245);            // Fill to sidebar colour
      rect(1235, 32, 70, 70);       // Small rectangle needed to overlay the previous image, other on switch will still be drawn
      image(off, 1220, 32, 70, 70); // Draw the off switch
    }
}
// Bird 2 switch
void birdtwo(){
    if (boobirdy2 == true) {
      fill(245,245,245);
      rect(1235, 87, 70, 50);
      image(on, 1220, 77, 70, 70);
    }
    else if (boobirdy2 == false){
      fill(245,245,245);
      rect(1235, 87, 70, 50);
      image(off, 1220, 77, 70, 70);
    }
}
// Switches in the seasons section
// Summer switch
void ssummer(){
  if (boosummer == true) {
      fill(245,245,245);
      rect(1235, 168, 70, 50);
      image(on, 1220, 158, 70, 70);
  }
  else if (boosummer == false) {      
      fill(245,245,245);
      rect(1235, 168, 70, 50);
      image(off, 1220, 158, 70, 70);
  }
}
// Winter switch
void wwinter(){
  if (boowinter == true) {
      fill(245,245,245);
      rect(1235, 213, 70, 50);
      image(on, 1220, 203, 70, 70);
  }
  else if (boowinter == false) {      
      fill(245,245,245);
      rect(1235, 213, 70, 50);
      image(off, 1220, 203, 70, 70);
  }
}
// Switches in time section
// Day switch
void dday(){
    if (boodays == true) {
      fill(245,245,245);
      rect(1235, 463, 70, 50);
      image(on, 1220, 453, 70, 70);
  }
  else if (boodays == false) {      
      fill(245,245,245);
      rect(1235, 463, 70, 50);
      image(off, 1220, 453, 70, 70);
  }
}
// Night switch
void nnight(){
  if (boonights == true) {
      fill(245,245,245);
      rect(1235, 508, 70, 50);
      image(on, 1220, 498, 70, 70);
  }
  else if (boonights == false) {      
      fill(245,245,245);
      rect(1235, 508, 70, 50);
      image(off, 1220, 498, 70, 70);
  }
}
// Switches in activities section
// Stand switch
void sstand(){
  if (boostand == true) {
      fill(245,245,245);
      rect(1235, 594, 70, 50);
      image(on, 1220, 584, 70, 70);
  }
  else if (boostand == false) {      
      fill(245,245,245);
      rect(1235, 594, 70, 50);
      image(off, 1220, 584, 70, 70);
  }
}
// Sit switch
void ssit(){
  if (boosit == true) {
      fill(245,245,245);
      rect(1235, 639, 70, 50);
      image(on, 1220, 629, 70, 70);
  }
  else if (boosit == false) {      
      fill(245,245,245);
      rect(1235, 639, 70, 50);
      image(off, 1220, 629, 70, 70);
  }
}
// Forage switch
void fforage(){
  if (booforage == true) {
      fill(245,245,245);
      rect(1235, 684, 70, 50);
      image(on, 1220, 674, 70, 70);
  }
  else if (booforage == false) {      
      fill(245,245,245);
      rect(1235, 684, 70, 50);
      image(off, 1220, 674, 70, 70);
  }
}
// Body care switch
void bbodycare(){
  if (boobodycare == true) {
      fill(245,245,245);
      rect(1235, 729, 70, 50);
      image(on, 1220, 719, 70, 70);
  }
  else if (boobodycare == false) {      
      fill(245,245,245);
      rect(1235, 729, 70, 50);
      image(off, 1220, 719, 70, 70);
  }
}
// Fly switch
void ffly(){
  if (boofly == true) {
      fill(245,245,245);
      rect(1235, 774, 70, 50);
      image(on, 1220, 764, 70, 70);
  }
  else if (boofly == false) {      
      fill(245,245,245);
      rect(1235, 774, 70, 50);
      image(off, 1220, 764, 70, 70);
  }
}
// -----------Functions overlaying the map------------
// Function to make the top and bottom bars
void bars(){
  fill(0,160);
  noStroke();
  rect(0,0,1080,30);
  rect(0,770+50,1080,30+50);
}

// Draws the date, season and time on the bottom left hand corner 
void drawInfo(){
  imgsummer = loadImage("summer.png"); // Source: http://thenounproject.com/term/sun/15774/ 
  imgwinter = loadImage("winter.png"); // Source: http://thenounproject.com/term/snow/4523/
  imgcalendar = loadImage("calendar.png"); // Source: http://thenounproject.com/term/calendar/404/
  imgtime = loadImage("clock.png"); // Source: http://thenounproject.com/term/clock/20773/
  
  image(imgcalendar, 6, 825, 20, 20);
  // Condition to display the information text when both day and night data is shown in the map.
  textSize(18);
  if((timebutton[0].equals("Day") == true) && (timebutton[1].equals("Night") == true)){
        // Condition to display the information text when showing Summer data.
        if ((month.equals("Jul")) | (month.equals("Aug"))){
          fill(255);
          text("Date: " + daysummer + "/" + month + "/" + "2009 "+ "     Season: Summer      " + "Time: Day and Night", 30, 792+50);
          image(imgsummer, 200, 826, 20, 20);
          image(imgtime, 378, 826, 20, 20);
          redraw();
        }
        // Condition to display the information text when showing Winter data.
        else {
          fill(255);
          text("Date: " + daywinter + "/" + month + "/" + "2010  "  + "     Season: Winter      " + "Time: Day and Night", 30, 792+50);
          // Condition to allign the text and images between the 10th and 21st of March.
          if(daywinter >= 10 && daywinter <= 21){
            image(imgwinter, 215, 826, 20, 20);
            image(imgtime, 378, 826, 20, 20);
            redraw();
          }
          else{
            image(imgwinter, 205, 826, 20, 20);
            image(imgtime, 368, 826, 20, 20);
            redraw();
          }  
        }  
      }
  // Condition to display the information text when either day or night data is shown in the map.
  else if((timebutton[0].equals("Day") == true) | (timebutton[1].equals("Night") == true)){
        // Condition to display the information text when showing Summer data.
        if ((month.equals("Jul")== true) | (month.equals("Aug")==true)){
          // Condition to display the information text when showing Summer data in the day.
          if((timebutton[0].equals("Day") == true)){
            fill(255);
            text("Date: " + daysummer + "/" + month + "/" + "2009 " + "     Season: Summer      " + "Time: " + timebutton[0], 30, 792+50);
            image(imgsummer, 200, 826, 20, 20);
            image(imgtime, 378, 826, 20, 20);
            redraw();
          }
          // Condition to display the information text when showing Summer data in the night.
          else if((timebutton[1].equals("Night") == true)){
            fill(255);
            text("Date: " + daysummer + "/" + month + "/" + "2009 " + "     Season: Summer      " + "Time: " + timebutton[1], 30, 792+50);
            image(imgsummer, 200, 826, 20, 20);
            image(imgtime, 378, 826, 20, 20);
            redraw();
          }
        }
        // Condition to display the information text when showing Winter data.
        else {
          // Condition to display the information text when showing Winter data in the day.
          if((timebutton[0].equals("Day") == true)){
            fill(255);
            text("Date: " + daywinter + "/" + month + "/" + "2010  " + "     Season: Winter      " + "Time: " + timebutton[0], 30, 792+50);
            // Condition to allign the text and images between the 10th and 21st of March.
            if(daywinter >= 10 && daywinter <= 21){
              image(imgwinter, 210, 826, 20, 20);
              image(imgtime, 373, 826, 20, 20);
              redraw();
            }
            else{
              image(imgwinter, 200, 826, 20, 20);
              image(imgtime, 363, 826, 20, 20);
              redraw();
            }
          }
          // Condition to display the information text when showing Winter data in the night.
          else if((timebutton[1].equals("Night") == true)){
            fill(255);
            text("Date: " + daywinter + "/" + month + "/" + "2010  " + "     Season: Winter      " + "Time: " + timebutton[1], 30, 792+50);
            // Condition to allign the text and images between the 10th and 21st of March.
            if(daywinter >= 10 && daywinter <= 21){
              image(imgwinter, 210, 826, 20, 20);
              image(imgtime, 373, 826, 20, 20);
              redraw();
            }
            else{
              image(imgwinter, 200, 826, 20, 20);
              image(imgtime, 363, 826, 20, 20);
              redraw();
            }
          }
        }
  }
}

// Font over the top and bottom bars
void mapdisp(){
  fill(255); // Colour text white
  text("Oyster Catcher GPS Sensor Study (Schiermonnikoog, The Netherlands)", 225, 20); // Title
  textSize(7); // Make source text smaller
  text("Map Source: OpenStreetMap", 975, 782+50); // Map source on bottom right corner of map
  // Data source on bottom right corner of map
  text("Data Source: Shamoun-Baranes, Judy, et al. \"From sensor data to animal behaviour: an oystercatcher example.\" PloS one 7.5 (2012): e37997.", 595, 792+50);
}

// The Netherlands map on bottom left hand corner
void nether(){
  stroke(1); // Stroke around rectangular border 
  strokeWeight(3); // Make stroke weight stronger so border is larger
  rect(0,548+50,171,220); // Rectangle to make the border
  nethermap = loadImage("nethermap.png"); // load The Netherlands map file
  image(nethermap, 0, 550+50, 170, 220);  // Draw The Netherlands map
}

//---------Data Reading and Writing---------------------

// Function for reading data from external csv files 
void readData(){    
  // Loading the csv files contained inside the sketch folder.
  GPS = loadTable("gps.csv", "header"); // Gps, obsID, birdID, Latitude, Longitude and Speed
  Model_output = loadTable("model_output.csv", "header"); // Activity
  Habitat = loadTable("habitat.csv", "header");  // Time(day), Place
  
  proj = new WebMercator();  // Adjusting global co-ordinates for the screen
  
  tlCorner = proj.transformCoords(new PVector(6.1527,53.4873));  // Top left co-ordinates of the map (longitude, latitude)
  brCorner = proj.transformCoords(new PVector(6.3053,53.4188));  // Bottom Right co-ordinates of the map (longitude, latitude)
  
  // Creating MainTable table and columns.
  MainTable = new Table();
  MainTable.addColumn("obsID", Table.INT);
  MainTable.addColumn("birdID", Table.INT);
  MainTable.addColumn("date", Table.STRING);
  MainTable.addColumn("latitude", Table.FLOAT);
  MainTable.addColumn("longitude", Table.FLOAT);
  MainTable.addColumn("speed", Table.FLOAT);
  MainTable.addColumn("time", Table.STRING);
  MainTable.addColumn("place", Table.STRING);
  MainTable.addColumn("activity", Table.STRING);
  
  // Reading all the data from GPS CSV file
  for (TableRow row : GPS.rows()) {
    int obsID = row.getInt("obsID");
    int birdID = row.getInt("birdID");
    String date_time = row.getString("date_time");
    Float latitude = row.getFloat("latitude");
    Float longitude = row.getFloat("longitude");
    Float speed = row.getFloat("speed");
    
    // Adding each of the GPS data rows into the new MainTable correspondant column
    MainTable.addRow();
    MainTable.setInt(MainTable.lastRowIndex(), "obsID", obsID);
    MainTable.setInt(MainTable.lastRowIndex(), "birdID", birdID);
    MainTable.setString(MainTable.lastRowIndex(), "date", date_time);
    MainTable.setFloat(MainTable.lastRowIndex(), "latitude", latitude);
    MainTable.setFloat(MainTable.lastRowIndex(), "longitude", longitude);
    MainTable.setFloat(MainTable.lastRowIndex(), "speed", speed);
  }
  // Reading the desired data from Habitat CSV file  
  for (TableRow row : Habitat.rows()) {
    int hobsID = row.getInt("obsID");
    String htime = row.getString("timelbl2");
    String hplace = row.getString("place");
    
    // Writing the desired data in MainTable matching the primary key data (obsID is the common tuple).
    for (TableRow mrow : MainTable.rows()){    
      if (mrow.getInt("obsID") == hobsID){ 
        mrow.setString("time", htime);
        mrow.setString("place", hplace);
      }
    }
  }
  // Reading the desired data from Model_Output CSV file
  for (TableRow row : Model_output.rows()) {
      int mobsID = row.getInt("obsID");
      String mactivity = row.getString("SA8");
      for (TableRow mrow : MainTable.rows()){    
        if (mrow.getInt("obsID") == mobsID){ 
          mrow.setString("activity", mactivity);
        }
      }
  }
  // Writing the desired data in MainTable matching the primary key data (obsID is the common tuple).
  for (TableRow row : MainTable.rows()) {
      int obsID = row.getInt("obsID");
      int birdID = row.getInt("birdID");
      String date = row.getString("date");
      Float latitude = row.getFloat("latitude");
      Float longitude = row.getFloat("longitude");
      Float speed = row.getFloat("speed");
      String time = row.getString("time");
      String place = row.getString("place");
      String activity = row.getString("activity");
  }
}

// ------------------ Function to be called when plotting all data points ------------------

// Function providing all of the drawing capabilities of data.
void drawPoints(){
  
  
  // For loop to iterate across all MainTable rows to extract the desired data of each row and store it in variables.
  // In this way we compare the data of each row to each global variables, so in the end we draw in the map the data matching with them.
  for (TableRow row : MainTable.rows()) {  
    
    //Row ID an Bird ID data
    int obsID = row.getInt("obsID");
    int birdID = row.getInt("birdID");
    
    //Date splitted in day and month
    String date = row.getString("date");
    String [] splitDate = splitTokens(date, "-");
    int day = int(splitDate[0]);
    String monthTable = splitDate[1];
    
    //Coordinates
    Float latitude = row.getFloat("latitude");
    Float longitude = row.getFloat("longitude");
    
    // Time of day and action
    String time = row.getString("time");
    String activity = row.getString("activity");
    
    // Setting the map co-ordinates into WebMercator values for Global applicability
    PVector wm = proj.latLongToWebMercator(new PVector(longitude,latitude));
    PVector screenco = new PVector(map(wm.x,tlCorner.x,brCorner.x,0,1080),map(wm.y,tlCorner.y,brCorner.y,0,850));
    
    // If statement which matches the row data variables with the global variables controlled with the interface buttons. Responsible for what is projected.
    if(((bird[0] ==  birdID) | (bird[1] == birdID)) && (monthTable.equals(month) == true) && ((daysummer == day) | (daywinter == day)) && ((timebutton[0].equals(time) == true) | (timebutton[1].equals(time) == true)) && ((activity.equals(activityButton[0]) == true ) | (activity.equals(activityButton[1]) == true ) | (activity.equals(activityButton[2]) == true ) | (activity.equals(activityButton[3]) == true ) | (activity.equals(activityButton[4]) == true ))){
 
       /* Printing the Bird in question according to the activities at the location of recording.
          Each Bird is given an icon and each activity is assigned a colour variable for each recording.
          Redraw function is essential to refresh button requests in real time */   
       if (birdID == 166) {  //Images of Bird2
         if(activity.equals("stand") == true){
           image(stand, screenco.x, screenco.y, 30, 30);  
         }
         else if(activity.equals("sit") == true){
           image(sit, screenco.x, screenco.y, 30, 30);
         }
         else if(activity.equals("forage") == true){
           image(forage, screenco.x, screenco.y, 30, 30);
         }
         else if(activity.equals("body care") == true){
           image(bodycare, screenco.x, screenco.y, 30, 30);
         }
         else if(activity.equals("fly") == true){
           image(fly, screenco.x, screenco.y, 30, 30);
         }         
       }
    
       if (birdID == 169) {  // Images of Bird2
         if(activity.equals("stand") == true){
           image(stand2, screenco.x, screenco.y, 30, 30);
         }
         else if(activity.equals("sit") == true){
           image(sit2, screenco.x, screenco.y, 30, 30);
         }
         else if(activity.equals("forage") == true){
           image(forage2, screenco.x, screenco.y, 30, 30);
         }
         else if(activity.equals("body care") == true){
           image(bodycare2, screenco.x, screenco.y, 30, 30);
         }
         else if(activity.equals("fly") == true){
           image(fly2, screenco.x, screenco.y, 30, 30);
         }
      }
    }
  }
}
