//
//  MainViewController.m
//  PokerChip
//
//  Created by Pisit Wetchayanwiwat on BE2556/03/11.
//  Copyright (c) 仏暦2556年 betaescape. All rights reserved.
//

#import "MainViewController.h"
#import "SWRevealViewController.h"
#import "LeftTableViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface MainViewController ()
//@property (readonly) IBOutlet UIBarButtonItem* revealButtonItem;


@end

@implementation MainViewController

//@synthesize moneyModel;
@synthesize currentMoney,betting, playerNumber, currentIn, currentBetting;
@synthesize button = _button;
@synthesize intCurrentIn,arrMoney,intBetting,intTurn,intTurnMax,arrFolding,arrCurrentBetting;

-(NSString*)dataFilePath{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"datafile.plist"];
    //return [[NSBundle mainBundle] pathForResource:@"datafile" ofType:@"plist"];
}

-(void)createPlistForFirstTime{
    NSFileManager *defFM = [NSFileManager defaultManager];
	NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //..Stuff that is done only once when installing a new version....
	static NSString *AppVersionKey = @"MyAppVersion";
	int lastVersion = [userDefaults integerForKey: AppVersionKey];
	if( lastVersion != 1.0 )	//..do this only once after install..
	{
		[userDefaults setInteger: 1.0 forKey: AppVersionKey];
		NSString *appDir = [[NSBundle mainBundle] resourcePath];
		NSString *src = [appDir stringByAppendingPathComponent: @"datafile.plist"];
		NSString *dest = [docsDir stringByAppendingPathComponent: @"datafile.plist"];
		[defFM removeItemAtPath: dest error: NULL];  //..remove old copy
		[defFM copyItemAtPath: src toPath: dest error: NULL];
	}
    //..end of stuff done only once when installing a new version.
}

-(void)roundRectButtons{
    CALayer *btnLayer = [self.hundredBtt layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:5.0f];
    btnLayer = [self.fivtyBtt layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:5.0f];
    btnLayer = [self.twentyfiveBtt layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:5.0f];
    btnLayer = [self.tenBtt layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:5.0f];
    btnLayer = [self.fiveBtt layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:5.0f];
}

-(void)refreshScreen{
    betting . text = [NSString stringWithFormat:@"%i",intBetting];
    currentIn.text = [NSString stringWithFormat:@"%i",intCurrentIn];
    playerNumber.text = [NSString stringWithFormat:@"%i",intTurn];
    currentBetting.text = [[arrCurrentBetting objectAtIndex:intTurn]stringValue];
    currentMoney.text = [[arrMoney objectAtIndex:intTurn ]stringValue];
    
    [self checkBettingMoney];
}

-(void)readNumbersFromFile{
    //NSLog(@"content= %@ from %@",[NSArray arrayWithContentsOfFile:[self dataFilePath]],[self dataFilePath]);
    if(!arrMoney){
        //NSLog(@"created");
        arrMoney = [NSMutableArray array];
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: [self dataFilePath]])
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"datafile" ofType:@"plist"];
        [fileManager copyItemAtPath:bundle toPath: [self dataFilePath] error:nil];
    }
    arrMoney = [NSMutableArray arrayWithContentsOfFile:[self dataFilePath]];
    int row=arrMoney.count;
    row--;
    if([[arrMoney objectAtIndex:row]intValue]==0)
    {
        intCurrentIn=0;
        [self refreshScreen];
    }
    
}

-(IBAction)saveData{
    
    [arrMoney writeToFile:[self dataFilePath] atomically:YES];
}

/*-(NSString*)tempFilePath{
    //return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"temp.plist"];
    return [[NSBundle mainBundle] pathForResource:@"temp" ofType:@"plist"];
}

/*-(void)readTempFromFile{
    arrTemp = [NSMutableArray arrayWithContentsOfFile:[self tempFilePath]];
}

-(IBAction)saveTemp{
    [arrTemp writeToFile:[self tempFilePath] atomically:YES];
}

-(void)checkTemp{
    [self readTempFromFile];
    if ([arrTemp objectAtIndex:0]!=[NSNumber numberWithInteger:0]){
        [arrTemp replaceObjectAtIndex:0 withObject:[NSNumber numberWithInteger:0]];
        [arrMoney removeAllObjects];
        [self readNumbersFromFile];
        [self saveTemp];
        [self saveData];
        
        [self resetGame];
    }
}*/


