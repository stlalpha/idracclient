# Python 3.14+ and Java 25 Compatibility Fixes

Hi! I've updated this script to work with modern Python and Java versions. The original script fails with Python 3.10+ and has warnings with Java 9+.

## Changes Made

### 1. Fixed Python 3.10+ Compatibility
**Issue:** `asyncio.get_event_loop()` is deprecated and raises `RuntimeError` in Python 3.10+
```python
# Old (lines 64-65):
loop = asyncio.get_event_loop()
ret = loop.run_until_complete(run(args))

# New:
ret = asyncio.run(run(args))
```

### 2. Added Java 9+ Native Access Support
**Issue:** Java 9+ shows warnings for native library access and may fail with `UnsatisfiedLinkError`
```python
# Added flag to invocation (line 215):
"--enable-native-access=ALL-UNNAMED",
```

## Testing
- ✅ Tested on Python 3.14.2 with Java 25.0.1
- ✅ Successfully connected to Dell iDRAC at 192.168.0.132:5900
- ✅ KVM viewer launches without errors

## Patch File
See attached `python314-java25-compatibility.patch` for unified diff.

## Full Updated Version
I've also created a full repository with documentation: https://github.com/stlalpha/idracclient

Thanks for the great script!
