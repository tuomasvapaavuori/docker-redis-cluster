# Docker Redis Cluster

## Forked from
https://github.com/riandyrn/docker-redis-cluster

This docs contains following sections:

- [`Purpose of this project`](#purpose-of-this-project)
- [`Start Cluster`](#start-cluster)
- [`Stop Cluster`](#stop-cluster)
- [`Run Redis CLI`](#run-redis-cli)
- [`Configuration options`](#configuration-options)
- [`Acknowledgements`](#acknowledgements)

---

## Purpose of this project

Purpose of this project is to have Redis cluster setup easily running under development environment or for CI with configurable redis process ports. If you for example happen to have conflicting ports in your setup..

There was multiple versions of redis cluster dockerized, but I didn't find simple solution for development environment which would give option to specify ports for redis processes running in single container.

So this is just fork from https://github.com/riandyrn/docker-redis-cluster with some templating for running Redis in cluster mode under development environment.

[Back to Top](#docker-redis-cluster)

---

## Start Cluster

To start the cluster using `docker-compose`, we could use following helper command:

```bash
$> make up
```

To start the cluster using `docker stack`, we could use following helper command:

```bash
$> make start-swarm
```

[Back to Top](#docker-redis-cluster)

---

## Stop Cluster

To stop the cluster started using `docker-compose`, we could use following helper command:

```bash
$> make down
```

To stop the cluster started using `docker stack`, we could use following helper command:

```bash
$> make stop-swarm
```

[Back to Top](#docker-redis-cluster)

---

## Run Redis CLI

If we want to run the internal `redis-cli` inside the container for some reason (for example `redis-cli` is not installed on host), we could use following helper command:

```bash
$> make REDIS_PORT=xxxx run-cli
```

But this command only applies if we start our cluster using `docker-compose`.

If `redis-cli` is installed on host, we could also use it to connect with cluster. Simply use following command to do that:

```bash
$> redis-cli -c -p xxxx
```

[Back to Top](#docker-redis-cluster)

---

## Configuration options

### IP

Redis IP address in container 
```
IP=0.0.0.0
```

### Redis ports

Comma separated list of ports for redis processes. Amount of ports defines also process count.
```
REDIS_PORT_LIST=7005,7006,7007,7008,7009,7010
```

Image defaults to these ports if none is provided for `REDIS_PORT_LIST`

### Exposed ports

By default image doesn't expose any ports so you have to define exposed ports to for example `docker-compose.yml` file or for docker command.

For example:
```
...
    ports:
      - "7005-7010:7005-7010"
...
```

In this example is defined port mappings to expose 7005-7010 ports from container to host. You can't map different port from container to different port in host, because redis processes are only aware of ports configured inside the container.

[Back to Top](#docker-redis-cluster)

---

## Acknowledgements

Thanks to [@riandyrn](https://github.com/riandyrn) for making Redis cluster setup easily approachable :)

Thanks to [@Grokzen](https://github.com/Grokzen) for doing the ground work for dockerized Redis cluster setup.

[Back to Top](#docker-redis-cluster)

---