-(void)resetGame{
    [self readNumbersFromFile];
    
    ///[self checkTemp];
    
    lastMan = NO;
    
    intBetting =0;
    intCurrentIn = 0;
    intTurnMax = [arrMoney count];
    intTurnMax-=2;
    intTurn = 1;
    [self refreshScreen];
    //arrCurrentBetting = [[NSMutableArray alloc]initWithArray:arrMoney];
    //NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, [arrMoney count])];
    if(!arrCurrentBetting)arrCurrentBetting=[NSMutableArray array];
    arrCurrentBetting = [[NSMutableArray alloc]initWithObjects:nil];
    for (int i=1; i<[arrMoney count]; i++) {
        [arrCurrentBetting addObject:[NSNumber numberWithInt:0]];
    }
    if(!arrFolding)arrFolding=[NSMutableArray array];
    arrFolding = [[NSMutableArray alloc]initWithObjects:nil];
    for (int i=1; i<[arrMoney count]; i++) {
        [arrFolding addObject:[NSNumber numberWithBool:NO]];
    }
    //[arrMoney replaceObjectAtIndex:arrMoney.count withObject:@"0"];
}


- (void)viewDidAppear:(BOOL)animated{
    
    [self readNumbersFromFile];
    if((intTurnMax+1)!=[arrMoney count]){
        [self resetGame];
    }
    ///[self checkTemp];
    [self refreshScreen];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createPlistForFirstTime];
    
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self roundRectButtons];
    
    [self resetGame];
    
    SWRevealViewController *revealController = self.revealViewController;
    
    /*[self.revealButtonItem setTarget: self.revealViewController];
    [self.revealButtonItem setAction: @selector( revealToggle: )];
    [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];*/
    
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    [_button addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Flipside View Controller

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
        //self.flipsidePopoverController = nil;
        [self resetGame];
        [self refreshScreen];
    }
    
}


- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.flipsidePopoverController = nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            UIPopoverController *popoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
            self.flipsidePopoverController = popoverController;
            popoverController.delegate = self;
            
        }
    }
}

- (IBAction)togglePopover:(id)sender
{
    if (self.flipsidePopoverController) {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
        self.flipsidePopoverController = nil;
    } else {
        [self performSegueWithIdentifier:@"showAlternate" sender:nil];
    }
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        if (self.flipsidePopoverController) {
            [self.flipsidePopoverController dismissPopoverAnimated:YES];
            self.flipsidePopoverController = nil;
        } else {
            [self performSegueWithIdentifier:@"showAlternate" sender:nil];
        }
    }
}

-(void)betPressedWithButton:(CALayer*)layer{
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    [pathAnimation setFromValue:[NSNumber numberWithFloat:1.0f]];
    [pathAnimation setToValue:[NSNumber numberWithFloat:0.5f]];
    [pathAnimation setDuration:.3f];
    [pathAnimation setRepeatCount:1.0f];
    [pathAnimation setRemovedOnCompletion:NO];
    [pathAnimation setAutoreverses:NO];
    [pathAnimation setFillMode:kCAFillModeForwards];
    [pathAnimation setTimingFunction:[CAMediaTimingFunction functionWithControlPoints:.34 :.01 :.69 :1.67]];
    [layer addAnimation:pathAnimation forKey:@"changePathAnimation"];
    
    pathAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    [pathAnimation setFromValue:[NSNumber numberWithFloat:0.5f]];
    [pathAnimation setToValue:[NSNumber numberWithFloat:1.0f]];
    [pathAnimation setDuration:.3f];
    [pathAnimation setRepeatCount:1.0f];
    [pathAnimation setRemovedOnCompletion:NO];
    [pathAnimation setFillMode:kCAFillModeForwards];
    [pathAnimation setTimingFunction:[CAMediaTimingFunction functionWithControlPoints:.34 :.01 :.69 :1.67]];
    [layer addAnimation:pathAnimation forKey:@"changePathAnimation"];
}

