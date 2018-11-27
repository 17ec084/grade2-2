class q10
//文字列の中から特定の文字を探し出すアルゴリズム
{
    static int strpos(String haystack, char needle)
    //乾草(haystack)の中から針(needle)を探すメソッド
    {
        //char[] arr = haystack.toCharArray();
        
        for(int i=0; ; i++)
        {
            if(i==haystack.length())
                return -1;
            if(haystack.toCharArray()[i]==needle)
          //if(arr[i]==needle)
                return i;
        }
    }

    public static void main(String[] args)
    {
        String univ_name = "TokyoDenkiUniversity";
        char key = 'k';
        System.out.println(strpos(univ_name,key));
    }

}
