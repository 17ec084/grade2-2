import java.util.Scanner;
class q47
{
//階乗を再帰アルゴリズムを用いて求める
  static int factorial(int n)
  {
    if(n>0)
      return n * factorial(n-1);
    else
      return 1;
  }
  public static void main(String[] args)
  {
    Scanner stdIn = new Scanner(System.in);
    int x = stdIn.nextInt();
    System.out.println(x+"!=" + factorial(x));
  }
}
