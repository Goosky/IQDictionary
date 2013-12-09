//
//  IQSample.m
//  IQDictionary
//
//  Created by BruceZCQ on 13-10-26.
//  Copyright (c) 2013年 OpeningO,Inc ( http://openingo.github.com ). All rights reserved.
//

#import "IQSample.h"
#import "IQDictionary.h"
#import "AESCrypt.h"

@implementation IQSample

- (void)sample
{
    IQDictionary *iqDictionary = [[IQDictionary alloc] initWithCapacity:0];
    [iqDictionary setObject:@"value01" forKey:@"key01"];
    [iqDictionary setObject:@"value02" forKey:@"key02"];
    [iqDictionary setObject:@"value31" forKey:@"key03"];
    [iqDictionary setObject:@"value32" forKey:@"key03"];
    [iqDictionary setObject:@"value32" forKey:@"key03"];
    [iqDictionary setObject:@"value33" forKey:@"key03"];
    [iqDictionary setObject:@"value04" forKey:@"key04"];
    [iqDictionary setObject:@"value05" forKey:@"key05"];
    [iqDictionary setObject:@"value06" forKey:@"key06"];
    [iqDictionary setObject:@"value07" forKey:@"key07"];
    [iqDictionary setObject:@"value10" forKey:@"key10"];
    [iqDictionary setObject:@"value17" forKey:@"key17"];
    [iqDictionary setObject:@"value09" forKey:@"key09"];
    [iqDictionary setObject:@"value08" forKey:@"key08"];
    [iqDictionary setObject:@"value12" forKey:@"key12"];
    [iqDictionary setObject:@"value14" forKey:@"key14"];
    [iqDictionary setObject:@"value25" forKey:@"key25"];
    NSLog(@"objectsForkey %@",[iqDictionary objectsForKey:@"key03"]);
    NSLog(@"all keys %@",[iqDictionary allKeys]);
    NSLog(@"allkey count %d",[iqDictionary allKeys].count);
    NSArray *allkeys = [iqDictionary allKeysUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }];
    NSLog(@"allKeys Sorted %@",allkeys);
    NSLog(@"allkey Sorted count %d",allkeys.count);
    NSLog(@"allValues %@",[iqDictionary allValues]);
    NSLog(@"allValues Sorted key%@",[iqDictionary allValuesForSortedKeyUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }]);
    NSLog(@"allValues Sorted values%@",[iqDictionary allValuesForSortedUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }]);
    [iqDictionary removeObjectsForKey:@"key03"];
    NSLog(@"after remove Object for key"); NSLog(@"objectsForkey %@",[iqDictionary objectsForKey:@"key03"]);
    NSLog(@"all keys %@",[iqDictionary allKeys]);
    NSLog(@"allKeys Sorted %@",[iqDictionary allKeysUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }]);
    
    NSLog(@"allValues %@",[iqDictionary allValues]);
    NSLog(@"allValues Sorted key%@",[iqDictionary allValuesForSortedKeyUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }]);
    NSLog(@"allValues Sorted values%@",[iqDictionary allValuesForSortedUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }]);
    
    NSLog(@"IQDcitionary with password");
    
    IQDictionary *iqDictWithPassword = [[IQDictionary alloc] initWithCapacity:0 password:@"zcq"];
    [iqDictWithPassword setObject:@"value11" forKey:@"key1"];
    [iqDictWithPassword setObject:@"value12" forKey:@"key1"];
    [iqDictWithPassword setObject:@"value13" forKey:@"key1"];
    [iqDictWithPassword setObject:@"value2" forKey:@"key2"];
    [iqDictWithPassword setObject:@"value3" forKey:@"key3"];
    [iqDictWithPassword setObject:@"value4" forKey:@"key4"];
    [iqDictWithPassword setObject:@"value5" forKey:@"key5"];
    NSLog(@"objectforkey %@",[iqDictWithPassword objectsForKey:@"key1"]);
}

@end
