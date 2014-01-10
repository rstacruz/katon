assert = require 'assert'
logan = require 'logan'
katon = require '../../src/cli/katon'

# No logs during tests
logan.silent = true

describe 'katon', ->

  # Let's change katon paths so that everything is done in tmp...
  before ->
    katon.powPath = '/tmp/.pow'
    katon.katonPath = '/tmp/.katon'
    katon.launchAgentsPath = '/tmp'
  
  # Before each tests reset directories 
  beforeEach ->
    paths = ['/tmp/.pow', '/tmp/.katon', '/tmp/app']
    rm '-rf', paths
    mkdir paths

  describe 'link', ->

    beforeEach ->
      # katon.link should create the /tmp/.katon so it's removed before the test
      rm '-rf', '/tmp/.katon'
      katon.link '/tmp/app'

    it 'should create a proxy file in .pow', ->
      assert.equal cat('/tmp/.pow/app'), 4000

    it 'should create .katon directory', ->
      assert test '-e', "/tmp/.katon"

    it 'should create a symlink in .katon directory', ->
      assert test '-L', "/tmp/.katon/app"

  describe 'exec', ->

    beforeEach ->
      katon.exec '/tmp/app', 'grunt'

    it 'should create a .katon file if an execString is provided', ->
      assert.equal cat('/tmp/app/.katon'), 'grunt'

  describe 'unlink', ->

    beforeEach ->
      exec "touch /tmp/.pow/app"
      exec "ln -s /tmp/app /tmp/.katon/app"
      katon.unlink '/tmp/app'

    it 'should rm the proxy in .pow', ->
      assert !test '-f', "/tmp/.pow/app"

    it 'should rm the symlink in .katon', ->
      assert !test '-L', "/tmp/.katon/app"

  describe 'start', ->

    beforeEach ->
      rm '-rf', '/tmp/katon.plist'
      katon.start()
      
    it 'should put a katon.plist in katon.launchAgentsPath', ->
      assert test '-e', '/tmp/katon.plist'

  describe 'stop', ->

    beforeEach ->
      exec 'touch /tmp/katon.plist'
      katon.stop()

    it 'should remove the katon.plist in katon.launchAgentsPath', ->
      assert !test '-e', '/tmp/katon.plist'


  describe 'installPow', ->

    it 'should be present in katon', ->
      assert katon.hasOwnProperty 'installPow'


  describe 'uninstallPow', ->

    it 'should be present in katon', ->
      assert katon.hasOwnProperty 'uninstallPow'

  describe 'list', ->

    it 'should be present in katon', ->
      assert katon.hasOwnProperty 'list'

  describe 'status', ->

    it 'should be present in katon', ->
      assert katon.hasOwnProperty 'status'