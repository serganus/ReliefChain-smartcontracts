# ReliefChain-smartcontract
#### ReliefChain - C++ based EOS.IO smartcontract
### DAPP based on EOS Blockchain, solving natural disaster management issues such as enabling NGO's collaborating to act on a common action plan, minimizing the double spending of limited supplies (cloth/water/medical/shelter/volunteers), real-time updating the missing database, track status of the disaster event and post-event anaylsis for potential future.

## Problem
Natural disasters are events such as a flood, earthquake, or hurricane that causes significant damage or loss of life. In such events, often NGO's find it difficult to plan and distribute the required supplies such as food, water, shelter, clothes and medicine. The main reason for this is that NO common platform exists where all NGOs/volunteers/others can follow up on the event relief status on a real-time basis. They may find it difficult to know how much supplies are required, which other NGO's are actively helping and present status of missing people. Moreover, they have the double spending of limited rations problem.

## Solution
Our solution, ReliefChain, enables citizens to pre-register (using bio-metrics), NGOs collaboratively come together during the time of the disaster event and create a common supply inventory list where food, water, shelter/medical support, clothes and volunteer information is prepared. The volunteers coordinating with the NGOs on site can use the same platform to authenticate registered citizens (or fresh register them) and confirm supply inventory for them, updating on the disaster event page in real-time. This will ensure less wastage of supply rations and listing of missing citizens. Post-event, the platform could be used to perform analysis to provide insights on how to better plan for the next event or other major factors to be more effective.

 The main reason for using blockchain as the technology was to promote a public ledger to record missing people database (enabling friends/family to track the last location) and making NGOs transparent in terms of distribution of supplies (enabling them getting more support and improved accountability). 

## How we built it
We built it using EOS Blockchain platform, then a minimal nodejs based backend that calls the chain to perform actions written in smart contracts.

# Technology 
### (a) Staring private EOS blockchain 
- Download the docker
```
docker pull eosio/eos-dev:v1.0.2
```
- Start the blockchain. You need to be careful about the path you mount to docker image. This will change from the path mentioned below, so please change else it wont work!
```
sudo docker run --rm --name eosio -p 8888:8888 -p 9876:9876 -v /Users/gautamanand/Library/Github/serganus/ReliefChain-smartcontracts:/tmp/work -v /Users/gautamanand/Library/Github/serganus/dataEOS:/mnt/dev/data -v /Users/gautamanand/Library/Github/serganus/dataEOS:/mnt/dev/config eosio/eos-dev:v1.0.2 /bin/bash -c "nodeos -e -p eosio --plugin eosio::wallet_api_plugin --plugin eosio::wallet_plugin --plugin eosio::producer_plugin --plugin eosio::history_plugin --plugin eosio::chain_api_plugin --plugin eosio::history_api_plugin --plugin eosio::http_plugin -d /mnt/dev/data --config-dir /mnt/dev/config --http-server-address=0.0.0.0:8888 --access-control-allow-origin=* --contracts-console"
```
- Check if this works. Open the web browser, to load chain info: http://localhost:8888/v1/chain/get_info
```
sudo docker logs --tail 10 eosio
```

### (b) Compiling/Publishing/Seeding
- You can seed (5 citizens, 5 NGOs and 2 Disaster Events)
```
docker exec -it eosio /bin/bash
cd /tmp/work
bash ./scripts/seed/compile.sh
bash ./scripts/seed/setup.sh
bash ./scripts/seed/deploy.sh
bash ./scripts/seed/seed.sh
```

- You can superseed (625 citizens, 100 NGOs and 2 Disaster Events)
```
docker exec -it eosio /bin/bash
cd /tmp/work
bash ./scripts/superseed/compile.sh
bash ./scripts/superseed/setup.sh
bash ./scripts/superseed/deploy.sh
bash ./scripts/superseed/seed.sh
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
# Contact
- Interested to collaborate, reach me out on me@gautamanand.in 
