#include <reliefchain.hpp>
#include <eosiolib/asset.hpp>
#include <eosiolib/action.hpp>
#include <iostream>
#include <stdio.h>      /* printf, scanf, puts, NULL */
#include <time.h>       /* time */

using namespace std;
using namespace eosio;
using eosio::permission_level;

void reliefchain::addngo (const account_name    account,
                   const string&         ngo_name,
                   const asset&         ngo_bal,
                   uint32_t              totalvolunteers,
                   uint32_t              activevolunteers) {

  require_auth (account);

  ngo_table ngo(_self, _self);

  auto itr = ngo.find(account);
  eosio_assert(itr == ngo.end(), "ngo already exists");

  ngo.emplace(account, [&](auto& t) {
    t.account         = account;
    t.ngo_name        = ngo_name;
    t.ngo_bal        = ngo_bal;
    t.totalvolunteers        = totalvolunteers;
    t.activevolunteers       = activevolunteers;
  });

  print (name{account}, " ngo created.");
}

void reliefchain::addcitizen (const account_name    account,
                   const string&         citizen_name,
                   const asset&         citizen_bal,
                   bool              isvolunteer,
                   const string&        statusLiving) {

  require_auth (account);

  citizen_table citizen(_self, _self);

  auto itr = citizen.find(account);
  eosio_assert(itr == citizen.end(), "citizen already exists");

  citizen.emplace(account, [&](auto& t) {
    t.account         = account;
    t.citizen_name        = citizen_name;
    t.citizen_bal        = citizen_bal;
    t.isvolunteer        = isvolunteer;
    t.statusLiving        = statusLiving;
  });

  print (name{account}, " citizen created.");
}

void reliefchain::adddisaster (const account_name    account,
                   const string&         disaster_name,
                   const asset&         disaster_bal,
                   bool              statusEvent,
                   uint32_t              totalfoodsupplies,
                   uint32_t              usedfoodsupplies,
                   uint32_t              totalclothessupplies,
                   uint32_t              usedclothessupplies,
                   uint32_t              totalwatersupplies,
                   uint32_t              usedwatersupplies,
                   uint32_t              totalsheltersupplies,
                   uint32_t              usedsheltersupplies,
                   uint32_t              totalmedicalsupplies,
                   uint32_t              usedmedicalsupplies,
                   uint32_t              activevolunteers,
                   uint32_t              reliefedcitizens) {

  require_auth (account);

  disaster_table disaster(_self, _self);

  auto itr = disaster.find(account);
  eosio_assert(itr == disaster.end(), "disaster event already exists");

  disaster.emplace(account, [&](auto& t) {
    t.account         = account;
    t.disaster_name        = disaster_name;
    t.disaster_bal        = disaster_bal;
    t.statusEvent        = statusEvent;
    t.totalfoodsupplies        = totalfoodsupplies;
    t.usedfoodsupplies        = usedfoodsupplies;
    t.totalclothessupplies        = totalclothessupplies;
    t.usedclothessupplies        = usedclothessupplies;
    t.totalwatersupplies        = totalwatersupplies;
    t.usedwatersupplies        = usedwatersupplies;
    t.totalsheltersupplies        = totalsheltersupplies;
    t.usedsheltersupplies        = usedsheltersupplies;
    t.totalmedicalsupplies        = totalmedicalsupplies;
    t.usedmedicalsupplies        = usedmedicalsupplies;
    t.activevolunteers        = activevolunteers;
    t.reliefedcitizens        = reliefedcitizens;
  });

  print (name{account}, " disaster event created.");
}


void reliefchain::verifycits (const account_name    citizen_account,
                   const account_name    disaster_account,
                   uint32_t              usedfoodsupplies,
                   uint32_t              usedclothessupplies,
                   uint32_t              usedwatersupplies,
                   uint32_t              usedsheltersupplies,
                   uint32_t              usedmedicalsupplies,
                   const string&        statusLiving) {

  require_auth (disaster_account);

  //Check if disaster exists
  disaster_table disaster(_self, _self);
  auto itr = disaster.find(disaster_account);
  eosio_assert(itr != disaster.end(), "disaster not found");

  //Check if citizen exists
  citizen_table citizen(_self, _self);
  auto itr2 = citizen.find(citizen_account);
  eosio_assert(itr2 != citizen.end(), "citizen not found");

  disaster.modify(itr, disaster_account, [&](auto& t) {
    t.account         = disaster_account;
    t.usedfoodsupplies        = usedfoodsupplies;
    t.usedclothessupplies        = usedclothessupplies;
    t.usedwatersupplies        = usedwatersupplies;
    t.usedsheltersupplies       = usedsheltersupplies;
    t.usedmedicalsupplies    = usedmedicalsupplies;
  });

  citizen.modify(itr2, citizen_account, [&](auto& t) {
    t.account         = citizen_account;
    t.statusLiving         = statusLiving;
  });

  print (name{disaster_account}, " disaster updated.");
  print (name{citizen_account}, " citizen status updated.");

}

