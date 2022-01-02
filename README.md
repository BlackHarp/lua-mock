lua-mock
========

Tiny collection of mocking utilities.


A few examples:

```lua
package.path = package.path .. ";../?.lua"
local lua_mock = require('lua-mock.lua-mock')
os.remove = lua_mock.Spy(os.remove, "os.remove()")

RemoveRecusive('example')

os.remove:assertCallMatches{atIndex=1, arguments={'example/content'}}
os.remove:assertCallMatches{atIndex=2, arguments={'example'}}
os.remove:assertCallCount(2)
-- or
os.remove:assertAnyCallMatches{arguments={'example/content'}}
```

```lua
package.path = package.path .. ";../?.lua"
local lua_mock = require('lua-mock.lua-mock')
os.remove = lua_mock.Stub(os.remove, "os.remove()")

RemoveRecusive('example')

os.remove:assertCallMatches{atIndex=1, arguments={'example/content'}}
os.remove:assertCallMatches{atIndex=2, arguments={'example'}}
os.remove:assertCallCount(2)
-- or
os.remove:assertAnyCallMatches{arguments={'example/content'}}
```

```lua
package.path = package.path .. ";../?.lua"
local lua_mock = require('lua-mock.lua-mock')
os.remove = lua_mock.Mock(os.remove, "os.remove()")

os.remove:whenCalled{with={'example/content'}, thenReturn={true}}
os.remove:whenCalled{with={'example'}, thenReturn={true}}
os.remove:whenCalled{thenReturn={nil, 'No such file.'}}

RemoveRecusive('example')

os.remove:assertAnyCallMatches{arguments={'example/content'}}

os.remove = os.remove:reset()
```

```lua
package.path = package.path .. ";../?.lua"
local lua_mock = require('lua-mock.lua-mock')
os.time = lua_mock.Mock(os.time, "os.date()")

os.time:whenCalled{with={{year=2021, month=12, day=1}}, thenReturn={1638306000}}

RecusiveTableMatch('example')

os.time = os.time:reset()
```


Author
------

- [Henry Kielmann](http://henry4k.de/)


Licence
-------

This is free and unencumbered public domain software.  
For more information, see http://unlicense.org/ or the accompanying `UNLICENSE` file.
