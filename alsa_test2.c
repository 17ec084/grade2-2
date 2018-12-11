/******************************************************************************
 * ALSA_TEST2�FWAVE�t�@�C��/PCM�Đ�
 ******************************************************************************/

#include <stdlib.h>
#include <stdint.h>
#include <alsa/asoundlib.h>

// PCM�f�t�H���g�ݒ�
#define DEF_CHANNEL 2
#define DEF_FS      48000
#define DEF_BITPERSAMPLE    16 
#define WAVE_FORMAT_PCM 1
#define BUF_SAMPLES 1024

int main(int argc, char *argv[])
{
    //  �o�̓f�o�C�X
    char *device = "default";
    // �\�t�gSRC�L�������ݒ�
    unsigned int soft_resample = 0;
    // ALSA�̃o�b�t�@����[msec]
    const static unsigned int latency = 50000;

    // PCM ���, waveformatex���g�p
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
    //WAV�t�@�C����chunk
    struct CHUNK {
        char ID[4];     // Kind of chunk, should be "RIFF")
        uint32_t    Size;   // Chunk size;
    } Chunk;

    char    FormatTag[4];
    const char ID_RIFF[4] = "RIFF";
    const char ID_WAVE[4] = "WAVE";
    const char ID_FMT[4]  = "fmt ";
    const char ID_DATA[4] = "data";

    // �����t��16bit
    static snd_pcm_format_t format = SND_PCM_FORMAT_S16;

    int16_t *buffer = NULL;
    int n;
    FILE *fp = NULL;

    snd_pcm_t *hndl = NULL;
    

    if(argc >= 2) { // �o�̓f�o�C�X�̎w��
        device = argv[1];
    }
    printf("device:%s\n", device);
    
    if(argc >= 3) { // Soft SRC�̐ݒ�
        soft_resample = atoi(argv[2]);
    }
    printf("Soft Resampling %s\n", ((soft_resample == 0) ? "OFF" : "ON"));

    if(argc >= 4) { // wav�t�@�C��
        if((fp = fopen(argv[3], "rb")) == NULL) {
            printf("Open error:%s\n", argv[3]);
            goto End;
        }
        else {  // wav�t�@�C���̉��
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
                else if(strncmp(Chunk.ID, ID_DATA, 4) == 0) // PCM�f�[�^�̃��P�[�V����
                    break;
            };
            
            if(strncmp(Chunk.ID, ID_DATA, 4) != 0) {    //�ꉞDATA Chunk���ă`�F�b�N
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

    // PCM�t�H�[�}�b�g�̊m�F�Ə��o�͂��s��
    printf("format : PCM, nChannels = %d, SamplePerSec = %d, BitsPerSample = %d\n",
            wf.nChannels, wf.nSamplesPerSec, wf.wBitsPerSample);
    format = SND_PCM_FORMAT_S16_LE;


    // �o�b�t�@�̗p��
    buffer = malloc(BUF_SAMPLES * wf.nBlockAlign);
    if(buffer == NULL){
        printf("cannot get buffer\n");
        goto End;
    }

    // �Đ��pPCM�X�g���[�����J��
    if(snd_pcm_open(&hndl, device, SND_PCM_STREAM_PLAYBACK, 0)) {
        printf( "Unable to open PCM\n" );
        goto End;
    }
    // �Đ����g���A�t�H�[�}�b�g�A�o�b�t�@�̃T�C�Y�����w�肷��
    if(snd_pcm_set_params( hndl, format, SND_PCM_ACCESS_RW_INTERLEAVED, wf.nChannels, wf.nSamplesPerSec, soft_resample, latency)) {
        printf( "Unable to set format\n" );
        goto End;
    }

    for (n = 0; n < Chunk.Size; n += BUF_SAMPLES * wf.nBlockAlign) {
        snd_pcm_sframes_t pcm_rslt;

        fread(buffer, wf.nBlockAlign, BUF_SAMPLES, fp); // PCM��read

        // PCM�̏�������
        snd_pcm_writei(hndl, (const void*)buffer, ((n < BUF_SAMPLES) ? n : BUF_SAMPLES));
    }

    // �f�[�^�o�͂��I��������߁A���܂��Ă���PCM���o�͂���B
    snd_pcm_drain( hndl );

End:
    // �I�������X�g���[�������
    if(hndl != NULL)
        snd_pcm_close(hndl);

    if(fp != NULL)
        fclose(fp);
    
    if(buffer != NULL)
        free(buffer);
}


