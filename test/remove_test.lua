local testcase = require('testcase')
local assert = require('assert')
local mkdir = require('mkdir')
local fstat = require('fstat')
local error = require('error')
local errno = require('errno')
local remove = require('os.remove')

function testcase.before_all()
    assert(mkdir('./testdir/foo', nil, true))
    local f = assert(io.open('./testdir/foo/bar', 'w'))
    f:write('baz')
    f:close()
end

function testcase.after_all()
    local list = {
        'testdir',
        'foo',
        'bar',
    }
    for i = #list, 1, -1 do
        local pathname = './' .. table.concat(list, '/', 1, i)
        os.remove(pathname)
    end
end

function testcase.cannot_remove_directory_if_not_empty()
    -- test that return an error if not empty
    local ok, err = remove('./testdir/foo')
    assert.is_false(ok)
    assert(error.is(err, errno.ENOTEMPTY),
           'expected ENOTEMPTY error, but got: ' .. tostring(err))
end

function testcase.remove_file()
    -- test that remove a file
    local ok, err = remove('./testdir/foo/bar')
    assert.is_true(ok)
    assert.is_nil(err)
    -- confirm that the file is removed
    local stat = fstat('./testdir/foo/bar')
    assert(stat == nil, './testdir/foo/bar is exist')
end

function testcase.remove_directory()
    -- test that remove a directory
    assert(remove('./testdir/foo'))
    local stat = fstat('./testdir/foo')
    assert(stat == nil, './testdir/foo is exist')
end

function testcase.cannot_remove_if_not_exist()
    -- test that return an error if not exist
    local ok, err = remove('./testdir/foo')
    assert.is_false(ok)
    assert(error.is(err, errno.ENOENT),
           'expected ENOENT error, but got: ' .. tostring(err))
end

function testcase.throws_error_if_invalid_argument()
    -- test that throws an error if pathname argument is invalid
    local err = assert.throws(remove, {})
    assert.match(err, 'string expected, got table')
end

