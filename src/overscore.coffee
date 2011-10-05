class Overscore
  constructor: (array) ->
    @utilisation = 75

    # todo - replace with a better clone function
    @output = for input in array
      input
    
    @operations = []
    @operation = null
    
    @interval = setInterval(@_process, 100)

    this

  _process: =>
    tzero = (new Date).getTime()

    if @operation == null
      if @operations.length > 0
        @operation = @operations.shift()
        @input = for input in @output
          input
        @output = []
      else
        @_finally()

    if @operation
      while ((new Date).getTime() - tzero < @utilisation) and (@input.length > 0)
        input = @input.pop()
        @operation(input)
    
      if @input.length == 0
        @operation = null

      
  _finally: ->
    clearInterval(@interval)

    if @_finalCallback
      @_finalCallback(@output)
    
  map: (func) ->
    @operations.push( (input) =>
      @output.push(func(input))
    )
    this
    
  each: (func) ->
    @operations.push( (input) =>
      func(input)
    )
    this

  select: (func) ->
    @operations.push( (input) =>
      if func(input)
        @output.push(input)
    )
    this
    
  then: (func) ->
    @_finalCallback = func
    this

@Overscore = Overscore
# 
# window.$O = (array) ->
#   new Overscore array