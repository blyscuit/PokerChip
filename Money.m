//
//  Money.m
//  PokerChip
//
//  Created by Pisit Wetchayanwiwat on BE2556/04/14.
//  Copyright (c) 仏暦2556年 betaescape. All rights reserved.
//

#import "Money.h"

@implementation Money

-(id)initWithMutableArray:(NSMutableArray *)initMutableArray
{
    self = [super init];
    arrMoney = [[NSMutableArray alloc]initWithArray:initMutableArray copyItems:YES];
}

@end
