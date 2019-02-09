function fish_prompt
      set_color 00cc66
      date "+%T"
      set -l git_branch (git branch ^/dev/null | sed -n '/\* /s///p')
      set_color FF0
      echo (pwd) '> '{"$git_branch"}'' 
      set_color yellow
end

# these functions ("*-build" functions) are for dev work. Run them to 
# run a docker container and build/test your code
function c-build
    docker run -i -t --mount src=(pwd),target=/code,type=bind --rm c-container ./build.sh
end

function python-build
    docker run -it --mount src=(pwd),target=/code,type=bind --rm python-container sh build.sh
end

function golang-build
    docker run -it --mount src=(pwd),target=/code,type=bind --rm golang-container sh build.sh
end

# replaces the linux rm command. Now when you rm something it gets moved
# to the ~/.trash/ dir. If you do `rm -f` it will actually delete it
function rm
    if contains -- -f $argv
        echo "rm -rf $argv"
        /bin/rm -rf $argv
    else
        for i in $argv;
            echo "~/.trash/$i"
            mv $i ~/.trash/$i;
        end
    end
end

alias battery-check='upower -i /org/freedesktop/UPower/devices/battery_BAT0'

#bup and bdown change the brightness, i.e:
#bup 5555
#bdown 4444
alias bup='sudo echo $1 > /sys/class/backlight/intel_backlight/brightness'
alias bdown='sudo echo $1 > /sys/class/backlight/intel_backlight/brightness'
