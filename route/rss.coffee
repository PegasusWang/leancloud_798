app = require("app")
DB = require "cloud/_db"

app.get('/rss/:host', (request, res) ->
    host = request.params.host.toLowerCase()
    
    if request.query.site
        query_site = ".html?site=" + request.query.site
    else
        query_site = ''

    DB.Site.by_host(
        {host}
        success:(_site) ->
            if not _site
                res.success ''
            site = DB.Site(_site)
            DB.SiteTagPost.by_site_tag({
                site_id:_site.id
            }, success:(result)->
                if result
                    [post_list,_] = result
                    if post_list.length
                        pubdate = post_list[0].get('createdAt')
                    else
                        pubdate = ''

                    for i in post_list
                        DB.SiteTagPost.$.get(i.id, {
                            success: (site_tag_post) ->
                                i.set('tag_list', site_tag_post.get('tag_list'))
                        })
                                


                    res.render(
                        'rss',
                        {
                            site_name: site.name
                            rss_title: site.name
                            rss_link: "http://#{host}"
                            rss_description: site.slogo
                            rss_generator: site.name_cn
                            pubdate: pubdate
                            items: post_list
                            query_site
                            query_site_name: request.query.site
                        }
                    )
                else
                    res.send ''
            )
    )
)
