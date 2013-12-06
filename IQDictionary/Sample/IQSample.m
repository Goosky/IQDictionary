//
//  IQSample.m
//  IQDictionary
//
//  Created by BruceZCQ on 13-10-26.
//  Copyright (c) 2013年 OpeningO,Inc ( http://openingo.github.com ). All rights reserved.
//

#import "IQSample.h"
#import "IQDictionary.h"

@implementation IQSample

- (void)sample
{
    IQDictionary *iqDictionary0 = [IQDictionary dictionaryWithDictionary:@{ @"iqdict_0_key1":@"iqdict_0_values1", @"iqdict_0_key2":@"iqdict_0_value2" }];
    [iqDictionary0 setObject:@"iqdict_0_value3" forKey:@"iqdict_0_key3"];

    return;
    IQDictionary *iqDictionary1 = [IQDictionary dictionaryWithCapacity:0];
    [iqDictionary1 setObject:@"iqdict_1_value1" forKey:@"iqdict_1_key1"];
    [iqDictionary1 setObject:@"iqdict_1_value2" forKey:@"iqdict_1_key2"];
}

@end
