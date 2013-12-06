//
//  IQDictionary.m
//  IQDictionary
//
//  Created by BruceZCQ on 13-12-6.
//  Copyright (c) 2013年 OpeningO,Inc ( http://openingo.github.com ). All rights reserved.
//

#import "IQDictionary.h"

@interface IQDictionary()
{
    NSMutableDictionary *_mapping; // Key ~ Value
    NSMutableArray *_keys;  // all keys
    NSMutableArray *_values;    //all values
    NSUInteger _capacity;   //diction capacity
}
@end

@implementation IQDictionary

#pragma mark - Class Functions Common

+ (instancetype)shareWithCapacity:(NSUInteger)capacity
{
    static IQDictionary *__shareIQDictionary = nil;
    
    static dispatch_once_t mmSharedDbOnceToken;
    dispatch_once(&mmSharedDbOnceToken, ^{
        __shareIQDictionary = [[IQDictionary alloc] initWithCapacity:capacity];
    });
    
    return __shareIQDictionary;
}

#pragma mark - Class Functions

+ (instancetype)dictionary
{
    return [self shareWithCapacity:0];
}

+ (instancetype)dictionaryWithCapacity:(NSUInteger)capacity
{
    return [self shareWithCapacity:capacity];
}

+ (instancetype)dictionaryWithDictionary:(NSDictionary *)dict
{
    static IQDictionary *__shareIQDictionary = nil;
    
    static dispatch_once_t mmSharedDbOnceToken;
    dispatch_once(&mmSharedDbOnceToken, ^{
        __shareIQDictionary = [[IQDictionary alloc] initWithDictionary:dict];
    });
    
    return __shareIQDictionary;
}

+ (instancetype)dictionaryWithObject:(id)object
                              forKey:(id<NSCopying>)key
{
    return [self dictionaryWithObjects:[NSArray arrayWithObject:object]
                               forKeys:[NSArray arrayWithObject:key]];
}

+ (instancetype)dictionaryWithObjects:(NSArray *)objects
                              forKeys:(NSArray *)keys
{
    static IQDictionary *__shareIQDictionary = nil;
    
    static dispatch_once_t mmSharedDbOnceToken;
    dispatch_once(&mmSharedDbOnceToken, ^{
        __shareIQDictionary = [[IQDictionary alloc] initWithObjects:objects
                                                            forKeys:keys];
    });
    
    return __shareIQDictionary;
}

#pragma mark - Init IQDictionary

- (id)initWithCapacity:(NSUInteger)capacity
{
    if (self = [super init]) {
        [self createWithCapacity:capacity];
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self resetWithDictionary:dict];
    }
    return self;
}

- (id)initWithObjects:(NSArray *)objects forKeys:(NSArray *)keys
{
    if (self = [super init]) {
        _mapping = [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
        _capacity = _mapping.count;
        _keys = [NSMutableArray arrayWithArray:_mapping.allKeys];
        _values = [NSMutableArray arrayWithArray:_mapping.allValues];
    }
    return self;
}


#pragma mark - Instances Function Common

- (void)initIQDictionaryValues
{
    for (int8_t i = 0; i < _keys.count; i++) {
        NSMutableArray *value = [NSMutableArray array];
        [_values addObject:value];
    }
}

- (void)createWithCapacity:(NSUInteger)capacity
{
    _capacity = capacity;
    _mapping = [NSMutableDictionary dictionaryWithCapacity:_capacity];
    _keys = [NSMutableArray array];
    _values = [NSMutableArray array];
}

- (void)resetWithDictionary:(NSDictionary *)dict
{
    if (dict == nil) {
        [self createWithCapacity:0];
        return;
    }
    if (_mapping != dict) {
        _mapping = [NSMutableDictionary dictionaryWithDictionary:dict];
    }
    _capacity = _mapping.count;
    _keys = [NSMutableArray arrayWithArray:_mapping.allKeys];
    _values = [NSMutableArray arrayWithArray:_mapping.allValues];
}

#pragma mark - Instance Functions

- (NSArray *)allKeys
{
    return _keys;
}

- (NSArray *)allValues
{
    return _values;
}

- (NSArray *)allKeysForObject:(id)anObject
{
    return nil;
}

- (void)setObject:(id)anObject forKey:(id<NSCopying>)aKey
{
    if (_mapping == nil) {
        [self createWithCapacity:0];
    }
    [_mapping setObject:anObject forKey:aKey];
    [self resetWithDictionary:_mapping];
}

- (void)removeObjectForKey:(id)aKey
{
    if (_mapping == nil) {
        [self createWithCapacity:0];
        return;
    }
    [_mapping removeObjectForKey:aKey];
    [self resetWithDictionary:_mapping];
}

- (void)removeObjectsForKeys:(NSArray *)keyArray
{
    if (_mapping == nil) {
        [self createWithCapacity:0];
        return;
    }
    [_mapping removeObjectsForKeys:keyArray];
    [self resetWithDictionary:_mapping];
}

- (void)removeAllObjects
{
    if (_mapping == nil) {
        [self createWithCapacity:0];
        return;
    }
    [_mapping removeAllObjects];
    [self resetWithDictionary:_mapping];
}

#pragma mark - Sort

- (void)sortKeyUsingComparator:(NSComparator)cmptr
{
    
}

@end
