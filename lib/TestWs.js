// Generated by CoffeeScript 1.6.3
(function() {
  var TestWs, WSC, runQuery,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  WSC = require('./WSC.js').WSC;

  runQuery = require("./pg-helper.js").runQuery;

  TestWs = (function(_super) {
    __extends(TestWs, _super);

    function TestWs(ws, Client, constring) {
      this.Client = Client;
      this.constring = constring;
      TestWs.__super__.constructor.call(this, ws);
    }

    TestWs.prototype.testWord = function(data, cb) {
      return runQuery(new this.Client(this.constring), "select * from test_word($1::varchar, $2::varchar, $3::varchar, $4::boolean)", [data.subject, data.unit, data.category, data.w_or_d], cb);
    };

    return TestWs;

  })(WSC);

  exports.TestWs = TestWs;

}).call(this);