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
PEERS="ce2724d2606345049e656fbccabe597af3bccc77@38.242.246.230:26656,bd5570cd42f43cf2695fc6285b55b8b28dfe4edd@38.242.246.224:26656,9fc5c7ff19a4b855b3f662996c95e0e0b14abe25@38.242.246.227:26656,9e6301e23b1661fc59e5cd8a09f11370bcb3404f@38.242.246.231:26656,3ca66c8805dedeea64100bc2ce4c49ac71979e6b@38.242.246.228:26656,41a896277ddf0ee88fa19be93fee62b9ffaa9d28@185.244.181.27:26656,bc8466af250d1e662aa565af47daf833a9629419@159.223.201.45:26656,84e71eff48b4188ef9971c8dadfb9bae2c49e405@152.70.79.67:26656,271d472618e15794a570ec105232910f18ea2de5@188.166.12.124:26656,7edc49e0bf6c6dee827c3a3a6d8df88b612d612d@35.203.66.107:26656,907a6725451d4a890360d91febc049cb78ee0a52@144.91.101.46:36416,f4ca35f06f6abb573bba1c18bfa886f3fde51ae3@80.93.19.96:26656,18da4f4cdc6f3da24138c97e3f0156da4079e20e@65.108.140.101:40656,c792fe6d673360e039c74cd0387884975ddc87da@93.186.200.35:10656,98b112892325872a2ca883afe84d1ad1eb47e13f@154.53.39.182:26656,3bd6035cd2d551a04b2fb897ac362f366acb4b65@45.55.34.66:26656,2af5498ebd7feb5b7b22f51f3649c4c358041c86@128.199.127.179:10656,4e2b1bf7d32da06b42a038d207418f5c9fe16e26@176.126.87.119:26656,6cc4e54bd7a309b4a244ba17aa3d5444a5d2a85a@178.128.51.108:26656,790e895c0ee260b6de66c2b4fa251b4abb7ab5e0@109.238.12.51:26656,a23615206c7f7efc8764164ca75e2b12b9af2031@151.106.8.63:26656,8b56b1d81fa74aeee0423846c4e0e01650dce8e9@137.184.3.67:26656,54aa04dbb56a7ecd50d66abac73c1e61d7928986@38.242.241.167:26656,10c78db5701cbdc30bc4c8ba6f76fd5d5d7df1c5@38.242.212.92:26656,c3fcc1086ec62bbd912cc9fc717f10f24f9df4c6@52.180.137.238:10656,260668797b681c9f099cbe5cbbada9f9e26bcc75@178.18.254.164:26656,fc79567d309705e073fca2e766b93625fa10583a@162.55.234.234:26656,b159364b4e6a3036c36ef6c7c690c5fbc81fa9c4@65.108.71.92:54056,187950523148c1d4c50e215de37d145be48acd15@161.35.234.64:26656,542d60dd2b126b9fee343c52a90fc357556dcd9f@46.228.199.8:26656,b3a183f1cfeec653e3c8507ae9bf7fb7dddc0bdd@144.91.83.185:26656,eb778b77af0c275de975b58902489d1af78d4372@194.163.141.18:26656,8badecc97fefd966267f55337b27be2116274a08@86.32.74.154:26656,f2ccba8389e722f7dfe0c5abefb0f4832f71103f@65.21.146.122:26656,0c0eaabdb333fb5e142d95c389763cb5ba414e47@20.2.83.71:10656,c5d2cb94bea42d4f0189ff55b3eba0199448e5b5@38.242.246.229:26656"
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

