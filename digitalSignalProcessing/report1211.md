# 2018/12/11 講義のレポート(デジタル信号処理)  
17ec084平田智剛

## 1.講義で行ったこと

(1)ラズパイをVNC及びTera Termにて遠隔操作し、音源発生プログラムを書きこんだ。  
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

Sum



(2)ラズパイにイヤホンを接続し、音源を再生した。


## 2.吟味

