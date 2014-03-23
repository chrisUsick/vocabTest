// Generated by CoffeeScript 1.6.3
(function() {
  var IndexWs, WSC, runQuery,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  WSC = require('./WSC.js').WSC;

  runQuery = require("./pg-helper.js").runQuery;

  IndexWs = (function(_super) {
    __extends(IndexWs, _super);

    function IndexWs(ws, Client, constring) {
      this.Client = Client;
      this.constring = constring;
      IndexWs.__super__.constructor.call(this, ws);
    }

    IndexWs.prototype.addWord = function(data, cb) {
      return runQuery(new this.Client(this.constring), "select * from add_word($1, $2, $3, $4, $5)", [data.word, data.def, data.subject, data.unit, data.category], cb);
    };

    IndexWs.prototype.delWord = function(data, cb) {
      console.log("delete word with id " + data.id);
      return runQuery(new this.Client(this.constring), "select * from del_word($1)", [data.id], cb);
    };

    IndexWs.prototype.wordList = function(data, cb) {
      console.log(data.ses, 'from IndexWs.wordList()');
      return runQuery(new this.Client(this.constring), "select * from word_view", null, cb);
    };

    return IndexWs;

  })(WSC);

  exports.IndexWs = IndexWs;

}).call(this);