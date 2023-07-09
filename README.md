# TOSOD Game Engine

This is a game engine made by me on top of GameMaker Studios. It powers my top-down pixel RPG, which will be released later.

What's inside:
- [x] Django-like apps structure
- [x] Pytest-inspired testing framework
- [ ] Nuxt-inspired store, mutations and rendering
- [ ] Menu app - start/exit your game
- ...

## Documentation

### General Rules

1. Everything which is displayed at every frame on screen should be declaratively described with three types of storages: store, cache and idmap. It is prohibited to render anything which is not saved in either store, cache or idmap.
2. Every change to the store, cache or idmap should not happen on the fly and instead be represented as a query. 
3. Any piece of code (except for utils) should be tied to a specific component, which should be either a singleton or an instance.  
4. No controlling objects as instances allowed on instance layers. Controlling objects should be in-memory, so that they would not have to be carried from one layer to another and managed. Only entity instances should be present on instance layers.
5. It is prohibited to keep in store anything which cannot be serialized. It is allowed to store unserializable data structures in cache and idmap, given that they are used more than once.


### App Types

There are two types of apps:

1. Singleton app doesn't have a logical id and is accessed by its scope name (`application`, `menu`, `game`, etc), for example `start_application()`
2. Instance app has a logical id and is accessed by it, for example `command_entity(entity_id, command)`


### Method Types

There are two types of methods:

1. ABC method is very strict and is used as app's interface with engine
2. Freeform method is more relaxed and is used mostly as app's interfaces with other apps

Each app should have following ABC methods:

- `get_COMPONENT_constants` - must return struct of default app constants. Three keys are mandatory: `NAME` (component name), `STORE_KEYS` (allowed store keys) and `CACHE_KEYS` (allowed cache keys)
- `get_COMPONENT_store` - must return struct of default store keys (no values, all undefined)
- `get_COMPONENT_cache` - must return struct of default cache keys (no values, all undefined)

The following freeform methods exist:

- `start_COMPONENT` - 1) defines constants, 2) defines variables, 3) sets component store and cache by getting them with `get_COMPONENT_store` and `get_COMPONENT_cache`, after that calls `create_singleton` or `create_instance`, 4) runs some code associated with component BEFORE entering its room (if it has a room). This is normally called by `PARENT_start_CHILD` or directly.
- `poststart_COMPONENT` - 5) runs some code associated with component AFTER entering its room (if it has a room). This is normally run by room creation code.

## Apps

### engine

`engine` is the first app to run. It stores the root room `room_engine`, its creation code sets engine constants and checks if the debug mode is on or not. If it's on, the creation code executes `gmtest()`, which collects all tests and runs them. If debug is off, `start_application()` is executed.

### application

`application` literally represents your running application. It has two states: `game` and `menu`. Menu means the title menu where you can exit or start your game. Game means everything which goes after you hit start game button, including cutscenes, free move, dialogs and nearly everything else.

Actions:

- `start_application` creates application singleton with global `store`, `cache`, `idmap` initialized, also creates constants for each app, stores them in `<APPNAME>` globals


## Auxillary

### _builtins

`_builtins` is a collection of useful utilities.

Assert:
- `assert` is a function that compares two arguments and raises an error if they are not equal.

Compare:
- `deep_compare` is used to compare its arguments and tell if they are fully equal. Runs deep recursive nested checks for arrays and structs, runs `==` for everything else.

Print:
- `print` joins its arguments and prints them as `show_debug_message()`.

Log:
- `log` is used to debug storage transactions. Prints something like `entity mutates {state: "walking"}` every time application state changes with storage calls.

Storage:
- `mutate(scope, caller, items)` - updates `scope` store with keys from `items` struct, logs this transaction. Use this to modify singleton's store
- `imutate(scope, scope_id, caller, items)` - updates `scope` store with keys from `items` struct, logs this transaction. Use this to modify instance's store
- `remember(scope, caller, items)` - updates `scope` cache with keys from `items` struct, logs this transaction. Use this to modify singleton's cache
- `iremember(scope, scope_id, caller, items)` - updates `scope` cache with keys from `items` struct, logs this transaction. Use this to modify instance's cache
- `map(scope, caller, items)` - updates `scope` idmap with keys from `items` struct, logs this transaction. Use this to map logical ids to runtime ids

Array:

- `array_in` - check if an element is a member of an array

Variable:

- `check_defined` - the opposite of `is_undefined`


### _gmtest

`gmtest` is a pytest-inspired testing framework. Each test should be a function named `test_*` and located somewhere in project scripts. Gmtest is run by invoking `gmtest()`, which happens by default in `meta` app. It collects tests, runs them and reports results.


## Notes

These are my notes which I use to outline general problems and development plans:

- Most `_builtins` are not covered with tests directly, but are covered indirectly through apps
- `stop_engine` is missing
- tests probably work improperly because room goto doesn't work in the same event it was called
