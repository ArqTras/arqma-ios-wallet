# Installation

**Before building iOS Libraries, please have a look at the [Pre-requisites](#pre-requisites)**

1. Clone the repository.
```sh
git clone https://github.com/arqma/arqma-ios-wallet.git
```
2. Install [homebrew](https://brew.sh/)
3. Install arqma dependencies:
```sh
brew install pkgconfig
brew install cmake
brew install zeromq
```
4. Install Cocoa Pods
```sh
sudo gem install cocoapods
```
5. Build the arqma iOS libraries.
```sh
./install.sh
./build.sh
```
6. Install dependencies from Pod.
```sh
pod install
```

### Shared library building problems

You may get an error such as:
```
ld: symbol(s) not found for architecture armv7
```

If you get this issue then make sure that boost has been correctly built. You can check this by seeing if it exists at `Libraries/boost/builds/libs`. If the folder doesn't exist then run `./scripts/install_boost.sh` in the root director and check to see if any errors occur there.

### XCode Building problems
If you're having problems building with Xcode 10 or above then change to the `Legacy Build System`

> We use forked the repo of [ofxiOSBoost](https://github.com/malbit/ofxiOSBoost/tree/arqma). We do this ONLY for more convenient installation process.
