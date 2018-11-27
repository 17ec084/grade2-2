public class IntStack
{
  private int max;//スタックの容量
  private int ptr;
  private int[] stk;
  public class OverflowIntStackException extends RuntimeException
  {
    public OverflowIntStackException(){}
  }

  public class EmptyIntStackException extends RuntimeException
  {
    public EmptyIntStackException(){}
  }

  public IntStack(int capacity)
  {
    ptr=0;
    max=capacity;
    try//まず～～みる
    {
      stk = new int[max];//～～=実際に作って
    }
    catch(OutOfMemoryError e)//それでダメだったら
    {
      max=0;
      /*
      配列のサイズは0であると明示することで
      他のメソッドによる不正参照を防いでいる。
      */
    }
  }
  public int push(int x) throws OverflowIntStackException
  {
    if(ptr>=max)//スタックが満杯なら
      throw new OverflowIntStackException(); 
      //例外OverflowIntStackExceptionを投げる
    return stk[ptr++]=x;//スタックが満杯でない場合(つまり通常通りの時)、やる。
    /*
    後置インクリメント用いた理由については、
    https://github.com/17ec084/grade2-2/blob/master/
    dataStructureAndAlgorithm/note.pdf
    の答え32(ク)で詳しく説明している。
    */
  }
  public int pop() throws EmptyIntStackException
  {
    if(ptr<=0)//スタックが空なら
      throw new EmptyIntStackException();
    return stk[--ptr];
  }
  public int peek() throws EmptyIntStackException
  /*最新のデータを覗き見する*/
  {
    if(ptr<=0)
      throw new EmptyIntStackException();
    return stk[ptr-1];
  }
  public int indexOf(int x)
  /*xを探してその場所を返す(なければ-1)*/
  {
    for(int i=ptr-1;i>=0;i--)
      if(stk[i]==x)
        return i;
    return -1;
  }
  public void clear()/*スタックを空にする*/{ptr=0;}
  public int capacity()/*スタックの容量*/{return max;}
  public int size()/*スタックにあるデータ数*/{return ptr;}
  public boolean isEmpty()/*スタックは空であるか*/{return ptr<=0;}
  public boolean isFull()/*スタックは満杯であるか*/{return ptr>=max;}
  public void dump()
  {
    if(ptr<=0)
      System.out.println("スタックは空です。");
    else
    {
      for(int i=0; i<ptr; i++)
        System.out.print(stk[i] + " ");
      System.out.println();
    }

  }
}
