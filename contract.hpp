#include <eosiolib/eosio.hpp>
#include <eosiolib/asset.hpp>
#include <eosiolib/print.hpp>

#include <string>

using namespace eosio;
using eosio::asset;
using std::string;

class reliefchain: public contract {
public:
  reliefchain(account_name self) : contract (self) {}

  // @abi action addngo
  void addngo (const account_name    account,
                   const string&         ngo_name,
                   const asset&         ngo_bal,
                   uint32_t              totalvolunteers,
                   uint32_t              activevolunteers);

  // @abi action addcitizen
  void addcitizen (const account_name    account,
                   const string&         citizen_name,
                   const asset&         citizen_bal,
                   bool              isvolunteer,
                   bool              statusLiving);

  // @abi action adddisaster
  void adddisaster (const account_name    account,
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
                   uint32_t              reliefedcitizens);
private:

    // @abi table ngo i64
    struct ngo {
      account_name    account;
      asset           ngo_bal;
      string          ngo_name;
      uint32_t        totalvolunteers;
      uint32_t        activevolunteers;

      account_name primary_key() const { return account; }

      EOSLIB_SERIALIZE(ngo, (account)(ngo_name)(ngo_bal)(totalvolunteers)(activevolunteers))
    };

    typedef eosio::multi_index<N(ngo), ngo> ngo_table;

    // @abi table citizen i64
    struct citizen {
      account_name    account;
      asset           citizen_bal;
      string          citizen_name;
      bool        isvolunteer;
      bool        statusLiving;

      account_name primary_key() const { return account; }

      EOSLIB_SERIALIZE(citizen, (account)(citizen_name)(citizen_bal)(isvolunteer)(statusLiving))
    };

    typedef eosio::multi_index<N(citizen), citizen> citizen_table;

    // @abi table disaster i64
    struct disaster {
      account_name    account;
      asset           disaster_bal;
      string          disaster_name;
      bool        statusEvent;
      uint32_t        totalfoodsupplies;
      uint32_t        usedfoodsupplies;
      uint32_t        totalclothessupplies;
      uint32_t        usedclothessupplies;
      uint32_t        totalwatersupplies;
      uint32_t        usedwatersupplies;
      uint32_t        totalsheltersupplies;
      uint32_t        usedsheltersupplies;
      uint32_t        totalmedicalsupplies;
      uint32_t        usedmedicalsupplies;
      uint32_t        totalvolunteers;
      uint32_t        activevolunteers;
      uint32_t        reliefedcitizens;

      account_name primary_key() const { return account; }

      EOSLIB_SERIALIZE(disaster, (account)(disaster_name)(disaster_bal)(statusEvent)(totalfoodsupplies)(usedfoodsupplies)(totalclothessupplies)(usedclothessupplies)(totalwatersupplies)(usedwatersupplies)(totalsheltersupplies)(usedsheltersupplies)(totalmedicalsupplies)(usedmedicalsupplies)(totalvolunteers)(activevolunteers)(reliefedcitizens))
    };

    typedef eosio::multi_index<N(disaster), disaster> disaster_table;
};

EOSIO_ABI(reliefchain, (addngo)(addcitizen)(adddisaster))
