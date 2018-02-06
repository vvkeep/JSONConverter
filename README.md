YWJsonModelConverter
==========
YWJsonModelConverter 是MAC上iOS开发的辅助小工具，可以快速的把json数据转换生成对应的模型类属性，完美贴合Swift的知名第三方库 [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON)、[HandyJSON](https://github.com/alibaba/HandyJSON)，省去手动创建的麻烦，借此提高我们的开发效率。

效果
========================

1. Java for .
2. Java for [Realm](http://realm.io) Android.
3. GSON for Android
4. Swift Classes.
5. Swift Classes for [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON) library.
6. Swift Classes for [Realm](http://realm.io).
7. Swift - CoreData.
8. Swift Structures.
9. Swift Structures for [Gloss](https://github.com/hkellaway/Gloss)
10. Swift Mappable Classes for (Swift 3) [ObjectMapper](https://github.com/Hearst-DD/ObjectMapper)
11. Swift Structures for [Unbox](https://github.com/JohnSundell/Unbox)
12. Objective-C - iOS.
13. Objective-C - MAC.
14. Objective-C - CoreData.
15. Objective-C for [Realm](http://realm.io) iOS.



Screenshot shows JSONExport used for a snippet from Twitter timeline JSON and converting it to Swift-CoreData.
![alt tag](https://cloud.githubusercontent.com/assets/5157350/5228493/72693010-7713-11e4-9e42-625a8590424a.png)

Installation
========================
Kindly clone the project, and build it using xCode 8 and above.

To Do
========================
* ~~Support Objective-C~~ Done
* ~~Sync multible classes with the same name or have the same exact properties~~ Done
* ~~Support to parse JSON arrays of objects~~ Done
* Load JSON data from web
* ~~Open .json files from JSONExport~~
* Supported languages management editor.
* Beside raw JSON, load the model raw data from plist files as well.


Known Limitations:
========================
* When exporting to subclasses of NSManagedObject, some data types can not be exported. For example core data does not have data type for "array of strings"; in turn, if your JSON contains an array of strings, the exported file will not compile without you fixing the type mismatch.
* When exporting subclasses of RLMObject, you will have to enter the default values of premitive types manually. This is because of dynamic properties limition that prevents you from having an optional premitive type.
* When exporting to CoreData or Realm and you want to use the utility methods, you will need to manually watch for deep relation cycle calls; that is, when you convert an object to dictionary, this object try to convert one of its relation to a dictionary and the relation tries to convert the original object to a dictionary, that will cause a kind of cycle where each object involved calls the other object's toDictionary method infenitly...
* Avoid attempt to model a JSON object with empty values, because JSONExport does not understand empty values and can not guess their types.
* Deep nesting of arrays and objects will not be exported in a proper model files.


Final Note
========================
The application still in its early stage. Please report any issue so I can improve it.

License
========================
JSONExport is available under custom version of **MIT** license.
