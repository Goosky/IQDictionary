//
//  IQDictionary.h
//  IQDictionary
//
//  Created by BruceZCQ on 13-12-6.
//  Copyright (c) 2013年 OpeningO,Inc ( http://openingo.github.com ). All rights reserved.
//

#import <Foundation/Foundation.h>

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
- (id)initWithObjects:(NSArray *)objects forKeys:(NSArray *)keys;
- (NSArray *)objectsForKey:(id)aKey;
- (NSUInteger)objectCountForKey:(id)key;
- (void)setObject:(id)anObject forKey:(id <NSCopying>)aKey;
- (void)removeObjectsForKey:(id)aKey;
- (void)removeAllObjects;
- (void)removeObjectsForKeys:(NSArray *)keyArray;
//class functions
+ (instancetype)dictionary;
+ (instancetype)dictionaryWithCapacity:(NSUInteger)capacity;
@end
