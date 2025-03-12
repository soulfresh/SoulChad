# GIT
alias gst='git status'
alias gstsh='git stash'
# stash unstaged changes
alias gstshus='git stash --keep-index -u'
# stash staged changes
alias gstshs='git stash --staged'

# PATH HELPER
alias path='echo -e ${PATH//:/\\n}'

# Audio
# Must be in directory
alias mp32wav='for mp3 in ./*.mp3; do ffmpeg -i "$mp3" -acodec pcm_s16le -ac 1 -ar 16000 "${$(basename $mp3)}".wav; done'
alias m4a2wav='for mp3 in ./*.m4a; do ffmpeg -i "$mp3" -acodec pcm_s16le -ac 1 -ar 16000 "${$(basename $mp3)}".wav; done'
alias wav2mp3='for wav in ./*.wav; do ffmpeg -i "$wav" -q:a 0 "${$(basename $wav)}".mp3; done'
alias aif2mp3='for wav in ./*.aif; do ffmpeg -i "$wav" -q:a 0 "${$(basename $wav)}".mp3; done'
alias wav2m4a='for wav in ./*.wav; do ffmpeg -i "$wav" -codec:a aac "${$(basename $wav)}".m4a; done'
alias wav2aif='for wav in ./*.wav; do ffmpeg -i "$wav" -codec:a pcm_s16le "${$(basename $wav)}".aif; done'
alias wav2ogg='for wav in ./*.wav; do ffmpeg -i "$wav" -codec:a libvorbis "${$(basename $wav)}".ogg; done'

# Restart coreaudiod if Focusrite Saffire Pro 40 is not working
alias restartaudio='sudo kill `ps -ax | grep "coreaudiod" | grep "sbin" | awk "{print $1}"`'

# Vim Config
alias useYadr='ln -snf ~/.yadr/vim ~/.vim; ln -snf ~/.yadr/vimrc ~/.vimrc'
# git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1
alias useNvChad='ln -snf ~/Development/dotfiles/NvChad ~/.config/nvim'
alias unlinkVim='rm ~/.vim ~/.vimrc'
