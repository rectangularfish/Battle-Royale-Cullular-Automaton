/*
18th Century Battle Royale
By: Nikolaus Fischmeister

Last team standing wins!

*/


// MODIFY THESE
int n = 25;
float padding = 40;


// PLAYER ARMY
// number of archerse, swordsman, horseman
int myArcher = 34;
int mySword = 12;
int myHorse = 19;

// ENEMY ARMY
int oppArchers = 4;
int oppSword = 12;
int oppHorse = 19;

// resurrection is an ability where a group of 4 troops can relive a dead cell into a random troop (archer, swordsman, horseman)
boolean resurrection = false;
// the higher the value is the more likely a troops random move is towards the center
float chanceToRunToCenter = 0.3;  // 0.0 - 0.5
// how many generations it takes for the board to get smaller to force enemy troops to fight against each other in a smaller area
int generationPerZone = 20;
float blinksPerSecond = 20; // speed of animation




// DO NOT MODIFY THESE
float cellSize;
int enemyCellsLeft;
int allyCellsLeft;
PVector totalLeft;
PVector win;
int generation = 0;


// ids for troops
final int GRASS = 0;
final int ENEMY_ARCHER = 1;
final int ENEMY_SWORD = 2;
final int ENEMY_HORSE = 3;
final int MY_ARCHER = 4;
final int MY_SWORD = 5;
final int MY_HORSE = 6;
final int DEAD = 7;


/*
There are three main classes in the Battle Royale:

Archer
Swordsman
Horseman

These three have unique characteristics that change how they interact with this simulation.
All classes have range, health and speed.

Unique per class

Archer: The range of attack is 2 instead of 1
Horseman: Speed of 3 instead of 1 
Swordsman: Health of 3 instead of 1

These classes also have different colours to identify which troops belong to which class.

This information and more can be seen below.
*/
// specific characteristics that go for each troop class
final int id[] = {GRASS, ENEMY_ARCHER, ENEMY_SWORD, ENEMY_HORSE, MY_ARCHER, MY_SWORD, MY_HORSE, DEAD};
final color colors[] = {color(45, 138, 47), color(255, 0, 0), color(180, 130, 70), color(128, 0, 0), color(0, 0, 255), color (70, 130, 180), color(0, 0, 128), color(0, 0, 0) };
final int ranges[] = {0, 2, 1, 1, 2, 1, 1, 0};
final int speeds[] = {0, 1, 1, 3, 1, 1, 3, 0};
final int healths[] = {0, 1, 3, 2, 1, 3, 2, 0};

// generate cell class
Cell[][] cells, cellsNext;
Cell[][] terrain;


void setup() {
  size(700, 700);

  // initial conditions
  textSize(30);
  cellSize = (width - 2*padding)/n;
  frameRate( blinksPerSecond );

  // initialize arrays to store cells and terrain cells
  cells = new Cell[n][n];
  terrain = new Cell[n][n];
  cellsNext = new Cell[n][n];

  //initial state of the simulation
  setGrass();
  genArmy(oppArchers, oppSword, oppHorse, 1);
  genArmy(myArcher, mySword, myHorse, 0);
}

void draw() {
  // calculates the number of cells left for the enemy and ally
  totalLeft = checkNumStates();
  enemyCellsLeft = int(totalLeft.x);
  allyCellsLeft = int(totalLeft.y);

  // check if there is a winner
  win = checkWin(enemyCellsLeft, allyCellsLeft);

  generation++;

  // create a shrinking zone effect to force enemies to face off in the center
  if (generation%generationPerZone == 0) {
    n--;
    padding = padding+cellSize/2;
  }
  background(38, 70, 158);
  
  // if the game has not finished, continue the simulation
  if (int(win.x) != 1 || int(win.y) != 1) {
    // display the terrain and cells
    for (int i=0; i<n; i++) {
      for (int j=0; j<n; j++) {
        
        terrain[j][i].drawMe(padding, cellSize);
        // check if a cell exists and display it
        if (cells[j][i] != null ) {
          cells[j][i].drawMe(padding, cellSize);
        }
      }
    }

    // display statistics
    drawStats(enemyCellsLeft, allyCellsLeft);

    // calculate the next generation of cells
    calculateNextGeneration();

    //  copy the next generation into the current generation
    copyNextGenerationToCurrentGeneration();
  }

  // if the enemy wins
  if (win.x == 1) {
    textSize(48);

    // display end screen
    text("Enemies Won", 220, (height / 2) - 50);
    text("You Lost", 270, height/2 + 30 );
    noLoop(); // stop draw loop


    // if the player wins
  } else if (win.y == 1) {
    textSize(48);

    // display end screen
    text("You Won", 270, (height / 2) - 50);
    text("Enemies Lost", 220, height/2 + 30 );
    noLoop(); // stop draw loop
  }
}
