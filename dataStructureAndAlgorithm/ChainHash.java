public class ChainHash<K,V>
//チェーン法を利用してハッシュ表を作る
{
    class Node<K,V>//ノード(線形リストの各要素)を定義
    {
        private K key;//キー値
        private V data;//データ
        private Node<K,V> next;//後続ノードへの参照
    

        Node(K key, V data, Node<K,V> next)//コンストラクタ
        {
            this.key = key;
            this.data = data;
            this.next = next;
        }

        K getKey()//キーを返す
        {
            return key;
        }

        V getValue()//データを返す
        {
            return data;
        }
        public int hashCode()
        //キーを強制的に数値(以下「キー数値」)化したものを返す
        {
            return key.hashCode();
        }
    }
    private int size;//ハッシュ表の大きさ
    private Node<K,V>[] table;//ハッシュ表

    public ChainHash(int capacity)//コンストラクタ
    {
        try//とりあえずやってみる
        {
            table = new Node[capacity];//ハッシュ表の実体
            this.size = capacity;
        }
        catch(OutOfMemoryError e)
        //tryした結果、OutOfMMemoryErrorが発生したときに実行する
        {
            this.size = 0;
        }
    }

    public int hashValue(Object key)//キーのハッシュ値を求める
    {
        return key.hashCode() % size;
    }

    public V search(K key)//指定されたキーに対応するデータを探し出すメソッド
    {
        Node<K,V> p= table[hashValue(key)];
        /*
        ハッシュ表を左右、線形リストを上下で表現すると、
        与えられたキーに対応するデータが格納されている場合、左右方向は確実に
        table[hashValue(key)]となる。
        言い方を変えると、対応するデータがあるのなら、
        それはpつまりtable[hashValue(key)]の真下にあるデータなはずなのである。
        */
        while(p != null)
        /*pを一つずつ真下にしていく。これをnullつまり一番下になるまで繰り返す*/
        {
            if(p.getKey().equals(key))
            /*
            p.getKey.hashCode()==key.hashCode()
            と同じ。
            pのキー数値と与えられたキーのキー数値が一致するか調べている。
            ただし、return key.hashCode()があるので、
            p.equals(key)としてもよかったはずである。(？)
            */
            {
                return p.getValue();
                //探索成功。データを返す。
            }
            p = p.next;//真下を探す。
        }
        return null;//探索失敗
    }

    public int add(K key, V data)//ノードを追加するメソッド
    {
        Node<K,V> p= table[hashValue(key)];
        while(p != null)
        {
            if(p.getKey().equals(key))
        {
            return 1;
        }
        p = p.next;//真下を探す。
        }
        Node<K,V> temp = new Node<K,V>(key, data, table[hashValue(key)]);
        /*
        tempという、線形リストの要素(ノード)を作る。
        keyとdataは、メソッドに与えられた通り。
        nextは、table[hashValue(key)]と書いてあるが、
        実際にはtable[hashValue(key)]に格納された値、即ち「現段階での
        (tempを追加する前の)」線形リストの先頭ノードへの参照が格納される。
        */
        table[hashValue(key)]=temp;
        /*tempは、線形リストの一番上(即ち先頭ノード)に追加する。*/
        return 0;

    }

    public int remove(K key)//ノードを削除するメソッド
    {
        int hash = hashValue(key);//削除するデータのハッシュ値
        Node<K,V> p = table[hash];//着目するノード
        Node<K,V> pp=null;//前回の着目ノード
        while(p != null)//一番下まで繰り返す
        {
            if(p.getKey().equals(key))//見つけたら
            {
                if(pp==null)//一番上に見つかったのなら
                /*
                ppがnullであるということは、
                『ppが一度も「前回のp」になったことがない』
                ということを必ず意味する。
                これは、ppにnullを代入する処理が、一番最初にしか存在しないこと
                からも確認できる。
                */
                table[hash]=p.next;//一番上を削除する
                /*
                目的:一番最初を削除する。
                手段:「2番目に上」だったものを1番上に移動させる
                */
                else//一番最初以外で見つけたのなら
                pp.next=p.next;
                //「前の次(＝今)のノード」=「今の次(＝次)のノード」
                /*
                目的:対象のキーを削除する
                手段: 「次のノード」だったものを「今のノード」に移動させる
                */
                return 0;//remove完了
            }//まだ見つけていないのなら
            pp=p;//「前の着目ノード」を「着目ノード」にして
            p=p.next;//「着目ノード」を次のノードにする
        }//一番下まで探したけど見つからなかったなら
        return 1;//そのキー値は存在しない。

    }

    public void dump()//ハッシュ表と線形リストをまとめて表示
    {
        for(int i=0; i<size; i++)//ハッシュ表の大きさだけ繰り返す
        {
            Node<K,V>p=table[i];
            System.out.printf("%02d  ",i);//整形のため書式指定。printf
            while(p != null)
            {
                System.out.printf("→ %s (%s)",p.getKey(),p.getValue());
                p = p.next;
            }
            System.out.println();
        }

    }

}
