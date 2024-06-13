const assert = require('assert');
(async function () {
    var options = {
      url: 'https://robotshop-robot-shop.apps.ocp-270003bu3k-cunn.cloud.techzone.ibm.com/product/RED',
      https:{ rejectUnauthorized: false }
    };
  
    // Send GET request
    let response = await $got.get(options);

    // Validate the response status code, it should be 200 here
    assert.ok(response && response.statusCode == 200, 'Expect 200');
})();