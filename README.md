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
2. Every change to the store, cache or idmap should not happen on the fly and should be instead represented as a query. 
3. Any piece of code should be tied to a specific isolated app (application, game, menu, entity, location, slideshow, dialog, order). Every app should be generally similar to the others in terms of structure (store, cache, idmap, start, stop, testsuits, fixtures)
4. No controlling objects as instances allowed on instance layers. Controlling objects should be in-memory, so that they would not have to be carried from one layer to another and managed. Only entity instances should be present on instance layers.
5. It is prohibited to keep in store anything which cannot be serialized, but it is allowed to keep unserializable data structures in cache and idmap, given that they are used more than once.
6. This repository doesn't have a configured CI, but each commit to the `main` branch is guaranteed to have all tests passing on my machine. I don't know if is possible to run CI for GameMaker projects, maybe I will try something in the future.

## Apps

### Tosoengine

Tosoengine is the first and most important app, which represents this game engine. It is responsible for initializing apps and storages, and running tosotest or application, depending on how the game was called.

### Tosotest

Tosotest is a testing framework. The goal behind it is to be as pytest-like as possible, supporting fixtures and parametrizing, but not too complex, since GameMaker is not good for metaprogramming and developing packages.

## To Do

- [x] django app structure
- [x] tests inside testsuits inside apps
- [x] pytest's parametrizing
- [x] store and cache creation
- [ ] pytest's fixtures
- [ ] switching rooms in tests (flat test signature array, enter test room before each test, run test after room was created, run assert on room start event, start next test immediately after)
- [ ] menu app (new game, continue game, exit, load savefile, write savefile)
