import java.util.Scanner;
class q36
{
//バブルソート
  static void swap(int[] a, int idx1, int idx2)
  {
    int t=a[idx1];
    a[idx1]=a[idx2];
    a[idx2]=t;
  }
  static void bubbleSort(int[] a, int n)//第二引数は配列の要素数
  {
    for(int i=0; i<n-1; i++)//配列a[0~n-1]内任意の要素をa[i]とする。
      for(int j=n-1;j>i;j--)//i超n-1以下の範囲で
        if(a[j-1]>a[j])
        //自分と一つ前の要素を比較して、昇順になっていないものがあったら
          swap(a,j-1,j);//入れ替える
  }
  public static void main(String[] args)
  {
    Scanner stdIn=new Scanner(System.in);
    System.out.print("要素数:");
    int nx=stdIn.nextInt();//nxは要素数。
    int[] x=new int[nx];
    //ソートするための配列をここで作る。(各値はユーザに聞く)
    for(int i=0; i<nx; i++)
    {
      System.out.print("x[" + i + "]:");
      x[i]=stdIn.nextInt();
    }
    bubbleSort(x,nx);
    System.out.println("昇順にソートしました。");
    for(int i=0; i<nx; i++)
      System.out.println("x[" + i + "]=" + x[i]);
  }
}
