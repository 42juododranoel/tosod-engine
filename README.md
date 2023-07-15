# TOSOD Game Engine

TOSOD engine is a game engine made by me on top of the GameMaker Studio. It powers my top-down pixel RPG, which will be released later.

What's inside:
- [x] Django-like apps structure
- [x] Pytest-inspired testing framework with paramerizing
- [x] Nuxt-inspired store, mutations and rendering
- [ ] ...

## Documentation

### General Rules

1. Everything which is displayed at every frame on screen should be declaratively described with three types of storages: store, cache and idmap. It is prohibited to render any piece of code which is not saved in either store, cache or idmap.
2. It is prohibited to keep any non-framework related data in any places other than under `content` folder. This means that code should be complitely separated from plot, characters, sprites, dialogs, and other data. The data should be 100% declarative, meaning that you should be able to change anything in plot by editing structs and arrays, without touching any code components at all.
3. Every change to the store, cache or idmap should not happen on the fly and should be instead represented as a query. 
4. Any piece of code should be tied to a specific isolated app (application, game, menu, entity, location, slideshow, dialog, order). Every app should be generally similar to the others in terms of structure (store, cache, idmap, start, stop, testsuits, fixtures)
5. No controlling objects as instances allowed on instance layers. Controlling objects should be in-memory, so that they would not have to be carried from one layer to another and managed. Only entity instances should be present on instance layers.
6. It is prohibited to keep in store anything which cannot be serialized, but it is allowed to keep unserializable data structures in cache and idmap, given that they are used more than once.
7. This repository doesn't have a configured CI, but each commit to the `main` branch is guaranteed to have all tests passing on my machine. I don't know if is possible to run CI for GameMaker projects, maybe I will try something in the future.

## Apps

### Tosoengine

Tosoengine is the first and most important app, which represents this game engine. It is responsible for initializing apps and storages, and running tosotest or application, depending on how the game was called.

### Tosotest

Tosotest is a testing framework. The goal behind it is to be as pytest-like as possible, supporting fixtures and parametrizing, but not too complex, since GameMaker is not good for metaprogramming and developing packages.

## Strategic Roadmap

- [x] Create the `engine` app, with base app and framework structure to use later for every single component and piece of code
- [x] Create the `application` app, responsible for storing all application-level constants and switching between `menu` and `game`  
- [ ] (in progress) Create a testing framework THE RIGHT WAY (the Pytest way, with fixtures and parametrizing), because code without tests is legacy by design even in gamedev
- [ ] Create the `menu` app, which should greet users and provide them with start/continue/exit features
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
- [ ] pytest's fixtures
- [ ] switching rooms in tests (flat test signature array, enter test room before each test, run test after room was created, run assert on room start event, start next test immediately after)
- [ ] menu app (new game, continue game, exit, load savefile, write savefile)
