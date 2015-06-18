# pm-demo

This is a special phase that sets up the application phase-4, but uses
[StrongLoop Process Manager](http://docs.strongloop.com/display/SLC/Using+Process+Manager), which we'll refer to as PM from here on.

## Prerequisites

- Everything in [`prerequisites.md`](../doc/prerequisites.md)
- [LoopBack tutorial series](https://github.com/strongloop/loopback-example#tutorial-series)
- [`strong-gateway-demo/notes-app-plain`](../notes-app-plain)

## Run the demo

### The main demo (phase-4 with process manager)

OSX/Linux:

```
$ pm-demo
```

Windows:

Not supported yet

### Getting started

For this demo, we set up the servers to run as depicted in the following
diagram:

```
        Running in PM          :   Not Running in PM
                               :
+--------+       +---------+   :   +--------+
| API    |------>| Gateway |---:-->| Web    |
| Server |<------| Server  |<--:---| Server |
+--------+       +---------+   :   +--------+
 |               |     |       :   |    |
 HTTP            HTTP  HTTPS   :   HTTP HTTPS  <---- Service Type
 3002            3001  3101    :   2001 2101   <---- Port Number
```

As you can see, the project consists of the three usual components, but serving
on different ports. When you start a process using PM, a service ID is assigned
to the process starting at 1. PM then starts the process on port 3000 + the
service ID number.

#### Set up the gateway server

In our case, we want to start the gateway as the first service under PM. This
means the gateway will have service id number 1 and be hosted on port 3001.
However, PM does not reconfigure any HTTPS ports, so we will need to change the
gateway's default HTTPS port from 3005 to 3101 (for consistency purposes). Once
the ports are configured, start the service:

```
cd gateway-server
slc start
slc ctl status # confirme service id 1
```

#### Set up the API server

The API server in this demo is already configured to run on port 3002. However,
in our case this doesn't matter because PM will assign its own port based on the
service id. Since this app will the be second process we start, it will be
assigned a service id of 3002 anyways:

```
cd ../api-server
slc start
slc ctl status # confirme service id 2
```

#### Set up the web server

The web server is not managed by PM, so we can set ports as we would normally do
in any LoopBack application. In this case, we set the HTTP port to 2001 and
HTTPS port to 2101 to match the gateway server's ports for consistency (ie.
gateway's HTTP port is on 3001 and HTTPS port is on 3101).

## Troubleshooting

### Reset PM

If you are having trouble running PM, you can reset it by `notes-app-gateway` project root, run:

```
$ pm-cleanup
```

This command:

- Stops all PM instances that may have been previously running
- Removes the current Strong PM metadata in `~/.strong-pm`

---

[Other LoopBack Examples](https://github.com/strongloop/loopback-example)
