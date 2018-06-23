#!/bin/sh

# (1) Setting the alias inside the docker container
alias cleos='docker exec eosio /opt/eosio/bin/cleos --wallet-url http://localhost:8888'
alias eosiocpp='docker exec eosio eosiocpp'

# (2) Creating the wallet password and saving a JSON file
WALLET_PASSWORD=$(cleos wallet create | tail -n 1)
echo "\"wallet_password\" : \"$WALLET_PASSWORD\"," >> keyfile.json

# (3) Unlock the wallet for 3600 seconds
cleos wallet unlock --password ${WALLET_PASSWORD} --unlock-timeout 36000

# (4) Setting variables and creating OWNER account and Relating private keys inside the wallet, when its unlocked
OWNER_ACCOUNT_KEY_PAIR=$(cleos create key |  grep -oE "[^:]+$")
OWNER_ACCOUNT_KEY_PAIR_ARR=($OWNER_ACCOUNT_KEY_PAIR)
OWNER_ACCOUNT_PRIVATE_KEY=${OWNER_ACCOUNT_KEY_PAIR_ARR[0]}
OWNER_ACCOUNT_PUBLIC_KEY=${OWNER_ACCOUNT_KEY_PAIR_ARR[1]}

OWNER_ACTIVE_KEY_PAIR=$(cleos create key |  grep -oE "[^:]+$")
OWNER_ACTIVE_KEY_PAIR_ARR=($OWNER_ACTIVE_KEY_PAIR)
OWNER_ACTIVE_PRIVATE_KEY=${OWNER_ACTIVE_KEY_PAIR_ARR[0]}
OWNER_ACTIVE_PUBLIC_KEY=${OWNER_ACTIVE_KEY_PAIR_ARR[1]}

cleos wallet import ${OWNER_ACCOUNT_PRIVATE_KEY}
cleos wallet import ${OWNER_ACTIVE_PRIVATE_KEY}

# (5) Creating TESTACC account and Relating private keys inside the wallet, when its unlocked

TESTACC_OWNER_KEY_PAIR=$(cleos create key |  grep -oE "[^:]+$")
TESTACC_OWNER_KEY_PAIR_ARR=($TESTACC_OWNER_KEY_PAIR)
TESTACC_OWNER_PRIVATE_KEY=${OWNER_ACCOUNT_KEY_PAIR_ARR[0]}
TESTACC_OWNER_PUBLIC_KEY=${OWNER_ACCOUNT_KEY_PAIR_ARR[1]}

TESTACC_ACTIVE_KEY_PAIR=$(cleos create key |  grep -oE "[^:]+$")
TESTACC_ACTIVE_KEY_PAIR_ARR=($TESTACC_ACTIVE_KEY_PAIR)
TESTACC_ACTIVE_PRIVATE_KEY=${TESTACC_ACTIVE_KEY_PAIR_ARR[0]}
TESTACC_ACTIVE_PUBLIC_KEY=${TESTACC_ACTIVE_KEY_PAIR_ARR[1]}

cleos wallet import ${TESTACC_ACTIVE_PRIVATE_KEY}
cleos wallet import ${TESTACC_OWNER_PRIVATE_KEY}
cleos create account eosio testacc ${TESTACC_OWNER_PUBLIC_KEY} ${TESTACC_ACTIVE_PUBLIC_KEY}

# (6) Create keys, add keys to wallet, create new account 
add_new_account() {
	echo "Creating account for user: $1" 
	OWNER_KEY_PAIR=$(cleos create key |  grep -oE "[^:]+$")
	OWNER_KEY_PAIR_ARR=($OWNER_KEY_PAIR)
	OWNER_PRIVATE_KEY=${OWNER_KEY_PAIR_ARR[0]}
	OWNER_PUBLIC_KEY=${OWNER_KEY_PAIR_ARR[1]}

	ACTIVE_KEY_PAIR=$(cleos create key |  grep -oE "[^:]+$")
	ACTIVE_KEY_PAIR_ARR=($ACTIVE_KEY_PAIR)
	ACTIVE_PRIVATE_KEY=${ACTIVE_KEY_PAIR_ARR[0]}
	ACTIVE_PUBLIC_KEY=${ACTIVE_KEY_PAIR_ARR[1]}

	echo "\""$1"\" : \""$OWNER_PRIVATE_KEY"\"," >> keyfile.json

	cleos wallet import ${OWNER_PRIVATE_KEY}
	cleos wallet import ${ACTIVE_PRIVATE_KEY}
	cleos create account eosio "$1" ${OWNER_PUBLIC_KEY} ${ACTIVE_PUBLIC_KEY}
	cleos push action eosio updateauth "{\"account\":\"$1\",\"permission\":\"active\",\"parent\":\"owner\",\"auth\":{\"keys\":[{\"key\":\"${OWNER_PUBLIC_KEY}\", \"weight\":1}],\"threshold\":1,\"accounts\":[{\"permission\":{\"actor\":\"eosio.token\",\"permission\":\"eosio.code\"},\"weight\":1}],\"waits\":[]}}" -p $1
}

