#!/bin/sh

# (9) SEED DATA TO BLOCKCHAIN - Calling Actions (Mimicing remote Nodejs API, but we use command-line API for the timebeing)
# (9.1) Adding new citizens ~600
add_new_citizen() {
	# Creating multiple citizens (mocking registeration)
	cleos push action reliefchain addcitizen "[\"$1\", \"$2\", $3, $4]" -p "$1"
}

# account_name,  citizen_name,  isvolunteer,  statusLiving
for n1 in {1..5}
do
	for n2 in {1..5}
	do
		for n3 in {1..5}
		do
			for n4 in {1..5}
			do			
				add_new_citizen "citizen"$n1$n2$n3$n4 "citizen"$n1$n2$n3$n4 0 "missing"
			done
		done
	done
done

# (9.2) Adding new ngos ~5
add_new_ngo() {
	cleos push action reliefchain addngo "[\"$1\", \"$2\", $3, $4]" -p "$1"
}
# Add 5 ngo
# account_name, ngo_name, totalvolunteers, activevolunteers
for m1 in {1..5}
do
	for m2 in {1..5}
	do
		for m3 in {1..2}
		do
			for m4 in {1..2}
			do			
				add_new_ngo "ngo"$m1$m2$m3$m4 "ngo"$m1$m2$m3$m4 "$((RANDOM%100))" "$((RANDOM%100))"
			done
		done
	done
done

# (9.3) Adding new diasters ~2
add_new_disaster() {
	cleos push action reliefchain adddisaster "[\"$1\", \"$2\", $3, $4, $5, $6, $7, $8, $9]" -p "$1"
}
# Add 2 disaster
add_new_disaster "disaster1" "disaster1" 10000 90 5000 420 1000 900 10
add_new_disaster "disaster2" "disaster2" 10000 90 5000 420 1000 900 10