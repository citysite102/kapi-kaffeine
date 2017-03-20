TOC
------------------------------------------------------------------------
- [JSON](#markdown-header-json)
- [Macro Defines](#markdown-header-macro-defines)
- [Log](#markdown-header-log)
- [Paths](#markdown-header-paths)
- [App Session](#markdown-header-app-session)
- [Zoom Image View](#markdown-header-zoom-image-view)
- [Data Structures](#markdown-header-data-structures)
- [UIKit](#markdown-header-uikit)
- [Misc](#markdown-header-misc)
    - [Pull to refresh control](#markdown-header-pull-to-refresh-control)
    - [Text View](#markdown-header-text-view)
    - [Uncaught Exception Handler](#markdown-header-uncaught-exception-handler)
    - [URL Encoding](#markdown-header-url-encoding)
    - [Container Segue](#markdown-header-container-segue)


JSON
------------------------------------------------------------------------
JSONKit is dead. Thus we use `NSJSONSerialization` which comes after
iOS 5.

For string and data:

- jsonObject

For array and dictionary:

- jsonString
- jsonData



Macro Defines
------------------------------------------------------------------------
Check `BenzeneFoundation/BFDefines.h` for all macros we provide.

- String Format (in C style function call, keep code clean)
- App Bundle ID shortcut
- Device type
- Block execution
- Run Loop
- Error output

- iOS Version Checking
> For example, you can use `IOS_IS_NEWER_THAN_OR_EQUALS_TO_7_0` to call new API in iOS 7.
> According to Apple's documentation, you are recommended to check class existence 
> or method respondence first before using this version check directly.

- Float equal and zero
> Compare float value with `FLT_EPSILON`



Log
------------------------------------------------------------------------
It's more powerful than` NSLog`. It prints the method name, file name, and line number
of this `BFLog` call when printing the log message

It's useful when your third party code keeps printing garbage `NSLog`.

> ```#define NSLog  ```

And use `BFLog` and `BFSimpleLog` (which is the same as *NSLog*)



Paths
------------------------------------------------------------------------
A category for NSFileManager which provides a quick link to find paths at user domain.
It provides:

- Document Folder
- Library Folder (Global and Local)
- Cache Folder (Global and Local)
- Application Support Folder (Global and Local)

For example, global library path gives you

`<# APP_SANDBOX_ROOT #>/Library`

and local one gives

`<# APP_SANDBOX_ROOT #>/Library/com.example.your.app.id`



App Session
------------------------------------------------------------------------
A dictionary which resets (clean) its value to default value whenever 
user leaves and comes back to the app.

You can also set a time interval. The dictionary is reset only when 
user leaves your app and comes back after the time interval passed.

> Default Session: `@{ @"dataLoaded": @(NO) }`, 30min Session: `@{ @"dataLoaded": @(NO) }`

And now the data has been loaded

> Default Session: `@{ @"dataLoaded": @(YES) }`, 30min Session: `@{ @"dataLoaded": @(YES) }`

Then user leaves the app and comes back in 15 mins

> Default Session: `@{ @"dataLoaded": @(NO) }`, 30min Session: `@{ @"dataLoaded": @(YES) }`



Zoom Image View
------------------------------------------------------------------------
Zoom image view with UIScrollView and UITapGestureRecognizer



Data structures
------------------------------------------------------------------------
- Pair
- Queue
- Stack
- keyed subscription for NSCache
- Reverse method for NSArray
- Partially load a binary file into NSData



UIKit
------------------------------------------------------------------------
- Draw simple UIImage like a small color block image.
- DIP like rotate and resize
- Color and HEX string


Misc
------------------------------------------------------------------------

### Pull to refresh control
Bi-directional pull to refresh control



### Text View
Text view with place holder



### Uncaught Exception Handler
Block edition of NSUncaughtExceptionHandler. 
It also provides runtime information like call stack, device info, and app info to you.
Btw, it also calls previously set NSUncaughtExceptionHandler.



### URL Encoding
Categories for NSString and NSDictionary to do URL encoding/decoding
Check `BenzeneFoundation/BFURLEncoding.h`



### Container Segue
Provide view controller container segue available from iOS 6 to iOS 5.
