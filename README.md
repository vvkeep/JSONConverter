JSONConverter
==========
JSONConverter 是MAC上iOS开发的辅助小工具，可以快速的把json数据转换生成对应的模型类属性，目前支持Objective-C、Swift、Flutter以及目前流行的第三方库: [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON)、[HandyJSON](https://github.com/alibaba/HandyJSON)，[ObjectMapper](https://github.com/Hearst-DD/ObjectMapper),可以灵活选择构建class/struct，并支持配置类名前缀等,省去手敲模型的麻烦，借此提高我们的开发效率。

支持的功能
========================
* Objective-C、Swift(Codeable, SwiftyJSON, HandyJSON, ObjectMapper)、Flutter 对应的模型转化
* 版本更新自动提醒
* 转换配置缓存，默认保存上一次转换的配置，无需每次转换都要选择对应的语言和类型
* 黑暗模式
* ...

部分语言转换展示
========================
**1.Json转Flutter**
![Json转ObectMapper.png](https://upload-images.jianshu.io/upload_images/2240549-82c59edfe2b783d1.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1000/format/webp)

**2.Json转ObectMapper**
![Json转ObectMapper.png](http://upload-images.jianshu.io/upload_images/2240549-9df1e76d252546be.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

**3.Json转Swift-Struct**
 ![Json转Swift-Struct.png](http://upload-images.jianshu.io/upload_images/2240549-13e2e83e7eabd753.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

**4.Json转HandyJSON**
![Json转HandyJSON.png](http://upload-images.jianshu.io/upload_images/2240549-d456ae73a17d2a52.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

**5.Json转SwiftyJSON**
![Json转SwiftyJSON.png](http://upload-images.jianshu.io/upload_images/2240549-be6939e3d3795d27.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

**6.Json转ObjectMapper**
![Json转ObhectMapper.png](http://upload-images.jianshu.io/upload_images/2240549-f94dbef231b7dd63.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

**7.Json转Objective-C**
![Json转Objective-C.png](http://upload-images.jianshu.io/upload_images/2240549-d01d60d19bd3f4de.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

安装说明
========================
* Swift 版本 4.0.0
* clone 这个工程，使用Xcode9及以上运行
* 可以点击[releases](https://github.com/iosyaowei/JSONConverter/releases)选择最新的版本点击JSONConverter.zip, 下载解压后拖入Application


Fluter转换备注
========================
因为,使用Flutter Json转换功能是配合[json_serializable](https://github.com/dart-lang/json_serializable)使用，具体的使用说明可以查看以下说明
* [Flutter-快速完成JosnModel的转换](https://www.jianshu.com/p/8e22a383bc4b)
* [JSON和序列化](https://flutterchina.club/json/)

声明
========================
因为，并没有在项目中实际使用过[SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON)、[ObjectMapper](https://github.com/Hearst-DD/ObjectMapper)，所以并不知道初始化方法构建的是否合理，如果你有更好的建议，欢迎留言，大家共同进步，谢谢！,如果喜欢，请给一个star，鼓励一波，哈哈哈哈😁

参考项目
========================
* [WHC_DataModelFactory](https://github.com/netyouli/WHC_DataModelFactory)
* [HandyJSON](https://github.com/alibaba/HandyJSON)
* [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON)
* ...