-(void)moveLeftAnimationWithLayer:(CALayer*)layer{
    /*CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    pathAnimation.duration=.3;
    pathAnimation.additive=NO;
    pathAnimation.repeatCount=0;
    pathAnimation.autoreverses=NO;
    pathAnimation.fromValue=[NSNumber numberWithFloat:0];
    pathAnimation.toValue=[NSNumber numberWithFloat:-15];
    pathAnimation.beginTime = 0.0f;
    [pathAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    
    CABasicAnimation *fadeAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnim.fromValue=[NSNumber numberWithDouble:1.0];
    fadeAnim.toValue=[NSNumber numberWithDouble:0.0];
    fadeAnim.duration=0.3f;
    fadeAnim.beginTime = 0.0f;
    [fadeAnim setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];*/
    
    CABasicAnimation *pathAnimation3 = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    pathAnimation3.duration=.5;
    pathAnimation3.repeatCount=0;
    pathAnimation3.fromValue=[NSNumber numberWithFloat:20];
    pathAnimation3.toValue=[NSNumber numberWithFloat:0];
    //pathAnimation3.beginTime = 0.3f;
    [pathAnimation3 setTimingFunction:[CAMediaTimingFunction functionWithControlPoints:.34 :.01 :.69 :1.67]];
    
    CABasicAnimation *fadeAnim2 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnim2.fromValue=[NSNumber numberWithDouble:0.0];
    fadeAnim2.toValue=[NSNumber numberWithDouble:1.0];
    fadeAnim2.duration=0.6f;
    //fadeAnim2.beginTime = 0.3f;
    [fadeAnim2 setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    
    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
    scale.fromValue=[NSNumber numberWithDouble:0.5];
    scale.toValue=[NSNumber numberWithDouble:1.0];
    scale.duration=0.6f;
    //fadeAnim2.beginTime = 0.3f;
    [scale setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    //animationGroup.animations = @[pathAnimation,fadeAnim,pathAnimation3,fadeAnim2];
    animationGroup.animations = @[pathAnimation3,fadeAnim2,scale];
    animationGroup.duration=0.6;
    
    [layer addAnimation:animationGroup forKey:@"allMyAnimation"];
    
}

- (IBAction)addFive:(id)sender {
    
    if([[arrMoney objectAtIndex:intTurn] intValue]>=(intBetting+5)){
        {
            CALayer *btnLayer = [self.fiveBtt layer];
            [self betPressedWithButton:btnLayer];
            
            intBetting+=5;
            betting.text = [NSString stringWithFormat:@"%i",intBetting];
            //NSLog(@"%@",arrMoney);
            
            NSString *path = [[NSBundle mainBundle] pathForResource:@"chip" ofType:@"m4a"];
            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];
            avPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:NULL];
            avPlayer.delegate = self;
            [avPlayer prepareToPlay];
            [avPlayer play];
            
            [self.cashInSlider setValue:((float)intBetting / (float)[[arrMoney objectAtIndex:intTurn]intValue]) animated:YES];
            
            [self checkBettingMoney];
            
        }
    }else{
        //NSLog(@"%@",arrMoney);
    }
}
- (IBAction)addTen:(id)sender {
    
    if([[arrMoney objectAtIndex:intTurn] intValue]>=(intBetting+10)){
        {
            CALayer *btnLayer = [self.tenBtt layer];
            [self betPressedWithButton:btnLayer];
            
            intBetting+=10;
            betting.text = [NSString stringWithFormat:@"%i",intBetting];
            //NSLog(@"%@",arrMoney);
            
            
            NSString *path = [[NSBundle mainBundle] pathForResource:@"chip" ofType:@"m4a"];
            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];
            avPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:NULL];
            avPlayer.delegate = self;
            [avPlayer prepareToPlay];
            [avPlayer play];
            
            [self.cashInSlider setValue:((float)intBetting / (float)[[arrMoney objectAtIndex:intTurn]intValue]) animated:YES];
            
            [self checkBettingMoney];
        }
    }else{
        //NSLog(@"%@",arrMoney);
    }
}

