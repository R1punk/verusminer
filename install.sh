# Update & install dependencies
yes | pkg update -y
yes | pkg upgrade -y
yes | pkg install libjansson build-essential clang binutils git -y

# Hapus folder ccminer lama jika ada
if [ -d "$HOME/ccminer" ]; then
    echo "[!] Menghapus folder ccminer lama..."
    rm -rf ~/ccminer
fi

# Clone repo ccminer
echo "[*] Meng-clone repo ccminer..."
cp /data/data/com.termux/files/usr/include/linux/sysctl.h /data/data/com.termux/files/usr/include/sys
git clone https://github.com/Darktron/ccminer ~/ccminer

cd ~/ccminer

# Beri izin eksekusi pada script build
chmod +x build.sh configure.sh autogen.sh start.sh

# Build ccminer dengan clang
echo "[*] Membuild ccminer..."
CXX=clang++ CC=clang ./build.sh

# Pilihan pool
echo ""
echo "=== Pilih Pool Mining ==="
echo "1) Luckpool (ap.luckpool.net:3956)"
echo "2) Vipor (sg.vipor.net:5040)"
read -p "Masukkan pilihan (1/2): " POOL_CHOICE

if [ "$POOL_CHOICE" = "1" ]; then
    POOL_NAME="LUCKPOOL"
    POOL_URL="stratum+tcp://ap.luckpool.net:3956"
elif [ "$POOL_CHOICE" = "2" ]; then
    POOL_NAME="VIPOR"
    POOL_URL="stratum+tcp://sg.vipor.net:5040"
else
    echo "[!] Pilihan tidak valid, default ke Luckpool"
    POOL_NAME="LUCKPOOL"
    POOL_URL="stratum+tcp://ap.luckpool.net:3956"
fi

# Minta input wallet dan worker ke user
read -p "Masukkan wallet address: " WALLET
read -p "Masukkan worker name: " WORKER

# Tulis ulang config.json sesuai pilihan pool
cat > config.json <<EOF
{
    "pools": [
        {
            "name": "${POOL_NAME}",
            "url": "${POOL_URL}",
            "timeout": 180,
            "disabled": 0
        }
    ],
    "user": "${WALLET}.${WORKER}",
    "pass": "x",
    "algo": "verus",
    "threads": 4,
    "cpu-priority": 2,
    "cpu-affinity": -1,
    "retry-pause": 10,
    "api-allow": "192.168.0.0/16",
    "api-bind": "0.0.0.0:4068"
}
EOF

# Aktifkan wakelock agar mining tidak terganggu saat layar mati
termux-wake-lock

# Update bash.bashrc agar auto start bersih dan tidak dobel
BASHRC_PATH="$PREFIX/etc/bash.bashrc"
sed -i '/termux-wake-lock/d' $BASHRC_PATH
sed -i '/cd ~\/ccminer && .\/start.sh/d' $BASHRC_PATH

# Tambahkan baris auto-start terbaru
echo -e "\ntermux-wake-lock\ncd ~/ccminer && ./start.sh" >> $BASHRC_PATH

echo "[✓] Setup selesai! Miner sudah di-build dan akan auto start saat Termux dibuka."
echo "Untuk mulai sekarang, jalankan:"
echo "cd ~/ccminer && ./start.sh"
