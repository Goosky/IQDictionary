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
    }
    return self;
}


#pragma mark - Instances Function Common

- (void)createWithCapacity:(NSUInteger)capacity
{
    _capacity = capacity;
    _mapping = [NSMutableDictionary dictionaryWithCapacity:_capacity];
    _keys = [NSMutableArray array];
}

- (void)resetWithDictionary:(NSDictionary *)dict
{
    if (dict == nil || dict.count == 0) {
        [self createWithCapacity:0];
        return;
    }
    if (_mapping != dict) {
        _mapping = [NSMutableDictionary dictionaryWithDictionary:dict];
    }
    _capacity = _mapping.count;
    _keys = [NSMutableArray arrayWithArray:_mapping.allKeys];
}

#pragma mark - Instance Functions

- (NSArray *)allKeys
{
    if (_mapping == nil || _mapping.count == 0) {
        [self createWithCapacity:0];
    }
    return _keys;
}

- (NSArray *)allKeysUsingComparator:(NSComparator)cmptr
{
    if (_mapping == nil || _mapping.count == 0) {
        [self createWithCapacity:0];
        return _keys;
    }
    
    if (_keys == nil || _keys.count == 0) {
        return [NSArray array];
    }
    
    [_keys sortUsingComparator:cmptr];
    [_keys sortedArrayWithOptions:NSSortConcurrent usingComparator:cmptr];
    
    return _keys;
}

- (NSArray *)allValues
{
    if (_mapping == nil || _mapping.count == 0) {
        [self createWithCapacity:0];
        return [NSArray array];
    }
    
    NSMutableArray *values = [NSMutableArray array];
    
    NSArray *allValuesForMapping = [_mapping allValues];//[[],[],[]]
    for (int8_t i = 0; i < allValuesForMapping.count; i++) {
        NSMutableArray *value = [allValuesForMapping objectAtIndex:i];
        [values addObjectsFromArray:value];
    }
    
    return [NSArray arrayWithArray:values];
}

- (NSArray *)allValuesForSortedKeyUsingComparator:(NSComparator)cmptr
{
    if (_mapping == nil || _mapping.count == 0) {
        [self createWithCapacity:0];
        return [NSArray array];
    }
    
    //sort
    [_keys sortUsingComparator:cmptr];
    
    NSMutableArray *values = [NSMutableArray array];

    for (int8_t keyIdx = 0; keyIdx < _keys.count; keyIdx++) {
        id key = [_keys objectAtIndex:keyIdx];
        NSMutableArray *valuesForkey = [_mapping objectForKey:key];
        [values addObjectsFromArray:valuesForkey];
    }
    
    return [NSArray arrayWithArray:values];
}


- (NSArray *)allValuesForSortedUsingComparator:(NSComparator)cmptr
{
    if (_mapping == nil || _mapping.count == 0) {
        [self createWithCapacity:0];
        return [NSArray array];
    }
    
    NSMutableArray *allValues = [NSMutableArray arrayWithArray:[self allValues]];
    [allValues sortUsingComparator:cmptr];
    return [NSArray arrayWithArray:allValues];
}

- (NSArray *)allKeysForObject:(id)anObject
{
    if (anObject == nil) {
        return [NSArray array];
    }
    
    if ([anObject isKindOfClass:[NSString class]] && [anObject isEqualToString:@""]) {
        return [NSArray array];
    }
    
    if (_mapping == nil || _mapping.count == 0) {
        [self createWithCapacity:0];
        return [NSArray array];
    }
    
    NSMutableArray *allKeys = [NSMutableArray array];
    
    for (int8_t keyIdx = 0; keyIdx < _keys.count; keyIdx++) {
        id key = [_keys objectAtIndex:keyIdx];
        NSMutableArray *valuesForkey = [_mapping objectForKey:key];
        for (int8_t valueIdx = 0; valueIdx < valuesForkey.count; valueIdx++) {
            id object = [valuesForkey objectAtIndex:valueIdx];
            if (object == anObject && ![allKeys containsObject:key]) {
                [allKeys addObject:key];
            }
        }
    }
    
    return [NSArray arrayWithArray:allKeys];
}

- (NSArray *)allKeysForObject:(id)anObject usingComparator:(NSComparator)cmptr
{
    if (anObject == nil) {
        return [NSArray array];
    }
    
    if ([anObject isKindOfClass:[NSString class]] && [anObject isEqualToString:@""]) {
        return [NSArray array];
    }
    
    if (_mapping == nil || _mapping.count == 0) {
        [self createWithCapacity:0];
        return [NSArray array];
    }
    
    NSMutableArray *allkeysForObject = [NSMutableArray arrayWithArray:[self allKeysForObject:anObject]];
    [allkeysForObject sortUsingComparator:cmptr];
    
    return allkeysForObject;
}

- (NSArray *)objectsForKey:(id)aKey
{
    if (aKey == nil) {
        return [NSArray array];
    }
    
    if ([aKey isKindOfClass:[NSString class]] && [aKey isEqualToString:@""]) {
        return [NSArray array];
    }
    
    if (_mapping == nil || _mapping.count == 0) {
        [self createWithCapacity:0];
        return [NSArray array];
    }
    
    NSArray *values = [NSArray array];
    
    for (int8_t keyIdx = 0; keyIdx < _keys.count; keyIdx++) {
        id key = [_keys objectAtIndex:keyIdx];
        if (aKey == key) {
           values = [_mapping objectForKey:key];
            break;
        }
    }
    return values;
}

- (NSUInteger)objectCountForKey:(id)key
{
    if (key == nil) {
        return 0;
    }
    
    if ([key isKindOfClass:[NSString class]] && [key isEqualToString:@""]) {
        return 0;
    }
    
    return [self objectsForKey:key].count;
}

- (void)setObject:(id)anObject forKey:(id<NSCopying>)aKey
{
    if (aKey == nil) {
        return;
    }
    
    if (_mapping == nil || _mapping.count == 0) {
        [self createWithCapacity:0];
    }
    
    NSMutableArray *valueObject =  nil;
    if ([_keys containsObject:aKey]) {
        valueObject = [_mapping objectForKey:aKey];
        if (valueObject == nil) {
            valueObject = [NSMutableArray array];
        }
        [valueObject addObject:anObject];
    }else{
        valueObject = [NSMutableArray array];
        [valueObject addObject:anObject];
        [_mapping setObject:valueObject forKey:aKey];
    }
    
    [self resetWithDictionary:_mapping];
}

- (void)removeObjectsForKey:(id)aKey
{
    if (aKey == nil) {
        return;
    }
    
    if ([aKey isKindOfClass:[NSString class]] && [aKey isEqualToString:@""]) {
        return;
    }
    
    if (_mapping == nil || _mapping.count == 0) {
        [self createWithCapacity:0];
        return;
    }
    [_mapping removeObjectForKey:aKey];
    
    [self resetWithDictionary:_mapping];
}

- (void)removeObjectsForKeys:(NSArray *)keyArray
{
    if (keyArray == nil || keyArray.count == 0) {
        return;
    }
    
    if (_mapping == nil || _mapping.count == 0) {
        [self createWithCapacity:0];
        return;
    }
    [_mapping removeObjectsForKeys:keyArray];
    
    [self resetWithDictionary:_mapping];
}

- (void)removeAllObjects
{
    if (_mapping == nil || _mapping.count == 0) {
        [self createWithCapacity:0];
        return;
    }
    [_mapping removeAllObjects];
    
    [self resetWithDictionary:_mapping];
}

@end
