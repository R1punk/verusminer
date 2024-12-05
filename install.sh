apt install libjansson build-essential clang binutils -y
cp /data/data/com.termux/files/usr/include/linux/sysctl.h /data/data/com.termux/files/usr/include/sys
git clone https://github.com/Darktron/ccminer.git && cd ccminer && chmod +x build.sh configure.sh autogen.sh start.sh && CXX=clang++ CC=clang ./build.sh 
