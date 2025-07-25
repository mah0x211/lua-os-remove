/**
 *  Copyright (C) 2025 Masatoshi Fukunaga
 *
 *  Permission is hereby granted, free of charge, to any person obtaining a
 *  copy of this software and associated documentation files (the "Software"),
 *  to deal in the Software without restriction, including without limitation
 *  the rights to use, copy, modify, merge, publish, distribute, sublicense,
 *  and/or sell copies of the Software, and to permit persons to whom the
 *  Software is furnished to do so, subject to the following conditions:
 *
 *  The above copyright notice and this permission notice shall be included in
 *  all copies or substantial portions of the Software.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
 *  THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 *  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 *  DEALINGS IN THE SOFTWARE.
 */

#include <errno.h>
#include <stdio.h>
// lua
#include <lua.h>
#include <lua_errno.h>

static int remove_lua(lua_State *L)
{
    size_t len     = 0;
    char *pathname = (char *)luaL_checklstring(L, 1, &len);

    lua_settop(L, 1);
    errno = 0;
    if (remove(pathname) != 0) {
        lua_pushboolean(L, 0);
        lua_errno_new(L, errno, "os.remove");
        return 2;
    }
    lua_pushboolean(L, 1);
    return 1;
}

LUALIB_API int luaopen_os_remove(lua_State *L)
{
    lua_errno_loadlib(L);
    lua_pushcfunction(L, remove_lua);
    return 1;
}
