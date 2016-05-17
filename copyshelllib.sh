#!/bin/bash
#
DEST=/mnt/sysroot
#设置移植的目的地
libcp() {
  LIBPATH=`dirname ${1}`
  [ ! -d $DEST$LIBPATH ] && mkdir -p $DEST$LIBPATH
  [ ! -e $DEST${1} ] && cp $1 $DEST$LIBPATH && echo "copy lib $1 finished."
}
bincp() {
  CMDPATH=`dirname ${1}`
  [ ! -d $DEST$CMDPATH ] && mkdir -p $DEST$CMDPATH
  [ ! -e $DEST${1} ] && cp $1 $DEST$CMDPATH
  for LIB in  `ldd $1 | grep -o "/lib64.*" | awk '{print $1}'`; do
    libcp $LIB
  done
}
read -p "Your command: " CMD
until [ $CMD == 'q' ]; do
   ! which $CMD && echo "Wrong command" && read -p "Input again:" CMD && continue
  COMMAND=`which $CMD | grep -v "alias" | awk '{print $1}'`
  bincp $COMMAND
  echo "copy $COMMAND finished."
  read -p "Continue: " CMD
done
