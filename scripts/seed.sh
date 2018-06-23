#!/bin/sh

SMART_CONTRACT_NAME="reliefchain"
# (11) SEED DATA TO BLOCKCHAIN - Calling Actions (Mimicing remote Nodejs API, but we use command-line API for the timebeing)
# (11.1) Adding new citizens ~600
SMART_CONTRACT_FUNCTION_ADDCITIZEN="addcitizen"
add_new_citizen() {
	# Creating multiple citizens (mocking registeration)
	cleos push action ${SMART_CONTRACT_NAME} ${SMART_CONTRACT_FUNCTION_ADDCITIZEN} "[\"$1\", \"$2\", $3, $4, $5]" -p "$1"
}

# account_name,  citizen_name,  citizen_bal,  isvolunteer,  statusLiving
add_new_citizen "c1" "c1" "\"100 DDL\"" 0 "unknown"
add_new_citizen "c2" "c2" "\"100 DDL\"" 0 "unknown"
add_new_citizen "c3" "c3" "\"100 DDL\"" 0 "unknown"
add_new_citizen "c4" "c4" "\"100 DDL\"" 0 "unknown"
add_new_citizen "c5" "c5" "\"100 DDL\"" 0 "unknown"

# (11.2) Adding new ngos ~5
SMART_CONTRACT_FUNCTION_ADDNGO="addngo"
add_new_ngo() {
	cleos push action ${SMART_CONTRACT_NAME} ${SMART_CONTRACT_FUNCTION_ADDNGO} "[\"$1\", \"$2\", \"100.0000 DDL\", $4, $5]" -p "$1"
}
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
	cleos push action ${SMART_CONTRACT_NAME} ${SMART_CONTRACT_FUNCTION_ADDDISASTER} "[\"$1\", \"$2\", \"100.0000 DDL\", $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16]" -p "$1"
}
# Add 2 disaster
# account_name, disaster_name, disaster_bal, statusEvent, totalfoodsupplies, usedfoodsupplies, totalclothessupplies, 
# usedclothessupplies, totalwatersupplies, usedwatersupplies, totalsheltersupplies, usedsheltersupplies, totalmedicalsupplies,
# usedmedicalsupplies, activevolunteers, reliefedcitizens
add_new_disaster "disaster1" "Katrina Hurricane (City1)" "100 DDL" 0 10000 90 5000 420 1000 900 10 1 10000 8800 900 500
add_new_disaster "disaster2" "Earthquake (City2)" "100 DDL" 1 20000 17000 50000 40020 18000 9300 100 88 90000 78800 9320 50000