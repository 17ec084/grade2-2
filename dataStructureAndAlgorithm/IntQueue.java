public class IntQueue
{
  private int max;//キューの容量
  private int front;//先頭要素のカーソル
  private int rear;//末尾要素のカーソル
  private int num;//現在のデータ数
  private int[] que;//キューの本体
  public class EmptyIntQueueException extends RuntimeException
  {
    public EmptyIntQueueException(){}
  }
  public class OverflowIntQueueException extends RuntimeException
  {
    public OverflowIntQueueException(){}
  }

  public IntQueue(int capacity)
  {
    num=front=rear=0;
    max=capacity;
    try
    {
      que = new int[max];
    }
    catch(OutOfMemoryError e)
    {
      max=0;
    }

  }
  public int enque(int x)throws OverflowIntQueueException
  /*エンキュー*/
  {
    if(num>=max)//データ数が容量以上なら
      throw new OverflowIntQueueException();//例外を投げる
    que[rear++]=x;//末尾にxを追加してから末尾のポインタを一つ後ろへ。
    num++;//当然、データ数も増える
    if(rear==max)//末尾のポインタが「最後の次」に来たら
    /*最後のポインタはmax-1であり、maxではないことに注意。
    これは前者が0オリジンであり、数える数(＝自然数)が1オリジンで
    あることに起因する。このことにより、maxは「最後の次」である。*/
      rear=0;//「最初」と解釈しなおす。(これがリングバッファである。)
    return x;
  } 
  public int deque()throws EmptyIntQueueException
  /*デキュー*/
  {
    if(num<=0) 
      throw new EmptyIntQueueException();
    int x=que[front++];//先頭の要素をxに格納してから先頭のポインタを一つ後ろへ。
    num--;//当然、データ数も減る
    if(front==max)//末尾のポインタが「最後の次」に来たら
      rear=0;//「最初」と解釈しなおす。
    return x;
  } 
  public int peek()throws EmptyIntQueueException
  /*ピーク*/
  {
    if(num<=0) 
      throw new EmptyIntQueueException();
    return que[front];
  }
  public int indexOf(int x)/*xの場所(なければ-1)を返す*/
  {
    for(int i=0;i<num;i++)
    {
      int idx=(i+front)%max;
      /*このようにすると、frontのポインタがどこであろうと、
      リングバッファ全体をくまなく探せる*/
      if(que[idx]==x)//あったら
        return idx;//それを返すし
    }
    return -1;//なければ-1を返す。

  }
  public void clear()/*キューを空にする*/{num=front=rear=0;}
  public int capacity()/*キューの容量*/{return max;}
  public int size()/*キューにあるデータ数*/{return num;}
  public boolean isEmpty()/*キューは空であるか*/{return num<=0;}
  public boolean isFull()/*キューは満杯であるか*/{return num>=max;}
  public void dump()
  {
    if(num<=0)
      System.out.println("キューは空です。");
    else
    {
      for(int i=0;i<num;i++)
        System.out.print(que[(i+front)%max]+" ");
        //こうすると、frontからリングバッファを一周できる
      System.out.println();
    }
  }
}
