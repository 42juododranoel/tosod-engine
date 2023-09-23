# TOSOD Game Engine

TOSOD engine is a game engine made by me on top of GameMaker Studio. It powers my top-down pixel RPG, which will be released later.

What's inside:
- [x] Django-like apps structure
- [x] Pytest-inspired testing framework with paramerizing and dependency injection
- [x] Redux-inspired store, mutations and rendering
- [ ] ...

## Core Principles

1. Every visual element displayed on the screen in each frame should be explicitly described using three types of storage: `store`, `cache` and `idmap`. It's not allowed to render any piece of code that isn't stored in one of these three categories, with the exception of `tosotest`.

2. Any changes to the `store`, `cache` or `idmap` should not be made on the fly. Instead, they should be represented as queries, such as `mutate`, `imutate`, `remember` and `iremember`.

3. All non-framework related data must be kept exclusively within the `content` folder. This means that the code should be entirely separate from elements such as the plot, characters, sprites, dialogs and other data. The data should be fully declarative, enabling you to modify any aspect of the plot by editing structs and arrays without having to touch any code components.

4. Each piece of code should be associated with a specific isolated app (`application`, `game`, `menu`, `entity`, `location`, `slideshow`, `dialog`, `order`). These apps should follow a generally similar structure, including elements like `store`, `cache`, `idmap`, `start`, `stop`, `testsuits`, and `fixtures`.

5. Controlling objects should not be present on instance layers, except for `tosotest`. Controlling objects should be in-memory to avoid the need for managing them between layers. Only room-specific entity instances should be found on instance layers.

6. Storing anything unserializable in the `store` is prohibited. However, unserializable data structures are allowed in the `cache` and `idmap` as long as they are used more than once.

7. This repository does not have a configured CI system, but rest assured that every commit to the `main` branch is guaranteed to have all tests passing on my machine. I'm not certain if running a CI for GameMaker projects is even possible, but I might explore this option in the future.

## How Things Work

### Tosoengine

When you start a game, the GameMaker opens a home room `room_tosoengine`. This room's creation code simply initializes two core apps: `TosoengineApp` and `TosotestApp`. After initializing tosoengine, it runs it. This is how the room creation code looks like:

```
// Create tosoengine and tosotest and run everything
global.tosoengine = new TosoengineApp()
global.tosotest = new TosotestApp()

// Initialize apps mapping
global.apps = {
    tosoengine: global.tosoengine,
    tosotest: global.tosotest,
}

// This is where the fun begins (c)
global.tosoengine.start()
```

Tosoengine's start function populates `global.apps` struct with non-core apps, reads each app's `get_store` and `get_cache`, sets the results in `self.STORE_KEYS` and `self.CACHE_KEYS`. These two arrays will be used to validate `mutate` and `remember` queries later.

```
static set_constants = function() {
    // Set apps
    global.apps.application = new ApplicationApp()
    global.apps.menu = new MenuApp()

    // Set STORE_KEYS and CACHE_KEYS for apps
    var app_names = variable_struct_get_names(global.apps)
    for (var app_index = 0; app_index < array_length(app_names); app_index++) {            
        var app_name = app_names[app_index]
        var app = variable_struct_get(global.apps, app_name)
            
        var app_store_keys = variable_struct_get_names(app.get_store())
        variable_struct_set(self.STORE_KEYS, app_name, app_store_keys)

        var app_cache_keys = variable_struct_get_names(app.get_cache())
        variable_struct_set(self.CACHE_KEYS, app_name, app_cache_keys)
    }
}
```

After that, tosoengine initializes three global storages: `store`, `cache` and `idmap`.

```
static set_variables = function() {
    // Set storages
    global.store = {}
    global.cache = {}
    global.idmap = {}
}
```

Finally, it checks if game was run in debug mode or normal mode. Debug mode will make tosoengine run tosotest, otherwise the game will start.

```
static run_component = function() {
    if debug_mode {
        // Run tests
        global.tosotest.start()
    } else {
        // Run game
        global.apps.application.start()
    }
}
```

### Tosotest

Tosotest is a testing framework. The goal behind it is to be as Pytest-like as possible, supporting fixtures and parametrizing, but as complex. Tosotest stores a lot of data inside of it:

```
// Variables
    
collection = {
    // Each test and parametrized signature is saved here
    signatures: [],
    // Fixture section
    app_fixture_graph: {},
    testsuit_fixture_graph: {},
    // Statistics are used for informational UX purposes
    statistics: {
        app_count: 0,
        testsuit_count: 0,
        test_count: 0,
    },
}
    
execution = {
    // Callbacks are run by object_tosotest, whose id is stored here,
    // and is updated before each test thanks to room_tosotest's creation code
    object_id: undefined,
    // Signature index is an index of currently running test in the collection
    signature_index: 0,
    // Callbacks are run during events by object_tosotest,
    // they are needed to postpone asserts until a specific event occurs
    callbacks: {},
    // Results store signature run results
    results: {},
    // Statistics are used for informational UX purposes
    statistics: {
        total: 0,
        passed: 0,
        failed: 0,
    }
}
```

