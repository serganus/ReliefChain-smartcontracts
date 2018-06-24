# ReliefChain-smartcontract
ReliefChain (AngelHack SG June 2018) - C++ based EOS.IO smartcontract
### DAPP based on eos.io blockchain, solving natural disaster management issues such as distribution of rations, tracking missing people, double spending of ration and collaboration between various NGOs.

### (a) Staring private EOS blockchain 
- Download the docker
```
docker pull eosio/eos-dev
```
- Start the blockchain. You need to be careful about the path you mount to docker image. This will change from the path mentioned below, so please change else it wont work!
```
sudo docker run --name eosio -p 8888:8888 -p 9876:9876 -v /Users/gautamanand/Library/Github/serganus/ReliefChain-smartcontracts:/tmp/work -v /Users/gautamanand/Library/Github/serganus/dataEOS:/mnt/dev/data -v /Users/gautamanand/Library/Github/serganus/dataEOS:/mnt/dev/config eosio/eos-dev /bin/bash -c "nodeos -e -p eosio --plugin eosio::wallet_api_plugin --plugin eosio::wallet_plugin --plugin eosio::producer_plugin --plugin eosio::history_plugin --plugin eosio::chain_api_plugin --plugin eosio::history_api_plugin --plugin eosio::http_plugin -d /mnt/dev/data --config-dir /mnt/dev/config --http-server-address=0.0.0.0:8888 --access-control-allow-origin=* --contracts-console"
```
- Check if this works. Open the web browser, to load chain info: http://localhost:8888/v1/chain/get_info
```
sudo docker logs --tail 10 eosio
```

### (b) Compiling/Publishing/Seeding
```
docker exec -it eosio /bin/bash
cd /tmp/work
eosiocpp -o reliefchain/reliefchain.wast reliefchain/reliefchain.cpp
eosiocpp -g reliefchain/reliefchain.abi reliefchain/reliefchain.hpp
bash ./scripts/setup.sh
cleos wallet unlock --name default --password "${PASSWORD}" --unlock-timeout 36000
cleos set contract reliefchain reliefchain -p reliefchain
bash ./scripts/seed.sh
```
### (c) Data Model: Smart Contracts

![DATA MODEL](https://github.com/serganus/ReliefChain-smartcontracts/blob/master/docs/datamodel.png)

### (d) Workflow of the DAPP

![WORKFLOW](https://github.com/serganus/ReliefChain-smartcontracts/blob/master/docs/workflow.png)

### (e) Actions: Smart Contracts

![WORKFLOW](https://github.com/serganus/ReliefChain-smartcontracts/blob/master/docs/actions.png)

### (f) Tips

- Kill the docker image and delete the mounted local folder to ensure everything is working
```
docker container stop eosio
docker container prune
rm -rf /Users/gautamanand/Library/Github/serganus/dataEOS
```