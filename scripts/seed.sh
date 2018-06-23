#!/bin/sh

SMART_CONTRACT_NAME="reliefchain"
# (11) SEED DATA TO BLOCKCHAIN - Calling Actions (Mimicing remote Nodejs API, but we use command-line API for the timebeing)
# (11.1) Adding new citizens ~600
SMART_CONTRACT_FUNCTION_ADDCITIZEN="addcitizen"
add_new_citizen() {
	# Creating multiple citizens (mocking registeration)
	cleos push action ${SMART_CONTRACT_NAME} ${SMART_CONTRACT_FUNCTION_ADDCITIZEN} "[\"$1\", \"$2\", $3, $4, $5]" -p "$1"
}

# account_name,  citizen_name,  isvolunteer,  statusLiving
add_new_citizen "c1" "c1" 0 "unknown"
add_new_citizen "c2" "c2" 0 "unknown"
add_new_citizen "c3" "c3" 0 "unknown"
add_new_citizen "c4" "c4" 0 "unknown"
add_new_citizen "c5" "c5" 0 "unknown"

# (11.2) Adding new ngos ~5
SMART_CONTRACT_FUNCTION_ADDNGO="addngo"
add_new_ngo() {
	cleos push action ${SMART_CONTRACT_NAME} ${SMART_CONTRACT_FUNCTION_ADDNGO} "[\"$1\", \"$2\", $3, $4]" -p "$1"
}
# Add 5 ngo
# account_name, ngo_name, totalvolunteers, activevolunteers
add_new_ngo "ngo1" "ngo1" 100 5
add_new_ngo "ngo2" "ngo2" 200 50
add_new_ngo "ngo3" "ngo3" 400 59
add_new_ngo "ngo4" "ngo4" 500 60
add_new_ngo "ngo5" "ngo5" 600 65

# (11.3) Adding new diasters ~2
SMART_CONTRACT_FUNCTION_ADDDISASTER="adddisaster"
add_new_disaster() {
	cleos push action ${SMART_CONTRACT_NAME} ${SMART_CONTRACT_FUNCTION_ADDDISASTER} "[\"$1\", \"$2\", $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15]" -p "$1"
}
# Add 2 disaster
add_new_disaster "event1" "event1" 0 10000 90 5000 420 1000 900 10 1 10000 8800 900 500
add_new_disaster "event2" "event2" 1 10000 90 5000 420 1000 900 10 1 10000 8800 900 500

