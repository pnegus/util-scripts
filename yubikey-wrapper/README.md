# wrapper

This script injects API tokens (in the default case, AWS and Cloudflare) into environment variables for a given binary.

It reads a JSON object from address 0x005FC103 on the yubikey. You can also configure it to read from another pin-protected address like 0x005FC108.

# Installation:

Move to `/usr/local/bin` and `chmod +x` it.

# Usage:

```
wrapper <executable> <args>
```

# How to import/export new data

to import: 

```
ykman piv objects import <address> <filename>
```

to export:
```
ykman piv objects export <address> <filename>
```