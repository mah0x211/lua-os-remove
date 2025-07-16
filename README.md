# lua-os-remove

[![test](https://github.com/mah0x211/lua-os-remove/actions/workflows/test.yml/badge.svg)](https://github.com/mah0x211/lua-os-remove/actions/workflows/test.yml)
[![codecov](https://codecov.io/gh/mah0x211/lua-os-remove/branch/master/graph/badge.svg?token=NC0N3888PV)](https://codecov.io/gh/mah0x211/lua-os-remove)

A drop-in replacement for the built-in os.remove function, but with easier, portable error handling via structured error objects instead of errno values.

## Installation

```
luarocks install os-remove
```

## Error Handling

the following functions return the error object created by https://github.com/mah0x211/lua-errno module.


## ok, err = remove( pathname )

remove a file or directory.

**Parameters**

- `pathname:string`: path of the file or directory to remove.

**Returns**

- `ok:boolean`: `true` on success.
- `err:any`: error object.

**Example**

```lua
local remove = require('os.remove')
local error_is = require('error.is')
local errno = require('errno')

local ok, err = remove('/tmp/example/remove/target/path/to/entry')
if not ok then
    if error_is(err, errno.ENOENT) then
        print('file does not exist:', err)
    elseif error_is(err, errno.ENOTEMPTY) then
        print('directory is not empty:', err)
    else
        print(err)
    end
end
```