# (7) Add more smart contract accounts
add_new_account "eosio.token"
add_new_account "reliefchain"

# (8) Compile the Smart Contracts (cpp) as web-assembly file (wasm and wast)
SMART_CONTRACT_NAME="reliefchain"
# Warning: Change this to your local path else this script wont work!!!!!
SMART_CONTRACT_PATH="/Users/gautamanand/Library/Github/serganus/ReliefChain-smartcontracts"
eosiocpp -o ${SMART_CONTRACT_PATH}/${SMART_CONTRACT_NAME}.wasm ${SMART_CONTRACT_PATH}/${SMART_CONTRACT_NAME}.cpp

# (9) Compile the Smart Contracts (hpp) as web-assembly file (wasm and wast)
eosiocpp -g ${SMART_CONTRACT_PATH}/${SMART_CONTRACT_NAME}.abi ${SMART_CONTRACT_PATH}/${SMART_CONTRACT_NAME}.hpp

# (10) Deploy smart contract to the private blockchain
cleos set contract eosio.token contracts/eosio.token -p eosio.token
cleos set contract ${SMART_CONTRACT_NAME} ${SMART_CONTRACT_PATH}/${SMART_CONTRACT_NAME} -p ${SMART_CONTRACT_NAME}
# issuign a lot of tokens in the private blockchain in case we have a usecase to transfer from one action to another
cleos push action eosio.token create '{"issuer":"eosio", "maximum_supply":"1000000000.0000 DDL"}' -p eosio.token


# (11) SEED DATA TO BLOCKCHAIN - Calling Actions (Mimicing remote Nodejs API, but we use command-line API for the timebeing)
# (11.1) Adding new citizens ~600
SMART_CONTRACT_FUNCTION_ADDCITIZEN="addcitizen"
add_new_citizen() {
	# Creating multiple citizens (mocking registeration)
	cleos push action ${SMART_CONTRACT_NAME} ${SMART_CONTRACT_FUNCTION_ADDCITIZEN} "[\"$1\", \"$2\", $3, $4, $5]" -p "$1"
	# Air-dropping 100 DDL (This has no use-case in the POC but this is show how we can link tokens with smart contract)
	cleos push action eosio.token issue "[ \"$1\", \"100.0000 DDL\", \"airdrop\" ]" -p eosio
}
# Add 5^4 = 625 citizen accounts
for n1 in {1..5}
do
	for n2 in {1..5}
	do
		for n3 in {1..2}
		do
			for n4 in {1..2}
			do			
				add_new_account "c"$n1$n2$n3$n4
				                # account_name,  citizen_name,  citizen_bal,  isvolunteer,  statusLiving
				add_new_citizen "c"$n1$n2$n3$n4 "c"$n1$n2$n3$n4 "\"100 DDL\"" 0 "unknown"
			done
		done
	done
done

# (11.2) Adding new ngos ~5
SMART_CONTRACT_FUNCTION_ADDNGO="addngo"
add_new_ngo() {
	cleos push action ${SMART_CONTRACT_NAME} ${SMART_CONTRACT_FUNCTION_ADDNGO} "[\"$1\", \"$2\", \"100.0000 HAK\", $4, $5]" -p "$1"
}
# Add 5 ngo
for number in {1..5} 
do
	add_new_account "ngo"$number
done
# Add 5 ngo
# account_name, ngo_name, ngo_bal, totalvolunteers, activevolunteers
add_new_ngo "ngo1" "ngo1" "100 DDL" 100 5
add_new_ngo "ngo2" "ngo2" "100 DDL" 200 50
add_new_ngo "ngo3" "ngo3" "100 DDL" 400 59
add_new_ngo "ngo4" "ngo4" "100 DDL" 500 60
add_new_ngo "ngo5" "ngo5" "100 DDL" 600 65

# (11.3) Adding new diasters ~2
SMART_CONTRACT_FUNCTION_ADDDISASTER="adddisaster"
add_new_disaster() {
	cleos push action ${SMART_CONTRACT_NAME} ${SMART_CONTRACT_FUNCTION_ADDDISASTER} "[\"$1\", \"$2\", \"100.0000 HAK\", $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16]" -p "$1"
}
# Add 2 disaster
for number in {1..2} 
do
	add_new_account "disaster"$number
done
# Add 2 disaster
# account_name, disaster_name, disaster_bal, statusEvent, totalfoodsupplies, usedfoodsupplies, totalclothessupplies, 
# usedclothessupplies, totalwatersupplies, usedwatersupplies, totalsheltersupplies, usedsheltersupplies, totalmedicalsupplies,
# usedmedicalsupplies, activevolunteers, reliefedcitizens
add_new_disaster "disaster1" "Katrina Hurricane (City1)" "100 DDL" 0 10000 90 5000 420 1000 900 10 1 10000 8800 900 500
add_new_disaster "disaster2" "Earthquake (City2)" "100 DDL" 1 20000 17000 50000 40020 18000 9300 100 88 90000 78800 9320 50000
