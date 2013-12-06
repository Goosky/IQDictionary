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
- (NSArray *)allKeysForObject:(id)anObject;
- (NSArray *)allValues;

- (void)setObject:(id)anObject forKey:(id <NSCopying>)aKey;
- (void)removeObjectForKey:(id)aKey;
- (void)removeAllObjects;
- (void)removeObjectsForKeys:(NSArray *)keyArray;
//sort
- (void)sortKeyUsingComparator:(NSComparator)cmptr;
//class functions
+ (instancetype)dictionary;
+ (instancetype)dictionaryWithCapacity:(NSUInteger)capacity;
+ (instancetype)dictionaryWithObject:(id)object forKey:(id <NSCopying>)key;
+ (instancetype)dictionaryWithObjects:(NSArray *)objects forKeys:(NSArray *)keys;
+ (instancetype)dictionaryWithDictionary:(NSDictionary *)dict;
@end
