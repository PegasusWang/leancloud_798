

SITE_USER_LEVEL = require "cloud/db/site_user_level"
DB = require "cloud/_db"


USER_ID = "555ec11ee4b032867864e735"
SITE_ID = "555d759fe4b06ef0d72ce8e7"

GUEST_ID = "556be1a4e4b0aec39c81a36f"
DB.SiteUserLevel._level GUEST_ID, SITE_ID, (level)->
    console.log GUEST_ID,  level
    DB.SiteUserLevel._set GUEST_ID, SITE_ID, SITE_USER_LEVEL.ROOT
    DB.SiteUserLevel._level GUEST_ID, SITE_ID, (level)->
        console.log GUEST_ID,  level

DB.SiteUserLevel._level USER_ID, SITE_ID, (level)->
    console.log USER_ID, level
    DB.SiteUserLevel._set USER_ID, SITE_ID, SITE_USER_LEVEL.ROOT

DB.SiteUserLevel.set {
    username:"雨杭小小"
    site_id:SITE_ID
    level:SITE_USER_LEVEL.EDITOR
}, {
    success:->
        DB.SiteUserLevel._level GUEST_ID, SITE_ID, (level)->
            console.log GUEST_ID, level,"---"
}

DB.SiteUserLevel.by_site_id {
    site_id:SITE_ID
}, success:(li)->
    for [id,name,level] in li
        console.log id, name, level
