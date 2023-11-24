class Cell {


  // field values
  color col;
  int speed, range, health, state, x, y;


  // initalize position and state
  Cell(int x, int y, int s ) {
    setX(x);
    setY(y);
    setState(s);
  }

  // method that randomly moves the cell and handles collisions
  void randMove() throws Exception {

    // randomly determines speed for x values
    int speedX=int(random(0, speed + 1));


    // adjust the movement based on where the cell currently is
    if ( this.x > n/2 ) {

      // have cells have a higher chance of moving to the middle
      if ( random(0, 1) < (0.5+chanceToRunToCenter) )
        speedX = speedX*-1;
    } else {
      if ( random(0, 1) < (0.5-chanceToRunToCenter))
        speedX = speedX*-1;
    }


    // randomly determines speed for y values
    int speedY=int(random(speed + 1));
    if ( this.y > n/2) {
      
      // have cells have a higher chance of moving to the middle
      if ( random(0, 1) < (0.5+chanceToRunToCenter) )
        speedY = speedY*-1;
    } else {
      if ( random(0, 1) < (0.5-chanceToRunToCenter) )
        speedY = speedY*-1;
    }

    // 50 % chance to move on y-axis or x-axis
    int chance = int(random(2));
    if (chance == 0) {
      setX( this.x + speedX );
    } else {
      setY( this.y + speedY );
    }


    // if there is no cell, then there is no collision, so it can safely move
    if (cellsNext[this.x][this.y] == null ) {
      cellsNext[this.x][this.y] = this;
    } else {
      
      // function finds a free cell nearby to resolve collision
      PVector freeCell = findNearbyCells();
      
      
      // change the x and y to the free cell and set it in the next generation
      this.setX(int(freeCell.x));
      this.setY(int(freeCell.y));
      cellsNext[int(freeCell.x)][int(freeCell.y)]=this;
    }
  }





  // method counts the number of ally and enemy cells surrounding the current
  PVector countCellsSurrouding() {

    int countEnemies = 0;
    int countAllies = 0;
    println("");

    for (int a = -2; a <= 2; a++) {
      for (int b = -2; b <= 2; b++) {

        int checkX = this.x+a;
        int checkY = this.y+b;


        // check if the neighbouring cell is within the bounds of the grid and the make sure current cell is not counting itself
        if (checkX < 0 || checkY < 0 || checkX >= n || checkY >= n || (a == 0 && b == 0)) {
          continue;
        }


        // count ally and enemy cells based on their type and range
        Cell c = cells[checkX][checkY];
        if (c != null) {
          switch (c.state) {
          case ENEMY_ARCHER:
            if (abs(a) == 2 || abs(b) == 2) {
              countEnemies++;
            }
            break;
          case ENEMY_SWORD:
            if (abs(a) < 2 && abs(b) < 2) {
              countEnemies++;
            }
            break;
          case ENEMY_HORSE:
            if (abs(a) < 2 && abs(b) < 2) {
              countEnemies++;
            }
            break;
          case MY_ARCHER:
            if (abs(a) == 2 || abs(b) == 2) {
              countAllies++;
            }
            break;
          case MY_SWORD:
            if (abs(a) < 2 && abs(b) < 2) {
              countAllies++;
            }
            break;
          case MY_HORSE:
            if (abs(a) < 2 && abs(b) < 2) {
              countAllies++;
            }
            break;
          }
        }
      }
    }

    return new PVector(countEnemies, countAllies);
  }

  // method finds a nearby free cell fro resolving colliion
  PVector findNearbyCells() {


    // pick random start value
    int startX = int(random(50, 100));
    int startY = int(random(50, 100));


    
    // search in growing circles for a free spot
    for (int i=1; i<=n; i++) {
      for (int dx = -i; dx <= +i; dx++ ) {
        for (int dy = -i; dy <= +i; dy ++ ) {
          
          
          // pick y value 
          int tryX = this.x + ((startX+dx)%(2*i+1))-i;
          
          // pick next y value
          int tryY = this.y + ((startY+dy)%(2*i+1))-i;

          if (tryX < 0 || tryY < 0 || tryX >= n || tryY >= n) {
            continue;
          }

          if (cellsNext [tryX][tryY] == null) {
            // found a free cell
            return new PVector(tryX, tryY);
          }
        }
      }
    }

    return null;
  }


  // set method for the x-coordinate and checks if it is valid
  void setX( int newX ) {
    if ( (newX < n) && (newX >= 0) ) {
      this.x = newX;
    } else {
      println("ERROR: invalid x: "+x);
      //exit();
    }
  }


  // set method for the y-coordinate and checks if it is valid
  void setY( int newY ) {
    if ( (newY < n) && (newY >= 0) ) {
      this.y = newY;
    } else {
      println("ERROR: invalid y: "+y);
      //exit();
    }
  }



  // set method for the cell state and checks if it is a valid state
  void setState(int s) {
    if ( (s >= 0) && (s <= 7) ) {
      this.state = s;
      this.speed = speeds[s];
      this.col = colors[s];
      this.range = ranges[s];
      this.health = healths[s];
    } else {
      println("error: set invalid state "+s);
      exit();
    }
  }




  // method to draw cells
  void drawMe(float padding, float cellWidth) {

    // draw square
    fill(this.col);
    square(padding+this.x*cellWidth, padding+this.y*cellWidth, cellSize);
  }
}
