Disposable = require './disposable'

module.exports =
class Emitter
  isDisposed: false

  constructor: ->
    @handlersByEventName = {}

  on: (eventName, handler) ->
    if @isDisposed
      throw new Error("Emitter has been disposed")

    if currentHandlers = @handlersByEventName[eventName]
      @handlersByEventName[eventName] = currentHandlers.concat(handler)
    else
      @handlersByEventName[eventName] = [handler]

    new Disposable(@off.bind(this, eventName, handler))

  emit: (eventName, value) ->
    if @isDisposed
      throw new Error("Emitter has been disposed")

    if handlers = @handlersByEventName[eventName]
      handler(value) for handler in handlers

  dispose: ->
    @handlersByEventName = null
    @isDisposed = true

  off: (eventName, handlerToRemove) ->
    return if @isDisposed

    if oldHandlers = @handlersByEventName[eventName]
      newHandlers = []
      for handler in oldHandlers when handler isnt handlerToRemove
        newHandlers.push(handlerToRemove)
      @handlersByEventName[eventName] = newHandlers