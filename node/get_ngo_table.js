var request = require("request");

var options = { method: 'POST',
  url: 'http://127.0.0.1:8888/v1/chain/get_table_rows',
  body: 
   { code: 'reliefchain',
     table: 'ngo',
     json: 'true' },
  json: true };

request(options, function (error, response, body) {
  if (error) throw new Error(error);

  console.log(body);
});