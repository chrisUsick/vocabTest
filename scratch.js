// Generated by CoffeeScript 1.6.3
(function() {
  var Static, inst2, instance;

  Static = (function() {
    function Static() {}

    Static.count = 0;

    Static.prototype.constuctor = function(prop1) {
      this.prop1 = prop1;
      return this.count = this.count + 1;
    };

    Static.prototype.instanceMethod = function(foo, bar) {
      var i, _i, _results;
      this.count = this.count + 1;
      _results = [];
      for (i = _i = 1; _i <= 10; i = ++_i) {
        _results.push(foo + bar + i);
      }
      return _results;
    };

    Static.staticMethod = function() {
      return this.count;
    };

    return Static;

  })();

  instance = new Static('foo');

  console.log(instance.instanceMethod('hellow', 'orld'));

  console.log(Static.staticMethod());

  inst2 = new Static('bar');

  console.log(Static.staticMethod());

  console.log(Static.count);

}).call(this);