- (IBAction)addTF:(id)sender {
    
    if([[arrMoney objectAtIndex:intTurn] intValue]>=(intBetting+25)){
        {
            CALayer *btnLayer = [self.twentyfiveBtt layer];
            [self betPressedWithButton:btnLayer];
            
            intBetting+=25;
            betting.text = [NSString stringWithFormat:@"%i",intBetting];
            //NSLog(@"%@",arrMoney);
            
            NSString *path = [[NSBundle mainBundle] pathForResource:@"chip" ofType:@"m4a"];
            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];
            avPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:NULL];
            avPlayer.delegate = self;
            [avPlayer prepareToPlay];
            [avPlayer play];
            
            [self.cashInSlider setValue:((float)intBetting / (float)[[arrMoney objectAtIndex:intTurn]intValue]) animated:YES];
            
            [self checkBettingMoney];
        }
    }else{
        //NSLog(@"%@",arrMoney);
    }
}

- (IBAction)addL:(id)sender {
    
    if([[arrMoney objectAtIndex:intTurn] intValue]>=(intBetting+50)){
        {
            CALayer *btnLayer = [self.fivtyBtt layer];
            [self betPressedWithButton:btnLayer];
            
            intBetting+=50;
            betting.text = [NSString stringWithFormat:@"%i",intBetting];
            //NSLog(@"%@",arrMoney);
            
            NSString *path = [[NSBundle mainBundle] pathForResource:@"chip" ofType:@"m4a"];
            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];
            avPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:NULL];
            avPlayer.delegate = self;
            [avPlayer prepareToPlay];
            [avPlayer play];
            
            [self.cashInSlider setValue:((float)intBetting / (float)[[arrMoney objectAtIndex:intTurn]intValue]) animated:YES];
            
            [self checkBettingMoney];
        }
    }else{
        //NSLog(@"%@",arrMoney);
    }
}

- (IBAction)addC:(id)sender {
    
    if([[arrMoney objectAtIndex:intTurn] intValue]>=(intBetting+100)){
        {
            CALayer *btnLayer = [self.hundredBtt layer];
            [self betPressedWithButton:btnLayer];
            
            intBetting+=100;
            betting.text = [NSString stringWithFormat:@"%i",intBetting];
            //NSLog(@"%@",arrMoney);
            
            NSString *path = [[NSBundle mainBundle] pathForResource:@"chip" ofType:@"m4a"];
            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];
            avPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:NULL];
            avPlayer.delegate = self;
            [avPlayer prepareToPlay];
            [avPlayer play];
            
            [self.cashInSlider setValue:((float)intBetting / (float)[[arrMoney objectAtIndex:intTurn]intValue]) animated:YES];
            
            [self checkBettingMoney];
        }
    }else{
        betting.text = [NSString stringWithFormat:@"%i",intBetting];
        //NSLog(@"%@",arrMoney);
    }
}
- (IBAction)sliderChange:(id)sender {
    
    intBetting = [[arrMoney objectAtIndex:intTurn]intValue];
    intBetting = intBetting * [[self cashInSlider]value];
    intBetting = round(intBetting/5)*5;
    betting . text = [NSString stringWithFormat:@"%i",intBetting];
    
    [self checkBettingMoney];
}


