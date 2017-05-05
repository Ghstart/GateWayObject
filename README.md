# GateWayObject

[![CI Status](http://img.shields.io/travis/Ghstart/GateWayObject.svg?style=flat)](https://travis-ci.org/Ghstart/GateWayObject)
[![Version](https://img.shields.io/cocoapods/v/GateWayObject.svg?style=flat)](http://cocoapods.org/pods/GateWayObject)
[![License](https://img.shields.io/cocoapods/l/GateWayObject.svg?style=flat)](http://cocoapods.org/pods/GateWayObject)
[![Platform](https://img.shields.io/cocoapods/p/GateWayObject.svg?style=flat)](http://cocoapods.org/pods/GateWayObject)

## Example

GateWayObject is a middleware between the Client and Network, Easy handle baseURL and Easy Swich it.

Init and Config

```
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
self.window = [[RootWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

//1.设置默认URL，就是其中一种身份对应的URL
//2.设置一些URL的映射，不会根据之前身份设置来修改
[GateWayObject sharedInstanceWithDefaultURL:@"https://cz.redlion56.com/gwcz/"
ReflectURLS:@{
@"user/login.do": @"https://login.redlion56.com/gwlogin/user/login.do",
@"uic/user/logout.do": @"https://cz.redlion56.com/gwcz/uic/user/logout.do"
}];

// 3. 设置乘客身份对应的网管                          
[[GateWayObject currentGateWay] setGateWayURL:@"https://cz.redlion56.com/gwcz/"
forKeyObject:carownerRole];

// 4.设置乘客对应的网管
[[GateWayObject currentGateWay] setGateWayURL:@"https://sj.redlion56.com/gwsj/"
forKeyObject:driverRole];
}
```


Swich GateWay

```
// 5.并且还可以根据相应的条件来切换网管
if (xxx) {

[[GateWayObject currentGateWay] swichGateWayBaseOn:carownerRole];

} else {

[[GateWayObject currentGateWay] swichGateWayBaseOn:driverRole];
}
```

Return URL

```
NSString *URL = [[GateWayObject currentGateWay] currentURLBaseOnRelativeURL:url];
// 7.直接可以取得次环境下对应的正确URL
[self GET:URL
parameters:parameters
success:^(NSURLSessionDataTask *task, id responseObject) {
}
} failure:^(NSURLSessionDataTask *task, NSError *error) {
if (failure && error.code != -999 && ![error.localizedDescription isEqualToString:@"已取消"]) {
failure(error);
}
}];

```




## Requirements

## Installation


```ruby
pod "GateWayObject"
```

## Author

Ghstart, gonghuan2020@gmail.com

## License

GateWayObject is available under the MIT license. See the LICENSE file for more info.
