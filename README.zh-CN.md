![JSONConverter logo](/Screenshots/logo.jpg)

简体中文 | [English](./README.md)

JSONConverter
=============
 JSONConverter是MAC上iOS/Flutter/Android/Server等开发的辅助工具，可以快速的格式化JSON数据并转换生成对应的模型类属性，目前支持Java/Objective-C/Dart/Golang/Swift及流行的第三方库: [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON)、[HandyJSON](https://github.com/alibaba/HandyJSON)，[KakaJSON](https://github.com/kakaopensource/KakaJSON),[ObjectMapper](https://github.com/Hearst-DD/ObjectMapper),可以灵活选择构建Class/Struct，省去手敲模型的麻烦，极大提高开发效率。

应用比较
======

| 特性 | JSONConverter | JSONExport |
| ------ | ------ | ------ |
| 自定义配置 | 丰富 | 一般 |
| 问题响应 | 响应及时 | 最近维护2019年 |
| 开源或免费 | ✅ | ✅  |
| 暗黑模式切换 | ✅ | ❌ |
| 富文本展示 | ✅ | ❌ |
| 自动驼峰 | ✅ | ❌ |
| 类名防重 | ✅ | ❌ |
| 类型推导 | ✅ | ❌ |
| 完整性检查 | ✅ | ❌ |
| JSON校验 | ✅ | ✅  |
| Class/Struct | ✅ | ❌ |
| Java | ✅ | ✅ |
| Swift | ✅ | ✅ |
| Objective-C | ✅ | ✅ |
| Flutter | ✅ | ❌ |
| Golang | ✅ | ❌ |
| ... | |  |

功能介绍
=======
* 快速的把JSON数据转换生成对应支持的语言的模型类和属性.
* 格式化富文本展示JSON数据,支持[185种语言和89种样式](https://highlightjs.org/static/demo/) 
* 预览并导出生成的对应富文本模型类
* 配置根类名
* 配置类前缀
* 自定义类文件前缀
* 下划线驼峰自动转换
* 国际化
* 数组模型属性完整性检查


当前支持的语言
============
- 1. Swift(Class/Struct)
    - 1.1 HandyJSON
    - 1.2 SwiftyJSON
    - 1.3 ObjectMapper
    - 1.4 Codable
    - 1.5 KakaJSON
- 2. Objective-C
- 3. Flutter
- 4. Java
- 5. Golang
- 如果你还有其他需要，可以通过[issues](https://github.com/vvkeep/JSONConverter/issues)告诉我

应用预览
======
![objc.png](/Screenshots/objc.png)
![swift.png](/Screenshots/swift.png)
![swiftyjson.png](/Screenshots/swiftyjson.png)
![objectmapper.png](/Screenshots/objectmapper.png)
![flutter.png](/Screenshots/flutter.png)
![golang.png](/Screenshots/golang.png)

安装说明
======
* 使用Xcode Build，拷贝JSONConverter.app 至 Application 文件夹
* 直接下载 [Release Packages](https://github.com/vvkeep/JSONConverter/releases)

开发计划
======
* 实现HTTP请求
* 支持 C Struct 转换
* 支持 C++ Struct/Class 转换
* 支持 Kotlin 转换

Flutter 说明
===========
因为Flutter JSON转换功能是配合[json_serializable](https://github.com/dart-lang/json_serializable)使用，具体的使用说明可以查看以下说明
* [Flutter-快速完成JosnModel的转换](https://www.jianshu.com/p/8e22a383bc4b)
* [JSON和序列化](https://flutterchina.club/json/)

声明
===
因为，有些语言或框架并没有实际使用过，所以并不知道模型构建的是否合理，如果你有更好的建议，欢迎提PR/Issues，大家共同进步，谢谢！,如果喜欢，请给一个star，鼓励一波，哈哈哈哈😁
