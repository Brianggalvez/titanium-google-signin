# Ti.GoogleSignIn 
[![License](http://hans-knoechel.de/shields/shield-license.svg)](./LICENSE)  [![Contact](http://hans-knoechel.de/shields/shield-twitter.svg)](http://twitter.com/hansemannnn)

 Summary
---------------
Ti.GoogleSignIn is an open-source project to support the Google SignIn iOS-SDK in Appcelerator's Titanium Mobile. 

Requirements
---------------
  - Titanium Mobile SDK 5.5.1.GA or later
  - iOS 7.1 or later
  - Xcode 7.3 or later

Download + Setup
---------------

### Download
  * [Stable release](https://github.com/hansemannn/Ti.GoogleSignIn/releases)
  * [![gitTio](http://hans-knoechel.de/shields/shield-gittio.svg)](http://gitt.io/component/ti.googlesignin)

### Setup
Unpack the module and place it inside the `modules/iphone/` folder of your project.
Edit the modules section of your `tiapp.xml` file to include this module:
```xml
<modules>
    <module platform="iphone">ti.googlesignin</module>
</modules>
```

Initialize the module by setting the Google SignIn API key you can get from the Google API Console.
```javascript
var Google = require('ti.googlesignin');
Google.initialize({
    clientId: '<client-id>'
});
```
#### Methods
- [x] `signIn`
- [x] `signInSilently`
- [x] `signOut`
- [x] `disconnect`

#### Events
- [x] `login`
- [x] `disconnect`
- [x] `load`
- [x] `open`
- [x] `close`

The `login`- and `disconnect` events include a `user` key that includes the following user-infos:
```
id, scopes, serverAuthCode, hostedDomain, profile, authentication
```

### Build
If you want to build the module from the source, you need to check some things beforehand:
- Set the `TITANIUM_SDK_VERSION` inside the `ios/titanium.xcconfig` file to the Ti.SDK version you want to build with.
- Build the project with `appc run -p ios --build-only`
- Check the [releases tab](https://github.com/hansemannn/ti.googlesignin/releases) for stable pre-packaged versions of the module

### Features
TBA

### Example
For a full example, check the demos in `example/app.js` and `example/clustering.js`.

### Author
Hans Knoechel ([@hansemannnn](https://twitter.com/hansemannnn) / [Web](http://hans-knoechel.de))

### License
Apache 2.0

### Contributing
Code contributions are greatly appreciated, please submit a new [pull request](https://github.com/hansemannn/ti.googlesignin/pull/new/master)!