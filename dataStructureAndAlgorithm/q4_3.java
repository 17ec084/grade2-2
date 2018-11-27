class q4_3
{
    public static void main(String[] args)
    {
        int[] i = new int[500];//2つに一つは偶数なので、1000を2で割ってよい。
        //Javaの仕様で、int型の配列は0で初期化されている。
        System.out.println(i[0]=2);
        System.out.println(i[1]=3);

        int counter = 0;
        int numCounter = 2;
        boolean isPrime;
        int m;
        for(int n=4; n<=1000; n++)
        {
            isPrime = true;
            //最初は、nが素数であるとみなす。
            //(∵iの区間の大きさは原則0、つまりすべて素数と判定)

            for(m=0; i[m]!=0; m++)
            //ただし、すべての(過去に見つかった)素数で
            {
                if(n%i[m]==0)//nを割って、割り切れたことがある場合
                {
                    isPrime = false;//素数ではないといえる
                    break;
                }
                counter++;
            }//割り切れたことがない場合は、素数であるといえるのでなにもしない。

            if(isPrime)//素数だったのなら
            {
                i[m] = n;//素数として記憶し、
                System.out.println(n);//表示する。
                numCounter++;
            }

        }
        System.out.println("除算を行った回数:"+ counter);
        System.out.println("みつかった素数の個数:"+ numCounter);
    }
}
