/******************************************************************************
 * ALSA_TEST1：テスト信号発生
 ******************************************************************************/

#include <stdlib.h>
#include <stdint.h>
#include <alsa/asoundlib.h>
#include <math.h>

// PCMデフォルト設定
#define DEF_CHANNEL 2
#define DEF_FS  48000
#define DEF_BITPERSAMPLE    16
#define WAVE_FORMAT_PCM 1 
#define BUF_SAMPLES 1024

// Hello Audioのテスト信号設定
#include "sinewave.c"
#define N_WAVE          1024    /* dimension of Sinewave[] */
#define PI (1<<16>>1)
#define SIN(x) Sinewave[((x)>>6) & (N_WAVE-1)]
#define COS(x) SIN((x)+(PI>>1))
#define OUT_CHANNELS(num_channels) ((num_channels) > 4 ? 8: (num_channels) > 2 ? 4: (num_channels))

void main(int argc, char *argv[])
{
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
    

    if(argc >= 2) { // 出力デバイスの指定
        device = argv[1];
    }
    printf("device:%s\n", device);
    
    if(argc >= 3) { // サンプリング周波数の設定
        SamplesPerSec =  atoi(argv[2]);
    }
    printf("Sampling Frequency %d[Hz]\n", SamplesPerSec);

    if(argc >= 4) { // Soft SRCの設定
        soft_resample = atoi(argv[3]);
    }
    printf("Soft Resampling %s\n", ((soft_resample == 0) ? "OFF" : "ON"));
    
    // バッファの用意
    buffer = malloc(BUF_SAMPLES * BlockAlign);
    if(buffer == NULL) {
        printf("cannot get buffer\n");
        goto End;
    }

    // 再生用PCMストリームを開く
    if(snd_pcm_open(&hndl, device, SND_PCM_STREAM_PLAYBACK, 0)) {
        printf("Unable to open PCM\n");
        goto End;
    }

    // 再生周波数、フォーマット、バッファのサイズ等を指定する
    if(snd_pcm_set_params(hndl, format, SND_PCM_ACCESS_RW_INTERLEAVED, Channels, SamplesPerSec, soft_resample, latency)) {
        printf("Unable to set format\n");
        goto End;
    }

    int count=0;
    for (n = 0; n < (SamplesPerSec * 10); n += BUF_SAMPLES) // 10秒間の再生
    {
        snd_pcm_sframes_t pcm_rslt;
        int i;
        
        // fill the buffer
        for (i = 0; i < BUF_SAMPLES * Channels; i += Channels) {
            int j;
            int16_t val = SIN(phase);

            phase += inc>>16;
            inc += dinc;
            if (inc>>16 < 512)
                dinc++;
            else
                dinc--;
 
//int16_t val = (int16_t)(20000*sin(6.283185307*440/SamplesPerSec*count));
//count++;count%=BUF_SAMPLES;

            for(j = 0; j < Channels; j++) {
                    buffer[i+j] = val;
            }
        }

        // PCMの書き込み
        snd_pcm_writei(hndl, (const void*)buffer, ((n < BUF_SAMPLES) ? n : BUF_SAMPLES));
    }

    // データ出力が終わったため、たまっているPCMを出力する。
    snd_pcm_drain(hndl);

End:
    // 終わったらストリームを閉じる
    if(hndl != NULL)
        snd_pcm_close(hndl);

    if(buffer != NULL)
        free(buffer);
}

