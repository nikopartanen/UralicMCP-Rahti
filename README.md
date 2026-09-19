## UralicMCP on Rahti

Test setup for [UralicMCP](https://github.com/mikahama/uralicNLP/wiki/UralicMCP) in CSC's Rahti environment.

**Deploy:**
```bash
oc new-app https://github.com/nikopartanen/UralicMCP-Rahti --name=uralicmcp-rahti
```

**Monitor the build:**
```bash
oc logs -f bc/uralicmcp-rahti
```

**Expose** (plain `oc expose svc` won't work — the route needs edge termination for HTTPS to reach the app):
```bash
oc create route edge uralicmcp-rahti --service=uralicmcp-rahti --hostname=uralicmcp-rahti.rahtiapp.fi --port=8080-tcp
```

**Verify it's up:**
```bash
oc get pods
curl https://uralicmcp-rahti.rahtiapp.fi/mcp
```
A `406 Not Acceptable` JSON response (not an HTML "Application is not available" page) means it's working.

After editing files in GitHub, one can do:

```bash
oc start-build uralicmcp-rahti --follow
```

We also had to increase the memory limit both for build and deployment. Otherwise the translation lookups were causing an out of memory error. The convention how the Komi model is now downloaded in the Dockerfile is probably not ideal:

```bash
oc patch bc/uralicmcp-rahti -p '{"spec":{"resources":{"limits":{"memory":"4Gi"},"requests":{"memory":"2Gi"}}}}'
oc start-build uralicmcp-rahti --follow
oc set resources deployment/uralicmcp-rahti --limits=memory=4Gi --requests=memory=2Gi
```

## TODO

- How are we dealing with model updates? Can they be automatically updated every night if there have been changes?
- Apparently UralicMCP does not currently support Constraint Grammar? How should we handle this?
- 