When tosotest is run, the first thing it does is collects tests by running `tosotest_collect` action. It starts by resolving globally-accessible app-level fixture dependency graph. Building a fixture graph means going through each defined fixture and recursively going through every dependency it has. The final result of this operation is a struct containing a tree that references all fixtures that are required to run a specific fixture. This graph is used before running each test. Tosotest executes fixtures one after another and injects the results of previous ones as arguments to the next ones.

An example of app-level fixtures that are accessible in other apps. Note that `app_fixture_2` uses `app_fixture_1` as a dependency, meaning that `app_fixture_1` will be executed before `app_fixture_2` and the result will be saved in `fixtures.app_fixture_1` argument:

```
// In app
static get_fixtures = function() {
    return {
        app_fixture_1: function() {
            return "app_fixture_1"
        },
        app_fixture_2: {
            depends: ["app_fixture_1"],
            fixture: function(fixtures) {
                return fixtures.app_fixture_1
            }
        }
    }
}
```

After collecting app-level fixtures, tosotest goes inside of each app and builds its testsuit-level fixture graph. The following is an example of testsuit-level fixtures. The output of `testsuit_fixture_2` will be `["app_fixture_1", "testsuit_fixture_1"]`, because it depends on `app_fixture_2` (that depends on `app_fixture_1`) and `testsuit_fixture_1`. Note that testsuit-level fixtures can't be used outside of testsuits they were defined in. 

```
// In testsuit
function get_tosotest_syntax_testsuit() {
    return {
        name: "syntax",
        fixtures: {
            testsuit_fixture_1: function() {
                return "testsuit_fixture_1"
            },
            testsuit_fixture_2: {
                depends: ["app_fixture_2", "testsuit_fixture_1"],
                fixture: function(fixtures) {
                    return [fixtures.app_fixture_2, fixtures.testsuit_fixture_1]
                },
            },
        },
        tests: {
            ...
        }
    }
}
```

After testsuit fixtures are collected, tosotest collects each testsuit's test signatures. A `test` is a function that has a name and is a part of testsuit, a `signature` is a processed version of test that will be called during execution. One test may have more than one signature if it uses parametrization. The following test named `my_foobar_test` will generate two signatures: `my_foobar_test[2,2,4]` and `my_foobar_test[1,-1,0]`.

```
my_foobar_test: {
    parametrize: [
        ["first", "second", "expected"],
        [
            [2, 2, 4],
            [1, -1, 0],
        ]
    ],
    test: function(params) {
        var results = params.first + params.second
        
        assert(results, params.expected)
    },
},
```

The ultimate goal of collection stage is to build all necessary fixture dependency graphs and collect a flat array of test signatures that will be run later. During the collection stage, tosotest prints its statistics to console:
```
Collecting tests...
Collected 15 tests in 4 testsuits across 3 apps.
```

After collection stage is finished, an execution stage starts. Before we dive deeper, let's set this following test as an example. This test named `change_room` runs `global.apps.application.start()` (that changes room to `room_application`). It then defines a callback `on_room_start` that will be executed when the corresponding event happens. 

```
change_room: {
    test: function() {
        global.apps.application.start()

        on_room_start(function() {
            assert(room, room_application)
        })
    }
}
```

To run this or any other test, tosotest enters room `room_tosotest`. This room's creation code collects the first available signature, creates an instance of `object_tosotest` and executes the test. The goal of `object_tosotest` is to intercept any events that would happen during the test's execution. This is needed if you need to run an assert during some specific moment, such as `on_room_start`.

```
var signature = global.tosotest.collection.signatures[global.tosotest.execution.signature_index]

global.tosotest.execution.object_id = instance_create_depth(0, 0, 16000, object_tosotest)

tosotest_execute_signature(signature)
```

The signature's execution starts by printing its name, then running the pre-execute procedures, followed by the actual test function call. If any errors occur during the `signature.test()` call, they will be intercepted and the signature will be marked as `STATUS_FAILED`. If no exceptions occur, one of two things happens. If any event handlers were called during test's body execution (like `on_room_start`), tosotest will not proceed to the next signature and instead give up its control and wait until the event happens. This place is where your tests may hang forever if something is misconfigured, for example expecting an event that will not actually fire. But if there were no event handlers at all, tosotest will simply run post-execute procedures and then run the next tests.

```
function tosotest_execute_signature(signature) {
    // Print that we are running this signature
    print("  " + signature.name + "...")

    // Run this signature
    ...
    tosotest_preexecute_signature(signature)
    ...
    signature.test()
    ...

    // If no on_room_start() was executed in test body
    if not global.tosotest.execution.has_callbacks {
        tosotest_postexecute_signature(result)
    }
    // Otherwise wait for them to trigger
}
```

