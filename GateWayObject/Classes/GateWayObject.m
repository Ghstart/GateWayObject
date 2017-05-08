//
//  GateWayObject.m
//  GateWayObject
//
//  Created by 龚欢 on 2017/5/5.
//  Copyright © 2017年 龚欢. All rights reserved.
//

#import "GateWayObject.h"

@interface GateWayObject ()

@property (nonatomic, strong) NSArray      *config;
@property (nonatomic, strong) NSString     *currentRelateURL;
@property (nonatomic, strong) NSString     *defaultURL;
@property (nonatomic, strong) NSDictionary *defaultURLSReflectDatas;
@property (nonatomic, strong) NSRecursiveLock *lock;

@end

@implementation GateWayObject

static GateWayObject *gateWayObject = nil;

#pragma mark - Init

+ (GateWayObject *)currentGateWay {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gateWayObject                           = [[GateWayObject alloc] init];
        gateWayObject.config                    = gateWayObject.config == nil ? nil : gateWayObject.config;
        gateWayObject.defaultURLSReflectDatas   = gateWayObject.defaultURLSReflectDatas == nil ? nil : gateWayObject.defaultURLSReflectDatas;
    });
    return gateWayObject;
    
}

+ (GateWayObject *)sharedInstanceWithDefaultURL:(NSString *)url {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gateWayObject = [GateWayObject currentGateWay];
        if (url != nil && ![url isEqualToString:@""]) gateWayObject.defaultURL = url;
    });
    return gateWayObject;
}

+ (GateWayObject *)sharedInstanceWithDefaultURL:(NSString *)url ReflectURLS:(NSDictionary *)reflectURLS {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gateWayObject = [GateWayObject currentGateWay];
        if (reflectURLS != nil && reflectURLS.count > 0) {
            gateWayObject.defaultURLSReflectDatas = reflectURLS;
        } else {
            gateWayObject.defaultURLSReflectDatas = [NSDictionary new];
        }
        if (url != nil && ![url isEqualToString:@""]) gateWayObject.defaultURL = url;
    });
    return gateWayObject;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gateWayObject = [super allocWithZone:zone];
    });
    return gateWayObject;
}

- (id)copyWithZone:(NSZone *)zone
{
    return gateWayObject;
}

- (void)setGateWayURL:(NSString *)url forKeyObject:(id)keyObject {
    [self.lock lock];
        if (keyObject != nil && url != nil && ![url isEqualToString:@""]) {
            
            NSMutableArray *tempSetDatas;
            if ([GateWayObject currentGateWay].config == nil ||
                [GateWayObject currentGateWay].config.count == 0) {
                
                tempSetDatas = [NSMutableArray new];
            } else {
                
                tempSetDatas = [[GateWayObject currentGateWay].config mutableCopy];
            }
            
            NSMutableDictionary *tempDicCollection = [NSMutableDictionary new];

                [tempDicCollection setObject:url forKey:keyObject];

            if (tempDicCollection) [tempSetDatas addObject:tempDicCollection];
            if (tempSetDatas) [GateWayObject currentGateWay].config = [tempSetDatas copy];
        }
    [self.lock unlock];
}

- (void)setDefaultRelativeURL:(NSString *)relativeURL fullURL:(NSString *)fullURL {
    
    [self.lock lock];
    NSAssert(relativeURL != nil && ![relativeURL isEqualToString:@""], @"相对路径不能为空");
    NSAssert(fullURL != nil && ![fullURL isEqualToString:@""], @"全路径不能为空");
    NSAssert([fullURL hasPrefix:@"http"] || [fullURL hasPrefix:@"https"], @"全路径非法");
    
    NSMutableDictionary *tempReflectURLCollectionDatas;
    if ([GateWayObject currentGateWay].defaultURLSReflectDatas) {
        tempReflectURLCollectionDatas = [[GateWayObject currentGateWay].defaultURLSReflectDatas mutableCopy];
    } else {
        tempReflectURLCollectionDatas = [NSMutableDictionary new];
    }
    
    [tempReflectURLCollectionDatas setObject:fullURL forKey:relativeURL];
    [GateWayObject currentGateWay].defaultURLSReflectDatas = [tempReflectURLCollectionDatas copy];
    [self.lock unlock];
}

#pragma mark - Getter Methods

- (NSString *)currentRelateURL {
    
    NSString *tempCurrentURL;
    if ([GateWayObject currentGateWay].defaultURL != nil && ![[GateWayObject currentGateWay].defaultURL isEqualToString:@""]) {
        return [GateWayObject currentGateWay].defaultURL;
    }
    
    if ([GateWayObject currentGateWay].config != nil && [GateWayObject currentGateWay].config.count > 0 ) {
        return [[GateWayObject currentGateWay].config lastObject];
    }
    
    NSAssert(tempCurrentURL != nil && ![tempCurrentURL isEqualToString:@""], @"defaultURL 和 config数据都没有设置");
    
    return tempCurrentURL;
}

- (BOOL)swichGateWayBaseOn:(id)keyObject {
    
    if (keyObject != nil) {
        
        if ([GateWayObject currentGateWay].config.count > 0) {
            for (NSDictionary *gateDatas in [GateWayObject currentGateWay].config) {
                
                if ([[gateDatas allKeys] containsObject:keyObject]) {
                    
                    [GateWayObject currentGateWay].defaultURL = [gateDatas objectForKey:keyObject];
                    
                    return YES;
                }
                
            }
            return NO;
        }
        return NO;
    }
    return NO;
}


- (NSString *)currentURLBaseOnRelativeURL:(NSString *)url {
    
    NSAssert(url != nil && ![url isEqualToString:@""], @"相对路径不能为空");
    NSAssert([GateWayObject currentGateWay].currentRelateURL != nil && ![[GateWayObject currentGateWay].currentRelateURL isEqualToString:@""], @"当前网关不能为空");
    
    if ([url hasPrefix:@"http"] || [url hasPrefix:@"https"]) {
        return url;
    }
    
    if ([GateWayObject currentGateWay].defaultURLSReflectDatas.count > 0 &&
        [[[GateWayObject currentGateWay].defaultURLSReflectDatas allKeys] containsObject:url]) {
        
        return [[GateWayObject currentGateWay].defaultURLSReflectDatas objectForKey:url];
    }
    
    return [[NSString stringWithFormat:@"%@%@",[GateWayObject currentGateWay].currentRelateURL,url] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return @"";
}

#pragma mark - Getter Methods

- (NSRecursiveLock *)lock {
    if (_lock == nil) {
        _lock = [NSRecursiveLock new];
    }
    return _lock;
}


@end
