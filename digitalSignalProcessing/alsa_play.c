// ******************************************************************************
// * ALSA_TEST3：テスト信号発生
// 参考:コンピュータ搭載！Linuxオーディオの作り方 2018年CQ出版社刊(第9章)
// 2018,12 親子プロセスに変更 バッファを再生中に計算
// ******************************************************************************

#include <stdlib.h>
#include <stdint.h>
#include <alsa/asoundlib.h>

#include <sys/types.h>
#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>


// PCMデフォルト設定
#define DEF_CHANNEL 2
#define DEF_FS  44100
#define DEF_BITPERSAMPLE    16
#define WAVE_FORMAT_PCM 1 
#define BUF_SAMPLES 1024
#define PlayLength 240 

// Hello Audioのテスト信号設定
#include "sinewave.c"
#define N_WAVE          1024    /* dimension of Sinewave[] */
#define PI (1<<16>>1)
#define SIN(x) Sinewave[((x)>>6) & (N_WAVE-1)]
#define COS(x) SIN((x)+(PI>>1))
#define OUT_CHANNELS(ch)  ((ch)>4 ? 8 : (ch)>2 ? 4 : (ch))

void main(int argc, char *argv[]){

    //  出力デバイス
    char *device = "default";
    // ソフトSRC有効無効設定
    unsigned int soft_resample = 0;
    // ALSAのバッファ時間[usec]
    const static unsigned int latency = 50000;

    uint16_t    Channels      = DEF_CHANNEL;
    uint32_t    SamplesPerSec = DEF_FS;
    uint16_t    BlockAlign    = (DEF_BITPERSAMPLE/8) * DEF_CHANNEL;
    uint16_t    BitsPerSample = DEF_BITPERSAMPLE;

    // 符号付き16bit
    snd_pcm_format_t format = SND_PCM_FORMAT_S16;

    // テスト信号生成用
    int phase = 0;
    int inc = 256<<16;
    int dinc = 0;

    int16_t *buffer = NULL;
    int n;

    snd_pcm_t *hndl = NULL;
    

    if( argc>=2 ){ // 出力デバイスの指定
        device = argv[1];
    }
    printf("device:%s\n", device);
    
    if( argc>=3 ){ // サンプリング周波数の設定
        SamplesPerSec =  atoi(argv[2]);
    }
    printf("Sampling Frequency %d[Hz]\n", SamplesPerSec);

    if( argc>=4 ){ // Soft SRCの設定
        soft_resample = atoi(argv[3]);
    }
    printf( "Soft Resampling %s\n", (soft_resample==0) ? "OFF" : "ON" );
    
    // バッファの用意
    buffer = malloc( BUF_SAMPLES*BlockAlign );
    if( buffer==NULL ){
        printf("cannot get buffer\n");
        goto End;
    }

    // 再生用PCMストリームを開く
    if( snd_pcm_open( &hndl, device, SND_PCM_STREAM_PLAYBACK, 0) ){
        printf("Unable to open PCM\n");
        goto End;
    }

    // 再生周波数、フォーマット、バッファのサイズ等を指定する
    if( snd_pcm_set_params( hndl, format, SND_PCM_ACCESS_RW_INTERLEAVED, 
                            Channels, SamplesPerSec, soft_resample, latency) ){
        printf("Unable to set format\n");
        goto End;
    }

    int M=109;
    int16_t data0[1024];
    int16_t data1[1024];



// 親子プロセスでALSAに送って止まっている間に子プロセスに計算させる
    pid_t     pid;
    int16_t   buf0[1024], buf1[1024];
    int       pp0[2], pp1[2];
    memset( buf0, 0, 1024*2 );
    memset( buf1, 0, 1024*2 );
    memset( data0, 0, 1024*2 );
    memset( data1, 0, 1024*2 );

    // (1)パイプの作成
    pipe(pp0);
    pipe(pp1);

    pid = fork(); // (2)子プロセスの生成
    
    // 子プロセスの動き
    if( pid==0 ){
        static int count=0;
        close( pp0[0] ); // (3)読み込みディスクリプタを閉じる
        close( pp1[0] ); // (3)読み込みディスクリプタを閉じる

        FILE *fp=NULL;
        int16_t tmp[BUF_SAMPLES*Channels];
        for(int n=0; n<(PlayLength*SamplesPerSec); n+=BUF_SAMPLES ){
            switch(0){
            case 0:
                for(int j=0;j<1024;j++){
                    data0[j] =
                    data1[j] = (int16_t)(20000*sin(count*440.0*6.283185307/SamplesPerSec));
                    count++;
                }
                break;

            case 1:
                if(fp==NULL){
                    fp=fopen("test2018.wav","rb");
                    //fp=fopen("testwav.wav","rb");

                    if(fp==NULL) goto End;
                    fread( tmp, sizeof(int16_t), 1024, fp );
                }
                int res = fread( tmp, sizeof(int16_t), BUF_SAMPLES*Channels, fp );
                if(res<BUF_SAMPLES*Channels){
                    fclose(fp);
                    memset( (void*)(tmp+res), 0, sizeof(int16_t)*(BUF_SAMPLES*Channels-res) );
                }
                for(int j=0;j<1024;j++){
                    data0[j]  = tmp[j*2]*2;
                    data1[j]  = tmp[j*2+1]*2;

                    //data0[j] = data1[j]  = tmp[j*2] + tmp[j*2+1];
                }
                break;
            }

            printf("%d data0[%d]=%d\n", n, 1,data0[1]);
            printf("%d data0[%d]=%d\n", n, 1023,data0[1023]);
            printf("%d data1[%d]=%d\n", n, 1,data1[1]);
            printf("%d data1[%d]=%d\n", n, 1023,data1[1023]);

            write( pp0[1], (void *)data0, 2048 );
            write( pp1[1], (void *)data1, 2048 );

        }
        close( pp0[1] );
        close( pp1[1] );
    }

    // 親プロセスの動き
    if(pid!=0){
        int count=0;
        close( pp0[1] ); // (3)書き込みディスクリプタを閉じる
        close( pp1[1] ); // (3)書き込みディスクリプタを閉じる
        for(int n=0; n<(PlayLength*SamplesPerSec); n+=BUF_SAMPLES ){
            snd_pcm_sframes_t pcm_rslt;
            // fill the buffer
            for(int i=0; i<BUF_SAMPLES * Channels; i+=Channels ){
                int16_t val0, val1;
                val0 = buf0[count];
                val1 = buf1[count];

                count++; count%=1024;
                for(int j=0; j<Channels; j++ ){
                    buffer[i+j] = (i+j)%2? val0 : val1;
                }
            }

            // PCMの書き込み
            snd_pcm_writei( hndl, (const void*)buffer, ( (n<BUF_SAMPLES) ? n : BUF_SAMPLES));
	    read( pp0[0], (void*)buf0, 2048 ); // (4)パイプから読み込み
            read( pp1[0], (void*)buf1, 2048 ); // (4)パイプから読み込み

            printf("%d buf0[%d]=%d\n", n, 1, buf0[1]);
            printf("%d buf0[%d]=%d\n", n, 1023, buf0[1023]);
            printf("%d buf1[%d]=%d\n", n, 1, buf1[1]);
            printf("%d buf1[%d]=%d\n", n, 1023, buf1[1023]);
        }
        close( pp0[0] );
        close( pp1[0] );

    }
    snd_pcm_drain( hndl );


End:
    // 終わったらストリームを閉じる
    if( hndl!=NULL ){
        snd_pcm_close( hndl );
    }
    if( buffer!=NULL ){
        free( buffer );
    }
        
}

