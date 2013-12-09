//
//  IQDictionary.m
//  IQDictionary
//
//  Created by BruceZCQ on 13-12-6.
//  Copyright (c) 2013年 OpeningO,Inc ( http://openingo.github.com ). All rights reserved.
//

#import "IQDictionary.h"
#import "AESCrypt.h"

@interface IQDictionary()
{
    NSMutableDictionary *_mapping; // Key ~ Value
    NSMutableArray *_keys;  // all keys
    NSUInteger _capacity;   //diction capacity
    NSString *_password;    //password
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

+ (instancetype)shareWithCapacity:(NSUInteger)capacity
                         password:(NSString *)password
{
    static IQDictionary *__shareIQDictionary = nil;
    
    static dispatch_once_t mmSharedDbOnceToken;
    dispatch_once(&mmSharedDbOnceToken, ^{
        __shareIQDictionary = [[IQDictionary alloc] initWithCapacity:capacity
                                                            password:password];
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

+ (instancetype)dictionaryWithPassword:(NSString *)password
{
    return [self shareWithCapacity:0 password:password];
}
+ (instancetype)dictionaryWithCapacity:(NSUInteger)capacity
                              password:(NSString *)password
{
    return [self shareWithCapacity:capacity password:password];
}

#pragma mark - Init IQDictionary

- (id)initWithCapacity:(NSUInteger)capacity
{
    if (self = [super init]) {
        [self createWithCapacity:capacity];
    }
    return self;
}

- (id)initWithCapacity:(NSUInteger)capacity
              password:(NSString *)password
{
    if (self = [super init]) {
        [self createWithCapacity:capacity];
        _password = password;
        NSAssert( !(_password == nil || [_password isEqualToString:@""]) , @"IQDictionary Password cannot empty");
        [self savePassword];
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

- (id)initWithDictionary:(NSDictionary *)dict
                password:(NSString *)password
{
    if (self = [super init]) {
        [self resetWithDictionary:dict];
        _password = password;
        NSAssert( !(_password == nil || [_password isEqualToString:@""]) , @"IQDictionary Password cannot empty");
        [self savePassword];
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

- (void)updateKeysReferenceArray:(NSArray *)array
{
    if (_keys != nil || _keys.count != 0) {
        [_keys removeAllObjects];
    }
    
    if (_keys == nil) {
        return;
    }
    
    for (int8_t i = 0; i < array.count; i++) {
        id key = [array objectAtIndex:i];
        if ([key isKindOfClass:[NSString class]]) {
            [_keys addObject:[self encryptKey:key]];
        }
        [_keys addObject:key];
    }
}

#pragma mark - Encrypt and Decrypt values and keys

- (void)savePassword
{
    [[NSUserDefaults standardUserDefaults] setValue:_password
                                             forKey:kIQDictionaryAESPasswordKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)password
{
    if (_password != nil && ![_password isEqualToString:@""]) {
        return _password;
    }
    return [[NSUserDefaults standardUserDefaults] objectForKey:kIQDictionaryAESPasswordKey];
}

- (id)encryptObject:(id)object
{
    id ret = object;
    NSString *password = [self password];
    if (object != nil
        && [object isKindOfClass:[NSString class]]
        && password != nil
        && ![password isEqualToString:@""]) {
        ret = [AESCrypt encrypt:object password:password];
    }
    return ret;
}

- (id)decryptObject:(id)object
{
    if (object == nil) {
        return nil;
    }
    
    id ret = object;
    NSString *password = [self password];
    if ([object isKindOfClass:[NSString class]]
        && password != nil
        && ![password isEqualToString:@""]) {
        ret = [AESCrypt decrypt:object password:password];
    }
    return ret;
}

- (id)encryptKey:(id)key
{
    return [self encryptObject:key];
}

- (id)decryptKey:(id)key
{
    return [self decryptObject:key];
}

#pragma mark - Instance Functions

- (NSArray *)allKeys
{
    if (_mapping == nil || _mapping.count == 0) {
        [self createWithCapacity:0];
    }
    
    NSMutableArray *keys = [NSMutableArray arrayWithCapacity:_keys.count];
    for (int8_t i = 0; i < _keys.count; i++) {
        id key = [_keys objectAtIndex:i];
        key = [self decryptKey:key];
        [keys addObject:key];
    }
    
    return [NSArray arrayWithArray:keys];
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
    
    NSMutableArray *allkeys = [NSMutableArray arrayWithArray:[self allKeys]];
    [allkeys sortUsingComparator:cmptr];
    //update keys
    [self updateKeysReferenceArray:allkeys];
    
    return [NSArray arrayWithArray:allkeys];
}

- (NSArray *)allValues
{
    if (_mapping == nil || _mapping.count == 0) {
        [self createWithCapacity:0];
        return [NSArray array];
    }
    
    
    NSArray *allValuesForMapping = [_mapping allValues];//[[],[],[]]
    NSMutableArray *encryptValues = [NSMutableArray array];
    for (int8_t i = 0; i < allValuesForMapping.count; i++) {
        id value = [allValuesForMapping objectAtIndex:i];
        if ([value isKindOfClass:[NSMutableArray class]]) {
            [encryptValues addObjectsFromArray:value];
        }
    }
    
    //decrypt values
    NSMutableArray *values = [NSMutableArray array];
    for (int8_t i = 0; i < encryptValues.count; i++) {
        id value = [encryptValues objectAtIndex:i];
        value = [self decryptObject:value];
        [values addObject:value];
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
    
    NSMutableArray *allkeys = [NSMutableArray arrayWithArray:[self allKeys]];
    [allkeys sortUsingComparator:cmptr];
    //update keys
    [self updateKeysReferenceArray:allkeys];
    
    
    NSMutableArray *encryptValues = [NSMutableArray array];
    
    for (int8_t keyIdx = 0; keyIdx < _keys.count; keyIdx++) {
        id key = [_keys objectAtIndex:keyIdx];
        id valuesForkey = [_mapping objectForKey:key];
        if ([valuesForkey isKindOfClass:[NSMutableArray class]]) {
            [encryptValues addObjectsFromArray:valuesForkey];
        }
    }
    
    NSMutableArray *values = [NSMutableArray array];
    for (int8_t i = 0; i < encryptValues.count; i++) {
        id value = [encryptValues objectAtIndex:i];
        value = [self decryptObject:value];
        [values addObject:value];
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
    
    id decryptObject = [self decryptObject:anObject];
    
    NSMutableArray *allKeys = [NSMutableArray array];
    
    if ([anObject isKindOfClass:[NSString class]]) {
        for (int8_t keyIdx = 0; keyIdx < _keys.count; keyIdx++) {
            id key = [_keys objectAtIndex:keyIdx];
            id newKey = [self decryptKey:key];
            NSMutableArray *valuesForkey = [_mapping objectForKey:key];
            for (int8_t valueIdx = 0; valueIdx < valuesForkey.count; valueIdx++) {
                id object = [valuesForkey objectAtIndex:valueIdx];
                if (object != nil
                    && newKey != nil
                    && ![allKeys containsObject:newKey]) {
                    if([object isKindOfClass:[NSString class]]
                       && [object isEqualToString:decryptObject]) {
                        [allKeys addObject:newKey];
                    }else if (anObject == object){
                        [allKeys addObject:newKey];
                    }
                }
            }
        }
    }else{
        for (int8_t keyIdx = 0; keyIdx < _keys.count; keyIdx++) {
            id key = [_keys objectAtIndex:keyIdx];
            id newKey = [self decryptKey:key];
            NSMutableArray *valuesForkey = [_mapping objectForKey:key];
            for (int8_t valueIdx = 0; valueIdx < valuesForkey.count; valueIdx++) {
                id object = [valuesForkey objectAtIndex:valueIdx];
                if (object == anObject && ![allKeys containsObject:newKey]) {
                    [allKeys addObject:newKey];
                }
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
    
    NSMutableArray *values = [NSMutableArray array];
    
    if ([aKey isKindOfClass:[NSString class]]) {
        id encryptKey = [self encryptKey:aKey];
        NSMutableArray *encryptedValues = [NSMutableArray array];
        for (int8_t keyIdx = 0; keyIdx < _keys.count; keyIdx++) {
            id key = [_keys objectAtIndex:keyIdx];
            id value = [_mapping objectForKey:key];
            if ([key isKindOfClass:[NSString class]]
                && [encryptKey isEqualToString:key]
                && [value isKindOfClass:[NSMutableArray class]]) {
                [encryptedValues addObjectsFromArray:value];
            }
        }
        
        for (int8_t i = 0; i < encryptedValues.count; i++) {
            id value = [encryptedValues objectAtIndex:i];
            if ([value isKindOfClass:[NSString class]]) {
                value = [self decryptObject:value];
            }
            [values addObject:value];
        }
        
    }else{
        for (int8_t keyIdx = 0; keyIdx < _keys.count; keyIdx++) {
            id key = [_keys objectAtIndex:keyIdx];
            if (aKey == key){
                values = [_mapping objectForKey:key];
            }
        }
    }
    
    return [NSMutableArray arrayWithArray:values];
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
    
    id object = [self encryptObject:anObject];
    if (object == nil) {
        return;
    }
    
    id key = [self encryptKey:aKey];
    if (key == nil) {
        return;
    }
    
    if ([_keys containsObject:key]) {
        valueObject = [_mapping objectForKey:key];
        if (valueObject == nil) {
            valueObject = [NSMutableArray array];
        }
        [valueObject addObject:object];
    }else{
        valueObject = [NSMutableArray array];
        [valueObject addObject:object];
        [_mapping setObject:valueObject forKey:key];
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
    
    id key = [self encryptKey:aKey];
    if (key == nil) {
        return;
    }
    [_mapping removeObjectForKey:key];
    
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
