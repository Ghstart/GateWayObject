//
//  GateWayObject.h
//  GateWayObject
//
//  Created by 龚欢 on 2017/5/5.
//  Copyright © 2017年 龚欢. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GateWayObject : NSObject

@property (nonatomic, readonly) NSString    *currentRelateURL;

///////////-init-//////////////
/*
 ** 获得当前的网管
 */

+ (GateWayObject *)currentGateWay;

/*
 ** 网管实例化方法
 ** 默认网关
 */
+ (GateWayObject *)sharedInstanceWithDefaultURL:(NSString *)url;

/*
 ** 网关实例化
 ** 可以配置一些默认的URL对应的一些网关
 */
+ (GateWayObject *)sharedInstanceWithDefaultURL:(NSString *)url ReflectURLS:(NSDictionary *)reflectURLS;

/*
 ** 设置网关
 */
- (void)setGateWayURL:(NSString *)url forKeyObject:(id)keyObject;

/*
 ** 设置默认的一些网关，优先级仅次于http/https
 */
- (void)setDefaultRelativeURL:(NSString *)relativeURL fullURL:(NSString *)fullURL;

/*
 ** 根据之前的设置的身份切换网管
 ** 返回值为true则切换成功 false失败
 */
- (BOOL)swichGateWayBaseOn:(id)keyObject;

/*
 ** 取得当前URL
 */
- (NSString *)currentURLBaseOnRelativeURL:(NSString *)url;

@end
