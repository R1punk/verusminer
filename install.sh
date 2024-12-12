read -p $'\e[0m\e[1;96mMasukan Nama Worker : ' wor;
read -p $'\e[0m\e[1;96mMasukan Wallet : ' wal;
apt install libjansson build-essential clang binutils -y
cp /data/data/com.termux/files/usr/include/linux/sysctl.h /data/data/com.termux/files/usr/include/sys
cd .. && git clone https://github.com/Darktron/ccminer.git && cd ccminer && chmod +x build.sh configure.sh autogen.sh start.sh && CXX=clang++ CC=clang ./build.sh && rm config.json

echo -e '''
{
    "pools":
        [{
            "name": "US-VIPOR",
            "url": "stratum+tcp://us.vipor.net:5040",
            "timeout": 180,
            "disabled": 1
        },
        {
            "name": "USSE-VIPOR",
            "url": "stratum+tcp://usse.vipor.net:5040",
            "timeout": 180,
            "disabled": 1
        },
        {
            "name": "NA-LUCKPOOL",
            "url": "stratum+tcp://ap.luckpool.net:3956",
            "timeout": 180,
            "disabled": 0
        },
        {
            "name": "AIH-LOW",
            "url": "stratum+tcp://verus.aninterestinghole.xyz:9998",
            "timeout": 180,
            "disabled": 1
        },
        {
            "name": "WW-ZERGPOOL",
            "url": "stratum+tcp://verushash.mine.zergpool.com:3300",
            "timeout": 180,
            "disabled": 1
        }],

    "user": "$wal.$wor",
    "pass": "",
    "algo": "verus",
    "threads": 8,
    "cpu-priority": 1,
    "cpu-affinity": -1,
    "retry-pause": 10,
    "api-allow": "192.168.0.0/16",
    "api-bind": "0.0.0.0:4068"
}''' >> config.json
mv config.json /data/data/com.termux/files/home/ccminer/
