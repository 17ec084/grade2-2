class q4_1
{
    public static void main(String[] args)
    {
        int counter = 0;//除算の回数
        for(int n=2; n<=1000;n++)
        {
            int i;
            for(i=2; i<=n/2; i++)
            {
                counter++;
                if(n%i==0)//iで割れたのなら素数ではない
                    break;
            }
            if(i>n/2)//最後まで割り切れなかったなら、素数である
                System.out.println(n);
        }
        System.out.println("除算の回数:" + counter);
    }
}
