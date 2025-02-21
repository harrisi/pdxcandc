# Portland Code & Coffee

Homepage for Portland Code & Coffee.

## Development

This site is primarily plain HTML and CSS. It uses [nginx
SSI](https://nginx.org/en/docs/http/ngx_http_ssi_module.html) for some light
templating, and there is a live reload dev server that is currently enabled by
default. The live reload server uses Server Side Events (SSE) over HTTP 2.0 to
send connected clients a reload message. There is also a heartbeat sent every 30
seconds to maintain the connection.

There are two ways to run the live reload server. Installing the pre-push git hook
with `./scripts/install-git-hooks.sh` will trigger a deploy of the changes to the
live server when a push is made. This ensures the git repo will be in sync with the server, which is nice. Make sure to set the `PROD` environment variable to trigger a deploy to the production server.

The other way is to run the `watch.sh` script (with `$PROD` set), which uses `entr`
(although any other file watching utility would work) to run the `deploy.sh`
script when files relevant to the site are modified. This is based on a checksum
of the file and uses `rsync` to send a minimal amount of data to the server. If
`$PROD` is not set, it will just trigger the local instnce of the coming up server
(https://github.com/harrisi/comingup_events).

The current server is hosted on a $4 VPS in a San Franciscan datacenter. There
is a provisioning script in the [cloud-init](http://cloud-init.io) format for
ease of deployment. Some aspects of the deployment may be missing from the
cloud-init configuration, but there should be enough information to relatively
easily recreate the instance.

## Contributing

Pull requests are welcome!
