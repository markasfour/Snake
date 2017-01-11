//code sprint
//start: 1/10/17 5:00pm
//1/10/17 6:00pm - basic game functionality complete
//1/10/17 7:00pm - game with rules complete
//1/10/17 7:20pm - game complete with all intended features and preliminary bug checks

int w;
int h;
int map[][]; //0 = empty, 1 = snake, 2 = food
int square_size = 20;
snake player;
food doof;
boolean eaten;
boolean lost;
boolean win;
boolean start;
boolean restart;
int seconds;
int minutes;
int counter;

void setup(){
  size(640, 480);
  frameRate(30);
  textSize(32);
  w = width / square_size;
  h = (height - 2*square_size) / square_size;
  map = new int [w][h];
  background(85, 108, 98);

  player = new snake();
  doof = new food();
  
  start = false;
  restart = false;
  eaten = false;
  lost = false;
  win = false;
  seconds = 0;
  minutes = 0;
  counter = int(frameRate);
}

void draw(){
  background(85, 108, 98);
  player.draw();
  
  if(start){
    if(!lost && !win){
      player.keyPressed();
      player.move();
      increment_time();
      win = check_win();
    }
    else{
      fill(255, 0, 0);
      textAlign(CENTER);
      textSize(32);
      stroke(0);
      if(lost)
        text("GAME OVER", width / 2, height / 2);
      else if(win){
        fill(0, 255, 0);
        text("CONGRATULATIONS!", width / 2, height / 2);
      }
    }
    if(eaten)
      eat();
  }
  
  doof.draw();
  
  fill(0);
  rect(0, height - 2*square_size, width, 2*square_size);
  fill(255);
  textAlign(LEFT);
  textSize(square_size);
  text("SCORE: " + (int(player.size + 1)), 5, height - square_size / 2);
  
  fill(255);
  textAlign(RIGHT);
  textSize(square_size);
  if(seconds < 10)
    text(minutes + ":" + "0" + seconds, width - 5, height - square_size / 2);
  else
    text(minutes + ":" + seconds, width - 5, height - square_size / 2);
    
  if(!start){
    fill(255);
    textAlign(CENTER);
    textSize(square_size);
    text("PRESS ANY KEY TO START", width / 2, height - square_size / 2);
  }
  if((lost || win) && !restart){
    fill(255);
    textAlign(CENTER);
    textSize(square_size);
    text("PRESS ANY KEY TO RESTART", width / 2, height - square_size / 2);
  }
}

void keyPressed(){
  if(!start){
    if(key != '\0')
      start = true;
  }
  if((lost || win) && !restart){
    if(key != '\0')
      restart = true;
      reset();
      lost = false;
  }
}

void increment_time(){
  if(counter == 0){
    seconds++;
    if(seconds == 60){
      minutes++;
      seconds = 0;
    }
    counter = 30;
  }
  else{
    counter--;
  }
}

boolean check_win(){
  for(int i = 0; i < w; i++){
    for(int j = 0; j < h; j++){
      if(map[i][j] != 1)
        return false;
    }
  }
  return true;
}

void reset(){
  restart = false;
  lost = false;
  win = false;
  for(int i = 0; i < w; i++){
    for(int j = 0; j < h; j++){
      map[i][j] = 0;
    }
  }
  player.reset();
  doof.remap();
  seconds = 0;
  minutes = 0;
}

void eat(){
  doof.remap();
  eaten = false;
}

class snake{
  int x;
  int y;
  int size; 
  ArrayList<PVector> tail;
  int direction; //1 = up, 2 = down, 3 = left, 4 = right
  int timer;
  boolean moved;
  
  snake(){
   x =  w / 2;
   y = h / 2;
   size = 4;
   tail = new ArrayList<PVector>();
   direction = 1;
   timer = 15;
   moved = false;
   
   map[x][y] = 1;
   for(int i = 1; i <= size; i++){
     map[x][y+i] = 1; 
     tail.add(new PVector(x, y+i));
   }
  }
 
  void reset(){
   x =  w / 2;
   y = h / 2;
   size = 4;
   tail = new ArrayList<PVector>();
   direction = 1;
   timer = 15;
   
   map[x][y] = 1;
   for(int i = 1; i <= size; i++){
     map[x][y+i] = 1; 
     tail.add(new PVector(x, y+i));
   }
  }
 
  void keyPressed(){
    if(!moved){
      if(key == 'w' && direction != 2){
        direction = 1;
        moved = true;
      }
      else if(key == 's' && direction != 1){
        direction = 2;
        moved = true;
      }
      else if(key == 'a' && direction != 4){
        direction = 3;
        moved = true;
      }
      else if(key == 'd' && direction != 3){
        moved = true;
        direction = 4;
      }
    }
  }
  
  void move(){
    if(timer == 0){
      map[int(tail.get(size - 1).x)][int(tail.get(size - 1).y)] = 0;
      
      PVector last = new PVector(tail.get(size - 1).x, tail.get(size - 1).y);
      
      for(int i = size - 1; i > 0; i--){
        tail.get(i).x = tail.get(i - 1).x;
        tail.get(i).y = tail.get(i - 1).y;
      }
      tail.get(0).x = x;
      tail.get(0).y = y;
         
      if(direction == 1)
        y--;
      else if(direction == 2)
        y++;
      else if(direction == 3)
        x--;
      else if(direction == 4)
        x++;
      
      try{  
      if(map[x][y] == 2){
        size++;
        tail.add(last);
        eaten = true;
      }
      else if(map[x][y] == 1){
        lost = true;
        return;
      }
       
        
      map[x][y] = 1;
      for(int i = 0; i < size; i++)
        map[int(tail.get(i).x)][int(tail.get(i).y)] = 1;   
      
      moved = false;  
      timer = 7;
      }
      catch (Exception e){
        lost = true;
        return;
      }
    }
    else
      timer--;
  }
  
  void draw(){
    fill(255);
    stroke(0);
    rect(x * square_size, y * square_size, square_size, square_size);
    for(int i = 0; i < size; i++){
      fill(255);
      stroke(0);
      rect(tail.get(i).x * square_size, tail.get(i).y * square_size, square_size, square_size);
    }
  }
}

class food{
  int x;
  int y;
 
  food(){
    x = int(random(w));
    y = int(random(h));
    while(map[x][y] == 1){
      x = int(random(w));
      y = int(random(h));
    }
    map[x][y] = 2;
  }
  
  void remap(){
    x = int(random(w));
    y = int(random(h));
    while(map[x][y] == 1){
      x = int(random(w));
      y = int(random(h));
    }
    map[x][y] = 2;
  }
  
  void draw(){
    fill(255, 0, 0);
    stroke(0);
    ellipseMode(CORNER);
    ellipse(x * square_size, y * square_size, square_size, square_size);
  }
}
