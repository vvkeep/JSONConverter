
简体中文 | [English](./README.md)


JSONConverter
==========
 是MAC上iOS开发的辅助小工具，可以快速的把json数据转换生成对应的模型类属性，目前支持Objective-C、Swift、Flutter以及目前流行的第三方库: [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON)、[HandyJSON](https://github.com/alibaba/HandyJSON)，[ObjectMapper](https://github.com/Hearst-DD/ObjectMapper),可以灵活选择构建class/struct，并支持配置类名前缀等,省去手敲模型的麻烦，借此提高我们的开发效率。

JSONConverter
============
JSONConverter是MAC上iOS开发的辅助工具，. 
目前支持的主要功能如下:
* 快速的把JSON数据转换生成对应支持的语言的模型类和属性.
* 格式化富文本展示JSON数据
* 预览生成的对应富文本模型类
* 配置根类名
* 配置类前缀
* 自定义类文件前缀.
* 支持国际化

当前支持的语言
============
- 1. Swift(Class/Struct)
    - 1.1 HandyJSON
    - 1.2 SwiftyJSON
    - 1.3 ObjectMapper
    - 1.4 Codable
- 2. Objective-C
- 3. Flutter

应用截图
========================
![1.png](/Screenshots/1.png)
![2.png](/Screenshots/2.png)
![3.png](/Screenshots/3.png)
![4.png](/Screenshots/4.png)
![5.png](/Screenshots/4.png)

安装说明
============
* 使用Xcode Build，拷贝JSONConverter.app 至 Application 文件夹
* 下载 [Release Packages](https://github.com/DevYao/JSONConverter/releases)，选择最新的版本安装包

开发计划
=====
* 支持Java 模型转换
* 支持模型文件导出
* ~~富文本展示模型~~

Flutter 模型使用说明
========================
因为Flutter JSON转换功能是配合[json_serializable](https://github.com/dart-lang/json_serializable)使用，具体的使用说明可以查看以下说明
* [Flutter-快速完成JosnModel的转换](https://www.jianshu.com/p/8e22a383bc4b)
* [JSON和序列化](https://flutterchina.club/json/)

声明
========================
因为，并没有在项目中实际使用过[SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON)、[ObjectMapper](https://github.com/Hearst-DD/ObjectMapper)，所以并不知道初始化方法构建的是否合理，如果你有更好的建议，欢迎留言，大家共同进步，谢谢！,如果喜欢，请给一个star，鼓励一波，哈哈哈哈😁