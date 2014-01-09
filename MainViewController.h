//
//  MainViewController.h
//  PokerChip
//
//  Created by Pisit Wetchayanwiwat on BE2556/03/11.
//  Copyright (c) 仏暦2556年 betaescape. All rights reserved.
//

#import "FlipsideViewController.h"
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, UIPopoverControllerDelegate,AVAudioPlayerDelegate,UIActionSheetDelegate>
{
    bool lastMan;
    AVAudioPlayer *avPlayer;
}


@property (strong, nonatomic) UIPopoverController *flipsidePopoverController;
//@property (nonatomic,retain) Money *moneyModel;
@property (weak, nonatomic) IBOutlet UILabel *currentMoney;
- (IBAction)addFive:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *betting;
@property (weak, nonatomic) IBOutlet UILabel *playerNumber;
- (IBAction)addTen:(id)sender;
- (IBAction)addTF:(id)sender;
- (IBAction)addL:(id)sender;
- (IBAction)addC:(id)sender;
@property (weak, nonatomic) IBOutlet UISlider *cashInSlider;
- (IBAction)sliderChange:(id)sender;
- (IBAction)allIn:(id)sender;
- (IBAction)bet:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *currentIn;
@property (weak, nonatomic) IBOutlet UILabel *currentBetting;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIButton *hundredBtt;
@property (weak, nonatomic) IBOutlet UIButton *fivtyBtt;
@property (weak, nonatomic) IBOutlet UIButton *twentyfiveBtt;
@property (weak, nonatomic) IBOutlet UIButton *tenBtt;
@property (weak, nonatomic) IBOutlet UIButton *fiveBtt;
@property (weak, nonatomic) IBOutlet UILabel *playerStaticLbl;
@property (weak, nonatomic) IBOutlet UIButton *betBtt;
- (IBAction)pop:(id)sender;

@property (assign)NSInteger intCurrentIn;
@property (assign)NSInteger intBetting;
@property (assign)NSInteger intTurn;
@property (assign)NSInteger intTurnMax;
@property (strong)NSMutableArray *arrMoney;
@property (strong)NSMutableArray *arrFolding;
@property (strong)NSMutableArray *arrCurrentBetting;

-(void)resetGame;
-(void)refreshScreen;
-(void)readNumbersFromFile;


@end
