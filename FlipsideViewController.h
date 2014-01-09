//
//  FlipsideViewController.h
//  PokerChip
//
//  Created by Pisit Wetchayanwiwat on BE2556/03/11.
//  Copyright (c) 仏暦2556年 betaescape. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
//#import "Money.h"

@class FlipsideViewController;

@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end

@interface FlipsideViewController : UIViewController <UIActionSheetDelegate, UITextFieldDelegate, UIScrollViewDelegate, MFMailComposeViewControllerDelegate>{
    NSArray *arrNumberList;
    NSInteger numberPlay;
    NSMutableArray *arrPlayerMoney;
    id <UITextFieldDelegate> textFieldDelegate;
    NSArray *scrollImageList;
    BOOL tutorial;
}

@property (weak, nonatomic) id <FlipsideViewControllerDelegate> delegate;

- (IBAction)done:(id)sender;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerNumberPlay;
@property (weak, nonatomic) IBOutlet UIStepper *addminus;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnDone;
- (IBAction)stepperValueChange:(id)sender;
@property (weak, nonatomic) IBOutlet UINavigationItem *ttlFlip;
//@property (nonatomic,retain) Money *moneyModel;
@property (weak, nonatomic) IBOutlet UINavigationBar *naviBar;
- (IBAction)deleteGame:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *startMoney;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


@end
