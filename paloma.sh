#!/bin/bash
exists()
{
  command -v "$1" >/dev/null 2>&1
}
if exists curl; then
echo ''
else
  sudo apt update && sudo apt install curl -y < "/dev/null"
fi
bash_profile=$HOME/.bash_profile
if [ -f "$bash_profile" ]; then
    . $HOME/.bash_profile
fi
sleep 1 && curl -s https://databox.acadao.org/logo.sh | bash && sleep 1

# set vars
if [ ! $NODENAME ]; then
	read -p "Node Isminiz: " NODENAME
	echo 'export NODENAME='$NODENAME >> $HOME/.bash_profile
fi
PALOMA_PORT=26657
if [ ! $WALLET]; then
	read -p "Wallet isminiz: " WALLET
	echo 'export WALLET='$WALLET >> $HOME/.bash_profile
fi

echo "export PALOMA_CHAIN_ID=paloma-testnet-5" >> $HOME/.bash_profile
echo "export PALOMA_PORT=${PALOMA_PORT}" >> $HOME/.bash_profile
echo "export PALOMA_RPC=tcp://localhost:${PALOMA_PORT}" >> $HOME/.bash_profile
source $HOME/.bash_profile

echo '================================================='
echo -e "Node isminiz: \e[1m\e[32m$NODENAME\e[0m"
echo -e "Cuzdan isminiz: \e[1m\e[32m$WALLET\e[0m"
echo -e "Zincir id: \e[1m\e[32mpaloma-testnet-5\e[0m"
echo -e "Calisma Portu: \e[1m\e[32m$PALOMA_PORT\e[0m"
echo '================================================='
sleep 2

echo -e "\e[1m\e[32m1. Guncelleme... \e[0m" && sleep 1
# update
sudo apt update && sudo apt upgrade -y

echo -e "\e[1m\e[32m2. Kutuphaneler... \e[0m" && sleep 1
# packages
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y

# install go
ver="1.18.2"
cd $HOME
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
source ~/.bash_profile
go version

echo -e "\e[1m\e[32m3. Ayarlamalar... \e[0m" && sleep 1
# download binary
wget -O - https://github.com/palomachain/paloma/releases/download/v0.2.1-prealpha/paloma_0.2.1-prealpha_Linux_x86_64v3.tar.gz | \
sudo tar -C /usr/local/bin -xvzf - palomad
sudo chmod +x /usr/local/bin/palomad
sudo wget -P /usr/lib https://github.com/CosmWasm/wasmvm/raw/main/api/libwasmvm.x86_64.so

# config
palomad config chain-id paloma-testnet-5
palomad config keyring-backend test

# init
palomad init $NODENAME --chain-id paloma-testnet-5

# download genesis and addrbook
wget -O ~/.paloma/config/genesis.json https://raw.githubusercontent.com/palomachain/testnet/master/paloma-testnet-5/genesis.json
wget -O ~/.paloma/config/addrbook.json https://raw.githubusercontent.com/palomachain/testnet/master/paloma-testnet-5/addrbook.json

# set peers and seeds
SEEDS=""
PEERS="197bb0ada870c3a0592ee391b7825073a235d165@135.125.5.48:54056,f64dd167410a242c993648faa6406edf74a7f4b7@157.245.76.119:26656,175ccd9b448390664ea121427aab20138cc8fcec@134.209.166.5:26656,3a06e1d98f831963a09a16561c4125e4eec5ed06@195.3.223.33:30656,d34b9902e676956095f6bece29c46a65b0ec99ed@207.180.218.143:26656,30d92940f03052f942401165689b2e70e041fc8e@167.235.243.186:26656,02c92c5ebd44822d26dc88f6e1a333cf692cf802@95.31.16.222:26656,8e365511d7cd078ae8f0acf771dc3642f6eaa077@20.127.7.19:36416,0f4411c257bfe7bf191c2c3fd32b385a363487cf@167.71.247.34:26656,fae84ec72a6f686d76096053e0532a65b69e5228@143.198.169.111:26656,a70cab8943a70171272d62e6e3e2eaf704b9693c@149.102.148.127:26656,f5fd79e1086ebd5503e0ab19314746a7b1b8e220@144.91.77.189:36776,7980e25d5a9f8370969676808e4be7244b5d6a67@134.209.95.202:26656,cbef1c2d365c1b087e22e5d1c3ebdd10250e34d2@159.65.14.48:26656,dcc02e5e4e9aa8bec92a27bb148a20232d913420@5.161.111.18:26656,fd12957ba333022359b5a7c2285aa158ae6af04c@195.201.235.194:26656,92cbddc9bd34904b2044d640c5da1c6da4b81877@194.163.169.166:26656,14ca25ab5cfdc7a28b6600e4ac64303035e4e65a@54.193.147.0:26656,5af8117a3b45f9611a910954735367f867530825@46.228.199.8:26656,8ec7f59d20d2155d3b0f7b09b4762248ce84f04e@74.220.22.51:26656,8bbe63d166c3c09241ba93464449e4b8009d17eb@20.240.51.154:26656,949f02a722f1d1bbb254091c77a4837df392717a@165.232.130.3:26656,c9b64b1f2e305c8f406801af891592ff1141a77d@161.97.73.185:26656,e756146a910dadb75deaed8a6dc2491fe6fe3677@143.198.179.94:26656,03d507609c6cb48998d8bd7e9c612324bcc6ff87@188.166.168.176:36416,89b9f4fed146b01044dc9f72ead13c6537367cbd@20.102.99.251:26656,a6fb5aaabe1170c5b3d3a654502e77701fdde2e4@207.244.237.70:26656,120be42c0d9061ae7ade4445159034b496240f76@20.114.129.135:26656,78b6d4fbc0ac6c4b9c0e10659ae669766d785855@65.21.151.93:26656"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.paloma/config/config.toml


# disable indexing
indexer="null"
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.paloma/config/config.toml

# config pruning
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="50"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.paloma/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.paloma/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.paloma/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.paloma/config/app.toml

# set minimum gas price
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0grain\"/" $HOME/.paloma/config/app.toml

# enable prometheus
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.paloma/config/config.toml

# reset
palomad tendermint unsafe-reset-all

echo -e "\e[1m\e[32m4. Servis Ayarlamasi... \e[0m" && sleep 1
# create service
sudo tee /etc/systemd/system/palomad.service > /dev/null <<EOF
[Unit]
Description=paloma
After=network-online.target

[Service]
User=$USER
ExecStart=$(which palomad) start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

# start service
sudo systemctl daemon-reload
sudo systemctl enable palomad
sudo systemctl restart palomad
systemctl restart systemd-journald


echo 'Kurulum Tamamlandi' 
echo -e 'Loglara bakmak icin: \e[1m\e[32mjournalctl -u palomad -f -o cat\e[0m' 
echo -e "Statusa bakmak icin: \e[1m\e[32mcurl -s localhost:${PALOMA_PORT}/status | jq .result.sync_info\e[0m"