- (IBAction)allIn:(id)sender {
    [self betPressedWithButton:[self.fiveBtt layer]];
    [self betPressedWithButton:[self.tenBtt layer]];
    [self betPressedWithButton:[self.fivtyBtt layer]];
    [self betPressedWithButton:[self.twentyfiveBtt layer]];
    [self betPressedWithButton:[self.hundredBtt layer]];
    [self betPressedWithButton:[self.betting layer]];
    intBetting = [[arrMoney objectAtIndex:intTurn]intValue];
    betting . text = [NSString stringWithFormat:@"%i",intBetting];
    [self.cashInSlider setValue:((float)intBetting / (float)[[arrMoney objectAtIndex:intTurn]intValue]) animated:YES];
    [self checkBettingMoney];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"all-in" ofType:@"m4a"];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];
    avPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:NULL];
    avPlayer.delegate = self;
    [avPlayer prepareToPlay];
    [avPlayer play];
}

-(void)checkFolding{
    if ([[arrFolding objectAtIndex:intTurn]boolValue] == YES) {
        if(intTurn<intTurnMax){
            intTurn++;
            
        }else{
            intTurn=1;
        }
        [self checkFolding];
    }
    
    if ([[arrFolding objectAtIndex:intTurn]boolValue]==NO&&[[arrCurrentBetting objectAtIndex:intTurn]integerValue]==0&&[[arrMoney objectAtIndex:intTurn]integerValue]==0) {
        [self fold:self];
    }
}

