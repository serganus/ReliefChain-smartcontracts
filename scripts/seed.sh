#!/bin/sh

# (11) SEED DATA TO BLOCKCHAIN - Calling Actions (Mimicing remote Nodejs API, but we use command-line API for the timebeing)
# (11.1) Adding new citizens ~600
add_new_citizen() {
	# Creating multiple citizens (mocking registeration)
	cleos push action reliefchain addcitizen "[\"$1\", \"$2\", $3, $4]" -p "$1"
}

# account_name,  citizen_name,  isvolunteer,  statusLiving
add_new_citizen "c1" "c1" 0 "missing"
add_new_citizen "c2" "c2" 0 "alive"
add_new_citizen "c3" "c3" 0 "dead"
add_new_citizen "c4" "c4" 0 "alive"
add_new_citizen "c5" "c5" 0 "missing"

# (11.2) Adding new ngos ~5
add_new_ngo() {
	cleos push action reliefchain addngo "[\"$1\", \"$2\", $3, $4]" -p "$1"
}
# Add 5 ngo
# account_name, ngo_name, totalvolunteers, activevolunteers
add_new_ngo "ngo1" "ngo1" 100 5
add_new_ngo "ngo2" "ngo2" 200 50
add_new_ngo "ngo3" "ngo3" 400 59
add_new_ngo "ngo4" "ngo4" 500 60
add_new_ngo "ngo5" "ngo5" 600 65

# (11.3) Adding new diasters ~2
add_new_disaster() {
	cleos push action reliefchain adddisaster "[\"$1\", \"$2\", $3, $4, $5, $6, $7, $8, $9]" -p "$1"
}
# Add 2 disaster
add_new_disaster "disaster1" "disaster1" 10000 90 5000 420 1000 900 10
add_new_disaster "disaster2" "disaster2" 10000 90 5000 420 1000 900 10