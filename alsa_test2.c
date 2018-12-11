/******************************************************************************
 * ALSA_TEST2：WAVEファイル/PCM再生
 ******************************************************************************/

#include <stdlib.h>
#include <stdint.h>
#include <alsa/asoundlib.h>

// PCMデフォルト設定
#define DEF_CHANNEL 2
#define DEF_FS      48000
#define DEF_BITPERSAMPLE    16 
#define WAVE_FORMAT_PCM 1
#define BUF_SAMPLES 1024

int main(int argc, char *argv[])
{
    //  出力デバイス
    char *device = "default";
    // ソフトSRC有効無効設定
    unsigned int soft_resample = 0;
    // ALSAのバッファ時間[msec]
    const static unsigned int latency = 50000;

    // PCM 情報, waveformatexを使用
    struct WAVEFORMATEX{
        uint16_t        wFormatTag;         // format type 
        uint16_t        nChannels;          // number of channels (i.e. mono, stereo...)
        uint32_t       nSamplesPerSec;     // sample rate
        uint32_t       nAvgBytesPerSec;    // for buffer estimation
        uint16_t        nBlockAlign;        // block size of data
        uint16_t        wBitsPerSample;     // number of bits per sample of mono data
        uint16_t        cbSize;             // the count in bytes of the size of extra information (after cbSize)
    } wf = { WAVE_FORMAT_PCM,   // PCM
             DEF_CHANNEL,
             DEF_FS,
             DEF_FS * DEF_CHANNEL * (DEF_BITPERSAMPLE/8),
             (DEF_BITPERSAMPLE/8) * DEF_CHANNEL,
             DEF_BITPERSAMPLE,
             0};
    //WAVファイルのchunk
    struct CHUNK {
        char ID[4];     // Kind of chunk, should be "RIFF")
        uint32_t    Size;   // Chunk size;
    } Chunk;

    char    FormatTag[4];
    const char ID_RIFF[4] = "RIFF";
    const char ID_WAVE[4] = "WAVE";
    const char ID_FMT[4]  = "fmt ";
    const char ID_DATA[4] = "data";

    // 符号付き16bit
    static snd_pcm_format_t format = SND_PCM_FORMAT_S16;

    int16_t *buffer = NULL;
    int n;
    FILE *fp = NULL;

    snd_pcm_t *hndl = NULL;
    

    if(argc >= 2) { // 出力デバイスの指定
        device = argv[1];
    }
    printf("device:%s\n", device);
    
    if(argc >= 3) { // Soft SRCの設定
        soft_resample = atoi(argv[2]);
    }
    printf("Soft Resampling %s\n", ((soft_resample == 0) ? "OFF" : "ON"));

    if(argc >= 4) { // wavファイル
        if((fp = fopen(argv[3], "rb")) == NULL) {
            printf("Open error:%s\n", argv[3]);
            goto End;
        }
        else {  // wavファイルの解析
            // check RIFF
            if(fread(&Chunk, sizeof(Chunk), 1, fp) != 1 || strncmp(Chunk.ID, ID_RIFF, 4) != 0) {
                printf("not RIFF Format %s\n", argv[3]);
                goto End;
            }

            // check waveformat
            if(fread(FormatTag, 1, 4, fp) != 4 || strncmp(FormatTag, ID_WAVE, 4) != 0){
                printf("not wave file %s\n", argv[3]);
                goto End;
            }
            
            // search chunks
            while(fread(&Chunk, sizeof(Chunk), 1, fp) == 1) {
                if(strncmp(Chunk.ID, ID_FMT, 4) == 0) { // WAVEFORMATEX
                    fread(&wf, (sizeof(wf) < Chunk.Size) ? sizeof(wf) : Chunk.Size, 1, fp);
                    if(wf.wFormatTag != WAVE_FORMAT_PCM)
                    {
                        printf("not PCM\n", argv[3]);
                        goto End;
                    }
                }
                else if(strncmp(Chunk.ID, ID_DATA, 4) == 0) // PCMデータのロケーション
                    break;
            };
            
            if(strncmp(Chunk.ID, ID_DATA, 4) != 0) {    //一応DATA Chunkか再チェック
                printf("no PCM data %s\n", argv[3]);
                goto End;
            }
        }
    }
    else
    {
        printf("no file specified\n");
        goto End;
    }

    // PCMフォーマットの確認と情報出力を行う
    printf("format : PCM, nChannels = %d, SamplePerSec = %d, BitsPerSample = %d\n",
            wf.nChannels, wf.nSamplesPerSec, wf.wBitsPerSample);
    format = SND_PCM_FORMAT_S16_LE;


    // バッファの用意
    buffer = malloc(BUF_SAMPLES * wf.nBlockAlign);
    if(buffer == NULL){
        printf("cannot get buffer\n");
        goto End;
    }

    // 再生用PCMストリームを開く
    if(snd_pcm_open(&hndl, device, SND_PCM_STREAM_PLAYBACK, 0)) {
        printf( "Unable to open PCM\n" );
        goto End;
    }
    // 再生周波数、フォーマット、バッファのサイズ等を指定する
    if(snd_pcm_set_params( hndl, format, SND_PCM_ACCESS_RW_INTERLEAVED, wf.nChannels, wf.nSamplesPerSec, soft_resample, latency)) {
        printf( "Unable to set format\n" );
        goto End;
    }

    for (n = 0; n < Chunk.Size; n += BUF_SAMPLES * wf.nBlockAlign) {
        snd_pcm_sframes_t pcm_rslt;

        fread(buffer, wf.nBlockAlign, BUF_SAMPLES, fp); // PCMのread

        // PCMの書き込み
        snd_pcm_writei(hndl, (const void*)buffer, ((n < BUF_SAMPLES) ? n : BUF_SAMPLES));
    }

    // データ出力が終わったため、たまっているPCMを出力する。
    snd_pcm_drain( hndl );

End:
    // 終わったらストリームを閉じる
    if(hndl != NULL)
        snd_pcm_close(hndl);

    if(fp != NULL)
        fclose(fp);
    
    if(buffer != NULL)
        free(buffer);
}


