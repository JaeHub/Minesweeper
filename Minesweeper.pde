

import de.bezier.guido.*;
//Declare and initialize NUM_ROWS and NUM_COLS = 20
private static int NUM_ROWS =  20;
private static int NUM_COLS = 20;
private static int NUM_BOMBS = 3;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs = new ArrayList <MSButton> () ; //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int r = 0; r < NUM_ROWS; r++){
      for(int c = 0; c < NUM_COLS;c++){
        buttons[r][c] = new MSButton(r,c);
      }
    }
    setBombs();
}
public void setBombs()
{
    //your code
    while(bombs.size() < NUM_BOMBS){
      int r = (int)(Math.random() * NUM_ROWS);
      int c = (int)(Math.random() * NUM_COLS);
      if(bombs.contains(buttons[r][c]) != true){
        bombs.add(buttons[r][c]);
        System.out.println(r + ", " + c);
      }
    }
}

public void draw ()
{
    background( 0 );
    if(isWon())
        displayWinningMessage();
}
public boolean isWon()
{
    //your code here
    int winCount = 0;
    for(int i = 0; i < bombs.size(); i++){
      if(bombs.get(i).isMarked() == true){
        winCount = winCount + 1;
        if(winCount == bombs.size()){
          return true;
        }
      }
    }
    return false;
}
public void displayLosingMessage()
{
    //your code here
    for(int i = 0; i < bombs.size(); i++){
      bombs.get(i).clicked = true;
      bombs.get(i).setLabel(">:)");
    }
}
public void displayWinningMessage()
{
    //your code here
    for(int r = 0; r < NUM_ROWS; r++){
      for(int c = 0; c < NUM_COLS;c++){
        buttons[r][c].setLabel(":)");
      }
    }
}

public class MSButton
{
    private int r, c;
    private float x,y, width, height;
    private boolean clicked, marked;
    private String label;
    
    public MSButton ( int rr, int cc )
    {
         width = 400/NUM_COLS;
         height = 400/NUM_ROWS;
        r = rr;
        c = cc; 
        x = c*width;
        y = r*height;
        label = "";
        marked = clicked = false;
        Interactive.add( this ); // register it with the manager
    }
    public boolean isMarked()
    {
        return marked;
    }
    public boolean isClicked()
    {
        return clicked;
    }
    // called by manager
    
    public void mousePressed () 
    {
        clicked = true;
        //your code here
        if(mouseButton == RIGHT && marked == false){
          marked = true;
        }else if(mouseButton == RIGHT && marked == true){
          marked = false;
          clicked = false;
        }else if(bombs.contains(this)){
          displayLosingMessage();
        }else if(countBombs(r,c) > 0 && clicked == true){
          setLabel(""+countBombs(r,c));
        }else{
          for(int x = r-1; x <= r+1;x++){
            for(int y = c-1; y <= c+1;y++){
              if(isValid(x,y) == true && buttons[x][y].isClicked() == false){
                buttons[x][y].mousePressed();
              }
            }
          }
        }
    }

    public void draw () 
    {    
        if (marked)
            fill(0);
         else if( clicked && bombs.contains(this) ) 
             fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(label,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        label = newLabel;
    }
    public boolean isValid(int r, int c)
    {
        //your code here
        if(r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS){
          return true;
        }
        return false;
    }
    public int countBombs(int row, int col)
    {
        int numBombs = 0;
        //your code here
        for(int r = row - 1; r <= row + 1; r++){
          for(int c = col - 1; c <= col + 1; c++){
            if(this.isValid(r,c) == true && bombs.contains(buttons[r][c])==true){
              numBombs = numBombs + 1;
            }
          }
        }
        return numBombs;
    }
}
