// Generated by CoffeeScript 1.6.3
(function() {
  var addCategory, addSubject, addUnit, addWords, delWord, getUnits, host, makeWordList, pageLoad, updateWord, ws;

  addWords = function() {
    var data, form;
    form = '#addWords';
    data = {
      word: $(form + ' input#word').val(),
      def: $(form + ' input#def').val(),
      subject: $(form + ' select#subject').val(),
      category: $(form + ' select#category').val(),
      unit: $(form + ' #unit').val()
    };
    console.log('sending word: ', data);
    return ws.send(JSON.stringify({
      request: 'addWord',
      data: data
    }));
  };

  addSubject = function(s) {
    return $('#addWords #subject').append("<option>" + s.name + "</option>");
  };

  addCategory = function(c) {
    return $('#category').append("<option>" + c.name + "</option>");
  };

  pageLoad = function() {
    ws.send(JSON.stringify({
      request: 'subjectList'
    }));
    ws.send(JSON.stringify({
      request: 'categoryList'
    }));
    ws.send(JSON.stringify({
      request: 'wordList'
    }));
    return console.log(document.cookie, 'cookies');
  };

  makeWordList = function(wd) {
    var mvc, obj, style, view;
    view = '\
		<div data-bind="id=id">\
		<input contenteditable="true" data-bind="word"/> - \
		<input contenteditable="true" data-bind="def"/> - \
		<span data-bind="subject"/> - \
		<span data-bind="unit"/> - \
		<span data-bind="category"/> -\
		<span id="delete">delete</span>\
\
		</div>\
	';
    style = '\
	';
    mvc = $$(wd, {
      format: view,
      style: style
    }, {
      'change *': function(e) {
        return updateWord(this.model.get());
      },
      'click #delete': function(e) {
        delWord(this.model.get("id"));
        return this.destroy();
      }
    });
    obj = $$(wd, mvc);
    return $$.document.append(mvc, '#wordList');
  };

  updateWord = function(word) {
    return ws.send(JSON.stringify({
      request: 'updateWord',
      data: word
    }));
  };

  getUnits = function(sub) {
    return ws.send(JSON.stringify({
      request: 'unitList',
      data: sub
    }));
  };

  addUnit = function(u) {
    return $('#addWords #unit').append("<option>" + u.name + "</option>");
  };

  delWord = function(id) {
    console.log("deleting word with id: " + id);
    return ws.send(JSON.stringify({
      request: 'delWord',
      data: {
        id: id
      }
    }));
  };

  $('#addWords').submit(function(e) {
    e.preventDefault();
    addWords();
    $("#def").val('');
    $("#word").val('');
    return $("#word").focus();
  });

  $('#subject').change(function(e) {
    var sub;
    sub = $('#subject');
    getUnits(sub.val());
    return console.log(sub.val());
  });

  host = window.document.location.host.replace(/:.*/, '');

  ws = new WebSocket('ws://' + host + ':3000');

  ws.onmessage = function(data) {
    var c, msg, s, u, wd, _i, _j, _k, _l, _len, _len1, _len2, _len3, _ref, _ref1, _ref2, _ref3, _results;
    console.log("message received");
    msg = JSON.parse(data.data);
    if (msg.response === 'subjectList') {
      console.log(msg.data, 'subjectList');
      _ref = msg.data;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        s = _ref[_i];
        addSubject(s);
      }
    }
    if (msg.response === 'categoryList') {
      _ref1 = msg.data;
      for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
        c = _ref1[_j];
        addCategory(c);
      }
    }
    if (msg.response === 'unitList') {
      _ref2 = msg.data;
      for (_k = 0, _len2 = _ref2.length; _k < _len2; _k++) {
        u = _ref2[_k];
        addUnit(u);
      }
    }
    if (msg.response === 'wordList') {
      console.log('getting word list', msg.data);
      _ref3 = msg.data;
      _results = [];
      for (_l = 0, _len3 = _ref3.length; _l < _len3; _l++) {
        wd = _ref3[_l];
        _results.push(makeWordList(wd));
      }
      return _results;
    }
  };

  ws.onopen = function() {
    console.log('socket open');
    return pageLoad();
  };

  $(window).load(function(e) {
    console.log('loaded');
    if (ws.isopen) {
      return pageLoad();
    }
  });

}).call(this);
