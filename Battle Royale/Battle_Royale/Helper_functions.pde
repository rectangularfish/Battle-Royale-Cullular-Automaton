// function calculates the next generation of cells based on their interactions
void calculateNextGeneration() {

  int enemies;
  int allies;
  PVector neighbours, neighboursDead;
  cellsNext = new Cell[n][n];


  // loop through all cells
  for (int i = 0; i < n; i++) {
    for (int j = 0; j < n; j++) {

      // set current cell troop and current terrain cell
      Cell c = cells[i][j];
      Cell t = terrain[i][j];


      // handle resurrection logic
      if (resurrection) {

        // count how many enemies and allies are surrounding a dead cell
        neighboursDead = t.countCellsSurrouding();
        enemies = int(neighboursDead.x);
        allies = int(neighboursDead.y);

        // resurrect dead cell if there are 4 allies surrounding it and there are no enemies
        if (t.state == DEAD && allies == 4 && enemies == 0) {
          // turn dead cell on terrain to grass
          t.setState(GRASS);
          // set the location of the dead cell to a random troop in the next generation
          cellsNext[t.x][t.y] = new Cell(t.x, t.y, int(random(4, 7)));
        } else if (t.state == DEAD && enemies == 4 && allies == 0) {
          // turn dead cell on terrain to grass
          t.setState(GRASS);
          // set the location of the dead cell to a random troop in the next generation
          cellsNext[t.x][t.y] = new Cell(t.x, t.y, int(random(1, 4)));
        }
      }

      // handle cell interactions and movement
      if (c != null) {

        // count surrounding cells
        neighbours = c.countCellsSurrouding();
        enemies = int(neighbours.x);
        allies = int(neighbours.y);





        // if the current cell is an enemy
        if ((c.state == ENEMY_ARCHER || c.state == ENEMY_SWORD || c.state == ENEMY_HORSE) ) {
          enemies += 1;
          // if there are more allies than enemies, the cell becomes dead and is not transferred to the next generation
          if (allies > enemies) {
            c.health--;
            // cell is not transferred to the next generation and changes the state of the grass where the current troop was to dead
            if (c.health == 0) {
              terrain[i][j] = new Cell(i, j, DEAD);
              continue;
            }
          }
          // if the current cell is an ally
        } else if ((c.state == MY_ARCHER || c.state == MY_SWORD || c.state == MY_HORSE)) {

          allies += 1;
          // if there are more enemies than allies, the cell becomes dead and is not transferred into the next generation          if (enemies > allies ) {
          if (enemies > allies ) {

            c.health--;

            if (c.health == 0) {
              terrain[i][j] = new Cell(i, j, DEAD);

              continue;
            }
          }
        }
        // attempt random movement for cells
        try {
          cells[i][j].randMove();
        }
        catch (Exception e) {
          // handle exception if movement cannot be resolved
          println("Catch exception because couldn't resolve.");
          delay(2000);
          cellsNext[i][j] = cells[i][j];
        }
      }
    }
  }
}

// set the current cells to the following generation
void copyNextGenerationToCurrentGeneration() {
  for (int i = 0; i < n; i++)
    for (int j = 0; j < n; j++)
      cells[i][j] = cellsNext[i][j];
}

// initialize the terrain
void setGrass() {
  for (int i=0; i<n; i++) {
    for (int j=0; j<n; j++) {
      terrain[i][j] = new Cell(i, j, GRASS);
    }
  }
}



// generation a certain class of units at random positions on the grid
void genClass(int amount, int start, int end, int id) {
  int x;
  int y;

  for (int i = 0; i < amount; i++) {
    x = round(random(start, end)) - 1;
    y = round(random(start, end)) - 1;



    while (true) {

      if (cells[x][y] == null) {
        cells[x][y] = new Cell(x, y, id);
        cellsNext[x][y] = new Cell(x, y, id);

        break;
        // if there is already a troop in the random location, then find a new random location
      } else {
        x = round(random(start, end)) - 1;
        y = round(random(start, end)) - 1;
      }
    }
  }
}


// generate armies of archers, swordsmen and horsemen for both player and enemy
void genArmy(int archers, int swords, int horses, int type) {


  int start, end;
  int archer, sword, horse;

  // player values
  if (type == 0) {
    end = n ;
    start = n/2;
    archer = MY_ARCHER;
    sword = MY_SWORD;
    horse = MY_HORSE;
    
  // enemy values
  } else {

    end = n/2;
    start = 1;
    archer = ENEMY_ARCHER;
    sword = ENEMY_SWORD;
    horse = ENEMY_HORSE;
  }

  int totalArchers = archers;
  int totalSword = swords;
  int totalHorse = horses;


  start += 1;

  end -= 1;
  
  
  // generate classes
  genClass(totalArchers, start, end, archer);
  genClass(totalSword, start, end, sword);
  genClass(totalHorse, start, end, horse);
}




// check if a team has won if there are no troops in the opposite armies left
PVector checkWin(int ne, int na) {

  PVector tOf = new PVector(0, 0);


  if (na == 0) {

    // enemey wins
    tOf.x = 1;
  } else if ( ne == 0) {
    
    // player wins
    tOf.y = 1;
  }
  return tOf;
}


// loops through all cells in the current generation and counts how many enemey troops there are and how many player troops there are
PVector checkNumStates() {

  int countAllies = 0;
  int countEnemies = 0;

  for (int i=0; i<n; i++) {
    for (int j=0; j<n; j++) {

      Cell c = cells[i][j];
      if (c == null) continue;


      if (c.state == ENEMY_ARCHER || c.state == ENEMY_SWORD || c.state == ENEMY_HORSE) {

        countEnemies++;
      } else {
        countAllies++;
      }
    }
  }

  return new PVector(countEnemies, countAllies);
}

// displays statistics about the remaining troops and current generation
void drawStats(int ne, int na) {


  fill(255);
  
  text("Generation: " + generation, 260, 33);
  
  text("Player troops left: " + na + " %: " + round((float(na) / (na + ne)) * 100), 35, 687.5);

  text(" Enemies left: " + ne + " %: " + round((float(ne) / (na + ne)) * 100), 385, 687.5);
}
