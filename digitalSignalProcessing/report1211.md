# 2018/12/11 講義のレポート(デジタル信号処理)  
17ec084平田智剛

## 1.使用機器、ソフト
・Raspberry Pi2 (ラズパイ)  
・Windows 10 Pro(パソコン)  
・VNC Viewer(リモートデスクトップソフト、VNC)

## 2.講義で行ったこと

(1)ラズパイをVNCにて遠隔操作し、音源発生プログラム(alsa_test.c)を書きこんだ。  
変数valに波形の式を代入することで、自由に音の波形を指定することができた。  
例えば次のようにすることで三角波の音を再生した。  

```C

long double f=440.0*powl(2.0,3.0/12.0);
int16_t val = (int16_t)0;
for(j=1;j<20;j++)
{
    val+=(20000/j*sin(6.283185307*f*j/SamplesPerSec*count));
}
count++;count%=BUF_SAMPLES;

            for(j = 0; j < Channels; j++) {
                    buffer[i+j] = val;
            }
        }

        // PCMの書き込み
        snd_pcm_writei(hndl, (const void*)buffer, ((n < BUF_SAMPLES) ? n : BUF_SAMPLES));
    }


```

long double型変数 f はvalに与える波形の、(基音の)周波数である。  
基準周波数ではA(ドレミファ...における「ラ」)の音が440.0[Hz]と定められている。  
また、一オクターブ(即ち12音階)上がるごとに周波数は2倍になる。  
このことより、一般に「ラ」に対してn音階上の音(n<0を許す)は次に式で表される。  

![](https://github.com/17ec084/grade2-2/blob/eb7ddaf108fc44e5743dc9b883ce4848958c8b93/digitalSignalProcessing/data/1.gif)  

今回のプログラムではn=3であるため「ラ」に対して3音階上の音、即ち「ド」の音を基音周波数とすることになる。  
またfor文を総和Σに読み替えてみると、今回格納したvalは次の数式で表される。  

![](https://github.com/17ec084/grade2-2/blob/7c4b250039197254e8c860109e412a511caf9fd2/digitalSignalProcessing/data/2.png)  

ここで、20を∞に近づけるとノコギリ波になるが、計算処理に時間がかかる都合上、20より大きい値にすることはできなかった。  

(2)プログラムをコンパイルの上、ラズパイにイヤホンを接続し、音源を再生した。  
その結果、のこぎり音に近い音が、「ド」の音階で再生された。

(3)wavファイルを再生できるプログラム(alsa_play.c)をラズパイに書き込み、(2)同様再生した。  
その結果、音楽ファイルが再生された。

## 3.吟味
・音階検知プログラムの作成方法の検討  

目的:wavファイルの音源から音階を検知し、Lチカにて音階を表示すること  
手段:単位時間ごとにフーリエ変換し、周波数成分を分析したのち、一番強い周波数を選んで音階に変換する。  
    
wavファイルを再生できるプログラム(alsa_play.c)について、出力すべき音声の波形の瞬時値を表す変数はval0、val1で、それぞれ左音声と右音声に対応する。しかし、今回は議論を簡単にするため、val1=val0を随時代入する、即ちモノラルとすることにする。  

①まず階名情報を更新する頻度を決定する。今回はバッファのサンプル数が満たされるタイミングで階名情報を計算することとする。  
alsa_play.cでは、デフォルトでのサンプリングレートが44100回/secでバッファ数が1024であるため、  
44100/1024≒43.07回/secとなる。  
プログラムには次のように加筆する。  

```C
long double FouriersPerSec = (double)SamplesPerSec/(double)BUF_SAMPLES;
```
  
②フーリエ変換する。  
val0のフーリエ変換Fval0を求めよう。  
フーリエ変換の式は  

となる。  
今回の場合、t=0～(1.0/FouriersPerSec)の間だけval0が読み込まれ、それ以外の場合常にval0=0であると考えてよいだろう。  
さらにf(t)=val0[t×SamplesPerSec]とすると  

とかける。  
区分求積法を用いると  

となる。  
ここでn=BUF_SAMPLESとすると、  

のように書けて、val0のインデックスが整数になる。  
次に、  

について考えよう。(http://www.ice.tohtech.ac.jp/~nakagawa/fourier/dft1.htm)  
オイラーの公式を用いれば  


となる。  
このことより、  

を計算した結果について、実部はcosによって、虚部はsinによって表される周波数成分となる。(http://www.ice.gunma-ct.ac.jp/~tsurumi/courses/ImagePro/No7_1.pdf)  
複素数Cを実数R倍したものは、Cの実部と虚部それぞれをR倍したものと同じなので、  


と書くことができる。  

よって、val[0]からval[BUF_SAMPLES-1]の間に周波数がfである成分が相対的にどれくらい含まれているかを調べる場合、  


を計算すればよい。(相対的な議論で構わないため、不要な定数は省略した。)  
これを周波数で積分すると  

従って、周波数がfMAXからfMINの間である成分の大きさは  

である。


以上の議論より、周波数がfMAXからfMINの間である成分の大きさは以下のような関数getPowerByFreqで計算できる。

```C
long double getPowerByFreq(long double fMAX, long double fMIN)
{
    long double power=0;
    for(int t=0; t<BUF_SAMPLES; t++)
    {
        power+=val0[t]*(sin(6.283185307*fMAX*t/SamplesPerSec)-sin(6.283185307*fMIN*t/SamplesPerSec) +cos(6.283185307*fMAX*t/SamplesPerSec)-cos(6.283185307*fMIN*t/SamplesPerSec));
    }
    return power;
}
```
後は各音階付近にfMAX,fMINを適用し、その比率から音階を判定すればよい。和音などは統計学における分散などを用いれば判断できるだろう。  
あとはこのfMAX,fMINをどのように設定するかが課題となる。









