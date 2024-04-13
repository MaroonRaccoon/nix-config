cd /tmp/gp_whisper
&& export LC_NUMERIC='C'
&& sox --norm=-3 rec.wav norm.wav 
&& t=$(sox 'norm.wav' -n channels 1 stats 2>&1 | grep 'RMS lev dB' | sed -e 's/.* //' | awk '{print $1* 1.75}')
&& sox -q norm.wav -C 196.5 final.mp3 silence -l 1 0.05 $t'dB' -1 1.0 $t'dB' pad 0.1 0.1 tempo 1.75
&& curl --max-time 20 https://api.openai.com/v1/audio/transcriptions -s -H "Authorization: Bearer `cat /home/mapa/.openai-api-key`" -H "Content-Type: multipart/form-data" -F model="whisper-1" -F language="en" -F file="@final.mp3" -F response_format="json"
