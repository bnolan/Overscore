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
        @operation = @operations.pop()
        @input = for input in @output
          input
        @output = []
        while ((new Date).getTime() - tzero < @utilisation) and (@input.length > 0)
          input = @input.pop()
          # console.log input.slice(0,100)
          @operation(input, @output)
      
        if @input.length == 0
          @operation = null

      else
        @_finally()
      
  _finally: ->
    clearInterval(@interval)

    if @_finalCallback
      @_finalCallback(@output)
    
  map: (func) ->
    @operations.push( (input, output) =>
      @output.push(func(input))
    )
    this
    
  select: (func) ->
    @operations.push( (input, output) =>
      if func(input)
        @output.push(input)
    )
    this
    
  then: (func) ->
    @_finalCallback = func
    this

@Overscore = Overscore  

# window.$O = (array) ->
#   new Overscore array
# 
