//
//  Money.h
//  PokerChip
//
//  Created by Pisit Wetchayanwiwat on BE2556/04/14.
//  Copyright (c) 仏暦2556年 betaescape. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Money : NSObject
{
    NSMutableArray *arrMoney;
}

-(id)initWithMutableArray:(NSMutableArray *)initMutableArray;
@property (nonatomic,retain) NSMutableArray *arrMoney;

@end
