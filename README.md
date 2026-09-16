## UralicMCP Rahti

This is a test setup for [UralicMCP](https://github.com/mikahama/uralicNLP/wiki/UralicMCP) in CSC's Rahti environment.

Deploy with:

```
oc new-app https://github.com/nikopartanen/UralicMCP-Rahti --name=uralicmcp-rahti
```

Monitor with:

```
oc logs -f bc/uralicmcp-demo
```

Expose with:

```
oc expose svc/uralicmcp-rahti --hostname=uralicmcp-rahti.rahtiapp.fi
```
