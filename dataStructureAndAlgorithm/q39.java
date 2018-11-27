import java.util.Scanner;
class q39
{
//バブルソート(打ち切りでない高速化を行っている)
  static void swap(int[] a, int idx1, int idx2)
  {
    int t=a[idx1];
    a[idx1]=a[idx2];
    a[idx2]=t;
  }
  static void bubbleSort(int[] a, int n)//第二引数は配列の要素数
  {
    int k=0;//a[k]より前はソート済み
    while(k<n-1)
    {
      int last=n-1;
      for(int j=n-1; j>k; j--)
        if(a[j-1]>a[j])
        {
          swap(a, j-1, j);
          last=j;
        }
      k=last;
    }

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