Let's dive deeper in what happens during the `on_room_start` callback. This callback sets a global flag denoting that this signature has event callbacks and tosotest should not proceed to next test until this one handles its events.

```
function on_room_start(callback) {
    global.tosotest.execution.has_callbacks = true
    variable_struct_set(
        global.tosotest.execution.callbacks, 
        global.tosotest.EVENTS.ROOM_START, 
        callback,
    )
}
```

Not let's look at `object_tosotest`'s room start event. When this event is fired, it runs callback that was defined in test function as an argument to `on_room_start`. If callback raises any exceptions, tosotests stops here and will not proceed to other potential event callbacks, marking this test as failed. If not exceptions were raises, tosotest checks if there are any other callbacks. If this one was the last, tosotests runs post-execute procedures.

```
var key = global.tosotest.EVENTS.ROOM_START

var callback = variable_struct_getdefault(
    global.tosotest.execution.callbacks, 
    global.tosotest.EVENTS.ROOM_START, 
    undefined,
)

if check_defined(callback) {
    // Execute callback with error catching
    ...
    callback()
    ...
    
    // Remove this callback
    variable_struct_remove(global.tosotest.execution.callbacks, global.tosotest.EVENTS.ROOM_START)
    
    // Call postexecute if that was the last callback or this signature failed
    if array_length(variable_struct_get_names(global.tosotest.execution.callbacks)) == 0 or result == global.tosotest.STATUSES.FAIL {
        tosotest_postexecute_test(result)
    }
}
```

The post-execute procedures save results, update statistics and check if this was the last signature or not.

```
function tosotest_postexecute_signature(result) {
    // Save results
    ...

    // Update statistics
    ...

    // Prepare to run next test
    global.tosotest.execution.signature_index += 1
    if global.tosotest.execution.signature_index < global.tosotest.collection.statistics.test_count {
        // Destroy current test object, to start from scratch again
        instance_destroy(global.tosotest.execution.object_id)
        room_goto(room_tosotest)
    } else {
        // That was the last signature, go report results
        tosotest_report()        
    }
}
```

Finally, when all tests are run, tosotests reports results:

```
Collecting tests...
Collected 15 tests in 4 testsuits across 3 apps.

Running tests...
  application::start::set_application_storages...
  application::start::change_room...
  tosoengine::start::set_apps...
  tosoengine::start::set_store_keys...
  tosoengine::start::set_storages...
  tosoengine::start::set_cache_keys...
  tosoengine::room_creation_code::set_apps...
  tosoengine::room_creation_code::create_tosoengine...
  tosoengine::room_creation_code::create_tosotest...
  tosotest::syntax::test_fixture...
  tosotest::syntax::fixture_scopes...
  tosotest::syntax::parametrization[2,2,4]...
  tosotest::syntax::on_room_start_callback...
  tosotest::syntax::app_fixture...
  tosotest::syntax::testsuit_fixture...

Reporting global.tosotest.execution...

Total: 15
Passed: 15
Failed: 0
```

## Application

TBD.


## Strategic Roadmap

- [x] Create the `engine` app, with base app and framework structure to use later for every single component and piece of code
- [x] Create the `application` app, responsible for storing all application-level constants and switching between `menu` and `game`  
- [x] Create a testing framework THE RIGHT WAY (the Pytest way, with fixtures and parametrizing), because code without tests is legacy by design even in gamedev
- [ ] (in progress) Create the `menu` app, which should greet users and provide them with start/continue/exit features
- [ ] Create the `game` app, which should store everything related to plot progress, entities, locations and many other things
- [ ] Create the `orders` app, which should execute scripted sequences, such as starting slideshows, commanding entities, changing locations, running dialogs, etc
- [ ] Create the `location` app, which should render location, with tilesets and layers
- [ ] Create the `entity` app, which should be responsible for everything concerning interactive objects, such as characters and doors
- [ ] Create the `dialog` app, which should render dialog lines with portraits, choice options, and callbacks
- [ ] Create the `slideshow` app, which should render sequences of images and text in a VN-styled fashion
- [ ] Create the `trigger` app, which should run orders when specific conditions occur
- [ ] Create the `player` app, which is responsible for controlling player character's movements and high-level states
- [ ] Create the `companion` app, which is similar to `player`, but is AI-controlled

Questions yet to be answered:
- [ ] How to play music and sounds?
- [ ] How to properly isolate controls?


## Tactical Todolist

- [x] django app structure
- [x] tests inside testsuits inside apps
- [x] pytest's parametrizing
- [x] store and cache creation
- [x] pytest's fixtures
- [x] switching rooms in tests (flat test signature array, enter test room before each test, run test after room was created, run assert on room start event, start next test immediately after)
- [ ] menu app (new game, continue game, exit, load savefile, write savefile)
