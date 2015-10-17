#!/usr/bin/env node
/* global process */

var fs = require('fs')
var path = require('path')
var crypto = require('crypto')
var mkdirp = require('mkdirp')
var deepExtend = require('deep-extend')
var argv = require('minimist')(process.argv.slice(2))
var nodeEnv = process.env.NODE_ENV || 'development'

function cwd (filePath) { return path.join(process.cwd(), filePath) }

function tryReadJSON (filePath) {
  var obj = {}
  try {
    obj = JSON.parse(fs.readFileSync(filePath, 'utf8'))
  } catch (err) {
    if (err.code !== 'ENOENT') {
      throw err
    }
  }
  return obj
}

function exit () { process.exit() }

process.on('SIGTERM', exit)
process.on('SIGINT', exit)

var config = tryReadJSON(cwd('config.json'))
deepExtend(config, tryReadJSON(cwd('secrets/secrets.json')))

if (argv.issuer) { config.issuer = argv.issuer }
if (argv['client-registration']) {
  config['client_registration'] = argv['client-registration']
}
if (argv['cookie-secret']) {
  config['cookie_secret'] = argv['cookie-secret']
}
if (argv['session-secret']) {
  config['session_secret'] = argv['session-secret']
}
if (!config.redis) { config.redis = {} }
if (argv['redis-host']) {
  config.redis.host = argv['redis-host']
}
if (argv['redis-port']) {
  config.redis.port = argv['redis-port']
}
if (argv['redis-db']) {
  config.redis.db = parseInt(argv['redis-db'])
}
if (argv['redis-password']) {
  config.redis.password = argv['redis-password']
}

if (!config['issuer']) {
  config['issuer'] = 'http://localhost:3000'
}
if (!config['cookie-secret']) {
  config['cookie_secret'] = crypto.randomBytes(32).toString('hex')
}
if (!config['session-secret']) {
  config['session_secret'] = crypto.randomBytes(32).toString('hex')
}

mkdirp.sync(cwd('config'))
fs.writeFileSync(cwd('config/' + nodeEnv + '.json'), JSON.stringify(config), 'utf8')

require('anvil-connect').start()

fs.unlinkSync(cwd('config/' + nodeEnv + '.json'))