-(void)checkBettingMoney{
    [self.betBtt setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    if ((intBetting+[[arrCurrentBetting objectAtIndex:intTurn]intValue])>=[[arrCurrentBetting valueForKeyPath:@"@max.self"]intValue]||[[arrMoney objectAtIndex:intTurn]intValue]-intBetting<=0) {
        //[self.betBtt setTitleColor:[UIColor colorWithRed:53 green:176 blue:227 alpha:1.0] forState:UIControlStateApplication];
        
        self.betBtt.enabled = YES;
        self.betBtt.showsTouchWhenHighlighted = YES;
    }else{
        self.betBtt.enabled = NO;
        self.betBtt.showsTouchWhenHighlighted = NO;
    }
}

- (IBAction)bet:(id)sender {
    [self betPressedWithButton:[self.currentIn layer]];
    [self betPressedWithButton:[self.betting layer]];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"chip2" ofType:@"m4a"];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];
    avPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:NULL];
    avPlayer.delegate = self;
    [avPlayer prepareToPlay];
    [avPlayer play];
    
    SWRevealViewController *revealController = self.revealViewController;
    
    
    [revealController setFrontViewPosition:FrontViewPositionLeft animated:YES];
    
    NSInteger intNewMoney;
    intNewMoney = [[arrMoney objectAtIndex:intTurn]intValue];
    intNewMoney -= intBetting;
    [arrMoney replaceObjectAtIndex:intTurn withObject:[NSNumber numberWithInt:intNewMoney]];
    
    intNewMoney = [[arrCurrentBetting objectAtIndex:intTurn]intValue];
    intNewMoney += intBetting;
    [arrCurrentBetting replaceObjectAtIndex:intTurn withObject:[NSNumber numberWithInt:intNewMoney]];
    
    intCurrentIn += intBetting;
    
    intBetting=0;
    
    if(intTurn<intTurnMax){
        intTurn++;
        
    }else{
        intTurn=1;
    }
    [self checkFolding];
    
    [self moveLeftAnimationWithLayer:[self.playerNumber layer]];
    [self moveLeftAnimationWithLayer:[self.currentMoney layer]];
    [self moveLeftAnimationWithLayer:[self.currentBetting layer]];
    [self moveLeftAnimationWithLayer:[self.playerStaticLbl layer]];
    
    [self refreshScreen];
    
    int number = arrMoney.count;
    number--;
    
    [arrMoney replaceObjectAtIndex:number withObject:[NSNumber numberWithInteger:intCurrentIn]];
    
    ///[self saveData];
    
}
-(void)turnGrey{
    
    [self betPressedWithButton:[self.fiveBtt layer]];
    [self betPressedWithButton:[self.tenBtt layer]];
    [self betPressedWithButton:[self.fivtyBtt layer]];
    [self betPressedWithButton:[self.twentyfiveBtt layer]];
    [self betPressedWithButton:[self.hundredBtt layer]];
    
    /*CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"foregroundColor"];
    [pathAnimation setFromValue:(id)[UIColor redColor].CGColor];
    [pathAnimation setToValue:(id)[UIColor grayColor].CGColor];
    [pathAnimation setDuration:.3f];
    [pathAnimation setRepeatCount:1.0f];
    [pathAnimation setRemovedOnCompletion:NO];
    [pathAnimation setAutoreverses:YES];
    [pathAnimation setFillMode:kCAFillModeForwards];
    [pathAnimation setTimingFunction:[CAMediaTimingFunction functionWithControlPoints:.34 :.01 :.69 :1.67]];
    [self.fiveBtt.layer addAnimation:pathAnimation forKey:@"changePathAnimation"];*/
    
    [UIView animateWithDuration:.26 animations:^{
        self.fiveBtt.backgroundColor = [UIColor grayColor];
    } completion:^(BOOL success){
        [UIView animateWithDuration:.2 animations:^{
            self.fiveBtt.backgroundColor = [UIColor redColor];
        }];
    }];
    [UIView animateWithDuration:.22 animations:^{
        self.tenBtt.backgroundColor = [UIColor grayColor];
    } completion:^(BOOL success){
        [UIView animateWithDuration:.2 animations:^{
            self.tenBtt.backgroundColor = [UIColor redColor];
        }];
    }];
    [UIView animateWithDuration:.18 animations:^{
        self.twentyfiveBtt.backgroundColor = [UIColor grayColor];
    } completion:^(BOOL success){
        [UIView animateWithDuration:.2 animations:^{
            self.twentyfiveBtt.backgroundColor = [UIColor redColor];
        }];
    }];
    [UIView animateWithDuration:.14 animations:^{
        self.fivtyBtt.backgroundColor = [UIColor grayColor];
    } completion:^(BOOL success){
        [UIView animateWithDuration:.2 animations:^{
            self.fivtyBtt.backgroundColor = [UIColor redColor];
        }];
    }];
    [UIView animateWithDuration:.1 animations:^{
        self.hundredBtt.backgroundColor = [UIColor grayColor];
    } completion:^(BOOL success){
        [UIView animateWithDuration:.2 animations:^{
            self.hundredBtt.backgroundColor = [UIColor redColor];
        }];
    }];
}
- (IBAction)fold:(id)sender {
    if (lastMan==NO) {
        [self turnGrey];
        [arrFolding replaceObjectAtIndex:intTurn withObject:[NSNumber numberWithBool:YES]];
        intBetting = 0;
        [self.cashInSlider setValue:((float)intBetting / (float)[[arrMoney objectAtIndex:intTurn]intValue]) animated:YES];
        betting . text = [NSString stringWithFormat:@"%i",intBetting];
        [self bet:self];
        //NSLog(@"%@",arrFolding);
    }
    NSInteger result = [[arrFolding valueForKeyPath:@"@sum.self"]integerValue];
    if (result==[arrFolding count]-2) {
        SWRevealViewController *revealController = self.revealViewController;
        [revealController setFrontViewPosition:FrontViewPositionRightMost animated:YES];
        lastMan=YES;
    }
}
- (IBAction)call:(id)sender {
    [self betPressedWithButton:[self.betting layer]];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"chip" ofType:@"m4a"];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];
    avPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:NULL];
    avPlayer.delegate = self;
    [avPlayer prepareToPlay];
    [avPlayer play];
    
    NSInteger max = [[arrCurrentBetting valueForKeyPath:@"@max.self"]intValue];
    NSInteger willBet = max - [[arrCurrentBetting objectAtIndex:intTurn]intValue];
    if([[arrMoney objectAtIndex:intTurn] intValue]>=willBet){
        intBetting = willBet;
    }
    [self.cashInSlider setValue:((float)intBetting / (float)[[arrMoney objectAtIndex:intTurn]intValue]) animated:YES];
    betting . text = [NSString stringWithFormat:@"%i",intBetting];
    [self checkBettingMoney];
}
- (IBAction)pop:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"Setting will Reset Current Bet"]
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Setting",nil];
    
    [actionSheet showInView:self.view];
}

@end
