https://developer.garmin.com/connect-iq/sdk/

Monkey C:
```
using Toybox.Application as App;
using Toybox.System;

class MyProjectApp extends App.AppBase {

    // onStart() is called on application start up
    function onStart(state) {
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
        return [ new MyProjectView() ];
    }
}
```

Properties:
- duck typed, throw an error at runtime
- functions are not first time citizens
- object oriented programming with compiled classes (static)
- support for arrays and dictionnaries
- there is a concept of "symbol": a unique identifier in the entire program. You can use it as a dictionary key, or as an enum value.
