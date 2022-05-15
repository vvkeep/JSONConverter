![JSONConverter](/Screenshots/logo.png)

English | [简体中文](./README.zh-CN.md)

JSONConverter
============
A MacOS application with beautiful interface and powerful functions, it formats JSON and generates model class code in the corresponding language, supports multiple development languages and its popular third-party class libraries, multiple configuration options, and flexibly builds classes

Features
========
* Custom adjustment layout, rich text display, theme switching (support [185 languages and 89 styles](https://highlightjs.org/static/demo/))
* The configuration items are automatically memorized, no need to repeat the configuration every time
* JSON verification, class name anti-duplication, type deduction, powerful functions
* Preview and export the generated corresponding rich text model class
* Automatic conversion of custom configuration file header, root class name, parent class name, class prefix, and underscore camel case to meet various personalized needs
* Array model attribute integrity check to generate the most complete model
* ...

Supported languages
=============================
- 1. Swift(Class/Struct)
    - 1.1 [HandyJSON](https://github.com/alibaba/HandyJSON)
    - 1.2 [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON)
    - 1.3 [ObjectMapper](https://github.com/Hearst-DD/ObjectMapper)
    - 1.4 Codable
    - 1.5 [KakaJSON](https://github.com/kakaopensource/KakaJSON)
- 2. Objective-C
    - 1.1 [YYModel](https://github.com/ibireme/YYModel)
    - 1.2 [MJExtension](https://github.com/CoderMJLee/MJExtension)
- 3. Flutter
- 4. Java
- 5. Golang

Screenshots
========================
![01.png](/Screenshots/01.png)
![02.png](/Screenshots/02.png)
![03.png](/Screenshots/03.png)
![04.png](/Screenshots/04.png)
![05.png](/Screenshots/05.png)
![06.png](/Screenshots/06.png)
![07.png](/Screenshots/07.png)

Install
============
- Direct download [Release Packages](https://github.com/vvkeep/JSONConverter/releases)
- Clone source code, execute build in Xcode, copy JSONConverter.app to Application folder

Notes
=====
* The Flutter JSON conversion function is compatible with [json_serializable](https://github.com/dart-lang/json_serializable)

Others
======
Because some languages or frameworks have not been actually used, I do not know whether the model construction is reasonable. If you have better suggestions, please submit PR/Issues, thank you! , If you like it, please click a star to encourage me！ 😁
