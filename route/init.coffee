
require("route/rss")
require("route/static")
require("route/css")
require("route/oauth/evernote")


app = require('app')
if app.get('env') == 'development'
    require("route/test")
