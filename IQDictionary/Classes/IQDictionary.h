//
//  IQDictionary.h
//  IQDictionary
//
//  Created by BruceZCQ on 13-12-6.
//  Copyright (c) 2013年 OpeningO,Inc ( http://openingo.github.com ). All rights reserved.
//

#import <Foundation/Foundation.h>

#define kIQDictionaryAESPasswordKey        @"IQDictionaryAESPasswordKey"

@interface IQDictionary : NSObject
//instance functions
- (NSArray *)allKeys;
- (NSArray *)allKeysUsingComparator:(NSComparator)cmptr;
- (NSArray *)allKeysForObject:(id)anObject;
- (NSArray *)allKeysForObject:(id)anObject usingComparator:(NSComparator)cmptr;
- (NSArray *)allValues;
- (NSArray *)allValuesForSortedKeyUsingComparator:(NSComparator)cmptr;
- (NSArray *)allValuesForSortedUsingComparator:(NSComparator)cmptr;
//init dictionary
- (id)initWithCapacity:(NSUInteger)capacity;
- (id)initWithDictionary:(NSDictionary *)dict;
- (id)initWithCapacity:(NSUInteger)capacity
              password:(NSString *)password;
- (id)initWithDictionary:(NSDictionary *)dict
                password:(NSString *)password;
- (NSArray *)objectsForKey:(id)aKey;
- (NSUInteger)objectCountForKey:(id)key;
- (void)setObject:(id)anObject forKey:(id <NSCopying>)aKey;
- (void)removeObjectsForKey:(id)aKey;
- (void)removeAllObjects;
//class functions
+ (instancetype)dictionary;
+ (instancetype)dictionaryWithCapacity:(NSUInteger)capacity;
//encryption
+ (instancetype)dictionaryWithPassword:(NSString *)password;
+ (instancetype)dictionaryWithCapacity:(NSUInteger)capacity
                              password:(NSString *)password;
@end
