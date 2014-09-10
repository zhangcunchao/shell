#!/bin/bash                                                                                                                                                                       

#遍历指定文件夹

function ch_ff(){
        cd "$1"
        for file in *
                do  
                        if [ -f $file ]
                        then
                                echo `pwd`'/'$file
                        fi  
                        if [ -d $file ]
                        then
                                (ch_ff "$PWD/$file")
                        fi  
                done
}

ch_ff $1


#!/bin/bash

#遍历脚本所在的目录文件夹

function ch_ff(){
	cd "$1"
	for file in *
		do
			if [ -f $file ]
			then
				echo "$PWD/$file"
			fi
			if [ -d $file ]
			then
				(ch_ff "$PWD/$file")
			fi
		done
}
path=`dirname $0`"/"
ch_ff $path