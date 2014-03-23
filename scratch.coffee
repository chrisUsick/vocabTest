class Static
	@count: 0
	constuctor: (@prop1) ->
		@count = @count + 1
	instanceMethod: (foo, bar) ->
		@count = @count + 1
		foo + bar + i for i in [1..10]
	@staticMethod: () ->
		@count
		
instance = new Static('foo')
console.log(instance.instanceMethod 'hellow', 'orld')
console.log Static.staticMethod()
inst2 = new Static('bar')
console.log Static.staticMethod()

console.log (Static.count)