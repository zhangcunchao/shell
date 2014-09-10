!/bin/bash                                                                                                                                                                       

#遍历文件夹

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