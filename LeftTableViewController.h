//
//  LeftTableViewController.h
//  PokerChip
//
//  Created by Pisit Wetchayanwiwat on BE2556/05/24.
//  Copyright (c) 仏暦2556年 betaescape. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface LeftTableViewController : UITableViewController<AVAudioPlayerDelegate>{
    NSMutableArray *arrPlayerMoney;
    NSMutableArray *arrTemp;
    AVAudioPlayer *avPlayer;

}

@property (nonatomic)NSInteger intBetting;

@end
