Tetloop
=======

Infinite tile-matching game with Sprite Kit.

[Available on the App Store](https://itunes.apple.com/us/app/tetloop/id916468176).

# Installation

## 1. Clone project

```
$ git clone git@github.com:tnantoka/tetloop.git
$ cd tetloop/
$ pod install
$ open Tetloop.xcworkspace/
```

## 2. Create `TLSecrets.h`

For AdMob.

```
#ifndef Tetloop_TLSecrets_h
#define Tetloop_TLSecrets_h

static NSString * const kAdMobId = @"ca-app-pub-xxxxxxxxxxxxxxxx/nnnnnnnnnn";

#endif
```

## 3. Remove optional assets

Not included in this repository.

* `Assets/crash.caf`
* `Assets/break.caf`
* `Assets/Mosamosa-v1.1.ttf`

# Author

[@tnantoka](https://twitter.com/tnantoka)
