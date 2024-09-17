function weather (){
	curl -s "wttr.in/$1?m1"
}

function up() {
	times=$1
	while [ "$times" -gt "0" ]; do
		cd ..
		times=$(($times - 1))
	done
}

function count() {
	total=$1
	for ((i=total; i>0; i--)); do sleep 1; printf "Time remaining $i secs \r"; done
	echo -e	 "\a"
}

function extract () {
	if [ -f $1 ] ; then
		case $1 in
			*.tar.bz2)   tar xvjf $1    ;;
			*.tar.gz)    tar xvzf $1    ;;
			*.tar.xz)    tar Jxvf $1    ;;
			*.bz2)       bunzip2 $1     ;;
			*.rar)       rar x $1       ;;
			*.gz)        gunzip $1      ;;
			*.tar)       tar xvf $1     ;;
			*.tbz2)      tar xvjf $1    ;;
			*.tgz)       tar xvzf $1    ;;
			*.zip)       unzip -d `echo $1 | sed 's/\(.*\)\.zip/\1/'` $1;;
			*.Z)         uncompress $1  ;;
			*.7z)        7z x $1        ;;
			*)           echo "don't know how to extract '$1'" ;;
		esac
	else
		echo "'$1' is not a valid file!"
	fi
}

function update () {
	if [ $USER = "root" ]
	then apt-get update && apt-get upgrade && apt-get auto-clean && apt-get autoremove
	else echo "You must be root to execute this command"
	fi
}
