![JSONConverter](/Screenshots/logo.png)

简体中文 | [English](./README.md)

JSONConverter
=============
一款界面精美、功能强大的MacOS应用，格式化JSON并生成对应语言的模型类代码，支持多种开发语言及其流行的三方类库，多种配置选项，灵活构建Class/Struct，一键导出模型类文件，极大提高开发效率。

功能简介
=======
* 自定义调整布局、富文本展示、主题切换（支持[185种语言和89种样式](https://highlightjs.org/static/demo/)）
* 配置项自动记忆，无需每次重复配置
* JSON校验、类名防重、类型推导，功能强大
* 预览并导出生成的对应富文本模型类
* 自定义配置文件头、根类名、父类名、类前缀、下划线驼峰自动转换，满足各种个性化需求
* 数组模型属性完整性检查，生成最完整的模型
* ...


支持的语言
============
- 1. Swift(Class/Struct)
    - 1.1 [HandyJSON](https://github.com/alibaba/HandyJSON)
    - 1.2 [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON)
    - 1.3 [ObjectMapper](https://github.com/Hearst-DD/ObjectMapper)
    - 1.4 Codable
    - 1.5 [KakaJSON](https://github.com/kakaopensource/KakaJSON)
- 2. Objective-C
    - 1.1 [YYModel](https://github.com/ibireme/YYModel)
    - 1.2 [MJExtension](https://github.com/CoderMJLee/MJExtension)
    - 1.3 [jsonmodel](https://github.com/jsonmodel/jsonmodel)
- 3. Flutter
- 4. Java
- 5. Golang

应用预览
======
![01.png](/Screenshots/01.png)
![02.png](/Screenshots/02.png)
![03.png](/Screenshots/03.png)
![04.png](/Screenshots/04.png)
![05.png](/Screenshots/05.png)
![06.png](/Screenshots/06.png)
![07.png](/Screenshots/07.png)

安装
======
- 直接下载 [Release Packages](https://github.com/vvkeep/JSONConverter/releases)
- Clone源码，Xcode执行Build，拷贝JSONConverter.app 至 Application 文件夹

说明
===
Flutter JSON转换功能是配合[json_serializable](https://github.com/dart-lang/json_serializable)使用，具体的使用说明可以查看以下说明
* [Flutter-快速完成JosnModel的转换](https://www.jianshu.com/p/8e22a383bc4b)
* [JSON和序列化](https://flutterchina.club/json/)

其他
===
因为有些语言或框架并没有实际使用过，所以并不知道模型构建的是否合理，如果你有更好的建议，欢迎提PR/Issues，谢谢！,如果喜欢，请点个star，鼓励一波，哈哈哈哈😁

[![Stargazers repo roster for @vvkeep/JSONConverter](https://reporoster.com/stars/vvkeep/JSONConverter)](https://github.com/vvkeep/JSONConverter/stargazers)
