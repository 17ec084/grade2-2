import java.util.Scanner;
class q14
//2分探索のプログラムである
{
    static int binSearch(int[] a, int n, int key)
    //配列aの先頭n個の要素からkeyと一致する要素を2分探索
    {
        int pl = 0;//探索範囲先頭のインデックス
        int pr = n-1;//探索範囲末尾のインデックス
        do
        {
            int pc = (pl+pr)/2;//探索範囲中央のインデックス
            if(a[pc]==key)
                return pc;
            else if (a[pc]<key)
                pl = pc+1;
            else
                pr = pc-1;
        }
        while(pl<=pr);
            return -1;//探索失敗
    }
    public static void main(String[] args)
    {
        Scanner stdIn = new Scanner(System.in);
        int num=stdIn.nextInt();
        int[] x=new int[num];
        System.out.println("昇順に入力してください。");
        System.out.print("x[0]:");
        x[0]=stdIn.nextInt();
        for(int i=1; i<num; i++)
        {
            do
            {
                System.out.print("x["+i+"]:");
                x[i]=stdIn.nextInt();
            }
            while(x[i]<x[i-1]);//一つ前の要素より小さければ再入力
        }
        System.out.print("探す値:");
        int ky=stdIn.nextInt();
        int idx=binSearch(x,num,ky);
        if (idx==-1)
            System.out.println("要素 not found");
        else
            System.out.println("found at" + idx);
    }
}