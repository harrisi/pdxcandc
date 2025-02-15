# Portland Code & Coffee

Homepage for Portland Code & Coffee.

## Development

This site is primarily plain HTML and CSS. It uses [nginx
SSI](https://nginx.org/en/docs/http/ngx_http_ssi_module.html) for some light
templating, and there is a live reload dev server that is currently enabled by
default. The live reload server uses Server Side Events (SSE) over HTTP 2.0 to
send connected clients a reload message. There is also a heartbeat sent every 30
seconds to maintain the connection.

When running locally, you can run the `watch.sh` script, which uses `entr`
(although any other file watching utility would work) to run the `deploy.sh`
script when files relevant to the site are modified. This is based on a checksum
of the file and uses `rsync` to send a minimal amount of data to the server. By
default, if the live reload dev server is running, all connected clients will
reload the page on deployment. If a user agent has JavaScript disabled, the user
will have to manually refresh to see changes, as normal.

The current server is hosted on a $4 VPS in a San Franciscan datacenter. There
is a provisioning script in the [cloud-init](http://cloud-init.io) format for
ease of deployment. Some aspects of the deployment may be missing from the
cloud-init configuration, but there should be enough information to relatively
easily recreate the instance.

## Contributing

Pull requests are welcome!
