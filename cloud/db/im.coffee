DB = require "cloud/_db"
uuid = require "node-uuid"
redis = require "cloud/_redis"
{R} = redis
Q = require "q"

R "IM_WEB_ID", ":"


APP_ID = process.env.LC_APP_ID
APP_KEY = process.env.LC_APP_KEY

DB class IM

    @web_id: (params, options)->

        current = AV.User.current()
        if current
            user_id = current.id
        else
            user_id = 0
        
        q = DB.Site.$
        q.select 'ID'
        q.get(
            params.site_id
            success:(site)->
                console.log 'site', site.id
                if not site
                    return
                key = R.IM_WEB_ID+site.get('ID')
                console.log 'key', key
                redis.hget(
                    key
                    params.user_id or 0
                    (err, installation_id) ->
                        if not installation_id
                            installation_id = uuid.v4()
                            redis.hset(
                                key
                                user_id
                                installation_id
                            )

                            installation = AV.Object.new('_Installation')
                            installation.set('user_id', user_id)
                            installation.set('channels', ["Site:"+site_id])
                            installation.save()
                        options.success installation_id
                )
        )


DB class MsgLog
    @_send: (site_id, user_id, channel_kind, msg_kind, data, sender=0) ->
        if not sender
            sender = AV.User.current()

        push = AV.push({appId: APP_ID appKey: APP_KEY})
        query = new AV.Query("_Installation")
        key = "Site:" + site_id
        redis.hget(
            key
            user_id
            (err, installation_id) ->
                query.equalTo('installationId', installation_id)
                push.send({
                    where: query
                    data: {
                        channel_kind
                        msg_kind
                    }
                })
        )
