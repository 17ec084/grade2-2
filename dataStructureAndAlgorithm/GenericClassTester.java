//ジェネリックを理解するためのサンプルプログラム
class GenericClass<T>
{
    private T xyz;
    GenericClass(T t)
    {
        this.xyz=t;
    }
    T getXyz()
    {
        return xyz;
    }
}
/*
これを、利用するクラスは、
*/
class GenericClassTester
{
    public static void main(String[] args)
    {
        GenericClass<String> str = new GenericClass<String>("str");
        GenericClass<Integer> i = new GenericClass<Integer>(1);
        System.out.println(str.getXyz());
        System.out.println(i.getXyz());
    }
}
/*
である。
*/
