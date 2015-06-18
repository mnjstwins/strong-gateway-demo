# pm-demo

This is a special phase that sets up the application up to `phase-4` using the
[StrongLoop Process Manager](http://docs.strongloop.com/display/SLC/Using+Process+Manager),
which we'll refer to as *PM* from here on.

## Prerequisites

- Everything in [`prerequisites.md`](../../../doc/prerequisites.md)
- [LoopBack tutorial series](https://github.com/strongloop/loopback-example#tutorial-series)
- [`strong-gateway-demo/notes-app-plain`](../../../notes-app-plain)

## Run the demo

### The main demo (phase-4 with process manager)

OSX/Linux:

```
$ pm-demo
```

Windows:

- Not supported

### Getting started

For this demo, we set up the servers to run as depicted in the following
diagram:

```
      Not Running in PM       :       Running in PM
                              :
                 +--------+   :   +---------+       +--------+
                 | Web    |---:-->| Gateway |------>| API    |
                 | Server |<--:---| Server  |<------| Server |
                 +--------+   :   +---------+       +--------+
                 |    |       :   |    |            |
Service Type --> HTTP HTTPS   :   HTTP HTTPS        HTTP
 Port Number --> 2001 2101    :   3001 3101         3002
```

The project consists of the three usual components, but serving on different
ports. When you start a process (in our case, a server) using PM, a service ID
is assigned to the process starting at 1. PM then starts the process on port
3000 + the service ID number.

#### Set up the gateway server

We want to start the gateway as the first service under PM. This means the
gateway will have service id number 1 and be hosted on port 3001.  However, PM
does not reconfigure any HTTPS ports out-of-box, so we will need to [manually
change the gateway's default HTTPS port from 3005 to 3101](gateway-server/server/config.json#L6)
and [reconfigure the HTTPS redirection in `middleware.json` to port 3101](gateway-server/server/middleware.json#L53).
Once the ports are configured, start the service:

```
cd gateway-server
slc start
slc ctl status # confirm service id 1
```

#### Set up the API server

The API server in this demo is [already configured to run on port 3002](api-server/server/config.json#L4).
However, in our case this doesn't matter because PM will assign its own port
based on the service id. Since this application will the be second process we
start, it will be assigned a service id of 3002 by default. Once the ports are
configured, start the service:

```
cd ../api-server
slc start
slc ctl status # confirme service id 2
```

#### Set up the web server

The web server is not managed by PM, so we can set ports as we would normally do
in any LoopBack application. In this case, we [set the HTTP port to
2001](web-server/server/config.json#L4)
and [HTTPS port to 2101](web-server/server/server.js#L25) to match the gateway
server's ports for consistency (ie. gateway's HTTP port is on 3001 and HTTPS
port is on 3101). We also need to [reconfigure the HTTPS redirection port in
`middleware.json` to 2101](web-server/server/middleware.json#L25).

#### Try it out

Once you have all the servers configured, browse to [`localhost:2001`](http://localhost:2001)
to start the authentication flow. Click the link on the home page and follow the
instructions to go through the entire process. Notice the URL changes as you
proceed through the questions.

> You can start all the servers automatically by running the included [`pm-demo`](../../pm-demo)
helper script.

## Troubleshooting

### Reset PM

If you are having trouble running PM, you can reset it by changing to
`notes-app-gateway` project root and running:

```
$ pm-cleanup
```

This command:

- Stops all PM instances that may have been previously running
- Removes the current Strong PM metadata in `~/.strong-pm`

---

[Other LoopBack Examples](https://github.com/strongloop/loopback-example)
