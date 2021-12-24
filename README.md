![JSONConverter logo](/Screenshots/logo.jpg)

English | [简体中文](./README.zh-CN.md)

JSONConverter
============
JSONConverter is an auxiliary tool developed for iOS/Flutter/Android/Server on MAC. It can quickly format JSON data and convert and generate corresponding model class attributes. It currently supports Java/Objective-C/Dart/Golang/Swift and popular libraries: [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON), [HandyJSON](https://github.com/alibaba/HandyJSON), [ObjectMapper](https://github.com/tristanhimmelman/ObjectMapper), you can flexibly choose to build Class/Struct, save the trouble of typing the model by hand, and greatly improve the development efficiency.

Why use JSONConverter
======

| Features | JSONConverter | JSONExport |
| ------ | ------ | ------ |
| Custom configuration | powerful | support |
| Response | promptly | Recently 2019 |
| Open source or free | ✅ | ✅  |
| Dark mode | ✅ | ❌ |
| Rich text display | ✅ | ❌ |
| Automatic hump | ✅ | ❌ |
| Class name anti-weight | ✅ | ❌ |
| Type inference | ✅ | ❌ |
| Integrity check | ✅ | ❌ |
| JSON verification | ✅ | ✅  |
| Class/Struct | ✅ | ❌ |
| Java | ✅ | ✅ |
| Swift | ✅ | ✅ |
| Objective-C | ✅ | ✅ |
| Flutter | ✅ | ❌ |
| Golang | ✅ | ❌ |
| ... | |  |


Features
=======
* Quickly convert JSON data to generate model classes and attributes corresponding to the supported languages.
* Format rich text to display JSON data, support [185 languages ​​and 89 styles](https://highlightjs.org/static/demo/)
* Preview and export the generated corresponding rich text model class
* Configure the root class name
* Configuration class prefix
* Custom class file prefix
* Automatic conversion of underscore hump
* globalization
* Array model attribute integrity check

Currently supported languages
=============================
- 1. Swift(Class/Struct)
    - 1.1 HandyJSON
    - 1.2 SwiftyJSON
    - 1.3 ObjectMapper
    - 1.4 Codable
- 2. Objective-C
- 3. Flutter
- 4. Java
- 5. Golang
- if you have other needs, you can let us know by [issues](https://github.com/DevYao/JSONConverter/issues)

Screenshots
========================
![objc.png](/Screenshots/objc.png)
![swift.png](/Screenshots/swift.png)
![swiftyjson.png](/Screenshots/swiftyjson.png)
![objectmapper.png](/Screenshots/objectmapper.png)
![flutter.png](/Screenshots/flutter.png)
![golang.png](/Screenshots/golang.png)

Installation
============
* clone the project, and build it using Xcode, then copy the app to applicaiton
* Download [Release Packages](https://github.com/DevYao/JSONConverter/releases)

To Do
=====
* HTTP Request
* Support C Struct
* Support C++ Class/Struct
* Support Kotlin Class/Struct

Flutter instructions
========================
* [json_serializable](https://github.com/dart-lang/json_serializable)

Final
==========
* The application still in its early stage. Please report any issue so I can improve it, If you like it, please give a star to encourage a wave 😁

License
========================
JSONConverter is available under custom version of **MIT** license.
