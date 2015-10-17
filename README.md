# anvil-connect

[![Build Status](https://travis-ci.org/vsimonian/docker-anvil-connect.svg)](https://travis-ci.org/vsimonian/docker-anvil-connect)

Lightweight Anvil Connect image for Docker using Alpine Linux

## Try it out

Note: It's best not to expose the port in a production environment, and instead
to use nginx or some other reverse proxy to utilize SSL.

```
$ docker run -d --name connect-redis vartan/alpine-redis
$ docker run -d -p 3000:3000/tcp vartan/anvil-connect:0.1.56 \
    --redis-host connect-redis
```

## Volumes

- `/connect/secrets` - Secret values (See [the configuration section](#configuration)
  for details)
- `/connect/keys` - Anvil Connect's keys folder, which contains signing and
  encryption key pairs and the setup token necessary to configure the CLI client.

## Command-line options

- `--issuer` - sets the issuer URI (default: `http://localhost:3000`)
- `--client-registration [scoped|dynamic|token]` - sets the client registration
  type (default: `scoped`)
- `--redis-host` - sets the hostname or IP of the Redis server (default:
  `localhost`)
- `--redis-port` - sets the port number of the Redis server (default: `6397`)
- `--redis-db` - index of the Redis DB (default: `0`)
- `--redis-password` - password for the Redis server
- `--cookie-secret` - sets the secure cookie secret (default: random string)
- `--session-secret` - sets the secure session secret (default: random string)

## Configuration

> _See the [Anvil Connect documentation][connect-docs] for more details_

Create a configuration file named `config.json`. Then, create your Dockerfile.

```Dockerfile
FROM vartan/anvil-connect:0.1.56

COPY config.json /connect/config.json
```

If you've customized any part of Connect, just copy in the folders. For example:

```Dockerfile
COPY views /connect/views
COPY public /connect/public
```

Then, build your image.

```
$ docker build -t my-anvil-connect-server .
```

Keep secret values out of the image and in a `secrets.json` file in the
`secrets` volume.

```json
{
  "providers": {
    "google": {
      "client_secret": "changeme"
    }
  },
  "cookie_secret": "changeme",
  "session_secret": "changeme"
}
```

```
$ docker run -d -p 3000:3000/tcp -v /path/to/secret/folder:/connect/secrets:ro \
    my-anvil-connect-server
```

## License

MIT. Based off [the official Redis image][redis-image], which is licensed under a
BSD-style license.

[connect-docs]: https://github.com/anvilresearch/connect-docs
[redis-image]: https://github.com/docker-library/redis
