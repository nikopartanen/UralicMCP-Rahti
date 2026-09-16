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
