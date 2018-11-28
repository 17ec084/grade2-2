import java.util.Scanner;
class q53
{
//ユークリッドの互除法を再帰アルゴリズムで求める
  static int gcd(int x, int y)
  {
    if(y==0)
      return x;
    else
      return gcd(y,x%y);
  }
  public static void main(String[] args)
  {
    Scanner stdIn= new Scanner(System.in);
    System.out.println("input 2 Natural Numbers x and y");
    int x=stdIn.nextInt();
    int y=stdIn.nextInt();
    System.out.println("gcd(" + x + "," + y + ")=" + gcd(x,y));
  }
}

