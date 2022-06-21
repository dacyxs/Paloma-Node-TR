#!/bin/bash
#cuzdan adiniz
WALLET="dacxys"
ADDRESS="$(palomad keys show $WALLET -a)"
JSON=$(jq -n --arg addr "$ADDRESS" '{"denom":"ugrain","address":$addr}')
#bahsis vermek isteyenler icin benim validator adresi
TIP_ADDR=paloma1vuetxm85ffy69zm6357sf643evcwhd94xeu6wl
#asagiya kendi validator adresinizi girin
VALIDATOR=paloma1vuetxm85ffy69zm6357sf643evcwhd94xeu6wl

    
while :
do	
	curl -X POST --header "Content-Type: application/json" --data "$JSON" https://backend.faucet.palomaswap.com/claim	
	palomad query bank balances --node tcp://testnet.palomaswap.com:26657 "$ADDRESS"
	#Bahsis vermek istemiyorsaniz asagidaki satiri kapatabilir/kaldirabilirsiniz
	palomad tx staking delegate "$TIP_ADDR" -y  5000ugrain --from "$WALLET" --chain-id paloma-testnet-5 --fees 5000ugrain
	palomad tx staking delegate "$VALIDATOR" -y  985000ugrain --from "$WALLET" --chain-id paloma-testnet-5 --fees 5000ugrain
	sleep 3600
done
