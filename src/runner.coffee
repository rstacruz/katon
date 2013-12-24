require 'shelljs/global'
fs = require 'fs'
forever = require 'forever-monitor'

# Runs express apps
module.exports =

  forever: forever

  run: (path, port) ->
    console.log "Starting #{path} port: #{port}"
    try
      @forever.start @getCommand(path).split(' '), @getForeverOptions(path, port)
    catch error
      console.log error

  getForeverOptions: (path, port) ->
    sourceDir: path
    max: 1
    silent: false
    outFile: "#{path}/katon.logs"
    env:
      PORT: port

  getCommand: (path) ->
    if test '-e', "#{path}/.katon"
      cat "#{path}/.katon"
    else if test '-e', "#{path}/package.json"
      pack = JSON.parse(fs.readFileSync "#{path}/package.json")
      start = pack.scripts?.start
      main = pack.main
      if start?
        if which('nodemon')?
          start.replace 'node', 'nodemon'
        else
          start
      else if main?
        if which('nodemon')?
          "nodemon #{main}"
        else
          "node #{main}"
    else
      throw "Error: Can\'t find a package.json or .katon file in #{path}"