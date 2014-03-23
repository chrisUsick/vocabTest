// Generated by CoffeeScript 1.6.3
(function() {
  var SelectCategory, WSC, runQuery,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  WSC = require('./WSC.js').WSC;

  runQuery = require("./pg-helper.js").runQuery;

  SelectCategory = (function(_super) {
    __extends(SelectCategory, _super);

    function SelectCategory(ws, Client, constring) {
      this.Client = Client;
      this.constring = constring;
      SelectCategory.__super__.constructor.call(this, ws);
    }

    SelectCategory.prototype.subjectList = function(data, cb) {
      return runQuery(new this.Client(this.constring), "select name from subjects", null, cb);
    };

    SelectCategory.prototype.unitList = function(data, cb) {
      return runQuery(new this.Client(this.constring), "select * from unit_list('" + data + "')", null, cb);
    };

    SelectCategory.prototype.categoryList = function(data, cb) {
      return runQuery(new this.Client(this.constring), "select * from categories;", null, cb);
    };

    return SelectCategory;

  })(WSC);

  exports.SelectCategory = SelectCategory;

}).call(this);