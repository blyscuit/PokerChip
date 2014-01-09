//
//  FlipsideViewController.m
//  PokerChip
//
//  Created by Pisit Wetchayanwiwat on BE2556/03/11.
//  Copyright (c) 仏暦2556年 betaescape. All rights reserved.
//

#import "FlipsideViewController.h"
#import "MainViewController.h"
#import "SWRevealViewController.h"
#import <MessageUI/MessageUI.h>
@interface FlipsideViewController ()

@end


@implementation FlipsideViewController
//@synthesize moneyModel;
@synthesize naviBar,pickerNumberPlay,delegate,scrollView;


- (void)awakeFromNib
{
    self.preferredContentSize = CGSizeMake(320.0, 480.0);
    [super awakeFromNib];
}

-(NSString*)dataFilePath{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"datafile.plist"];
}


-(void)readNumbersFromFile{
    arrPlayerMoney = [NSMutableArray arrayWithContentsOfFile:[self dataFilePath]];
}

-(IBAction)saveData{
    [arrPlayerMoney writeToFile:[self dataFilePath] atomically:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.startMoney setDelegate:self];
    [self.startMoney setReturnKeyType:UIReturnKeyDone];
    
    
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    
    arrNumberList = [[NSArray alloc]initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",nil];
    
    //NSLog(@"%@",arrNumberList);
    
    [self readNumbersFromFile];
    numberPlay =[[arrPlayerMoney objectAtIndex:0]intValue];
    //numberPlay = 1;
    [pickerNumberPlay selectRow:[[arrPlayerMoney objectAtIndex:0]intValue]-1 inComponent:0 animated:YES];
    //arrPlayerMoney = [[NSMutableArray alloc]initWithObjects: nil];
    //moneyModel.arrMoney = [[NSMutableArray alloc]init];
    
    self.addminus.value = (double)numberPlay;
    
    naviBar.topItem.title = [NSString stringWithFormat:@"%i players", numberPlay];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self setupScrollView];
    
    tutorial = NO;
}

-(void)setupScrollView{
    
    CGRect frame;
    frame.origin.x = self.scrollView.frame.size.width*2+10;
    frame.origin.y = self.scrollView.frame.size.height*1/4;
    frame.size = CGSizeMake(60, 60);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.image = [UIImage imageNamed:@"icon.png"];
    [self.scrollView addSubview:imageView];
    
    frame.origin.x = self.scrollView.frame.size.width*4-70;
    frame.origin.y = self.scrollView.frame.size.height*3/11;
    frame.size = CGSizeMake(65,65);
    imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.image = [UIImage imageNamed:@"logo-01.png"];
    [self.scrollView addSubview:imageView];
    
    
    frame = CGRectMake(self.scrollView.frame.size.width*3/2-10,self.scrollView.frame.size.height*1/2-10, 20, 20);
    UIButton *helpButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    helpButton.frame = frame;
    helpButton.showsTouchWhenHighlighted=YES;
    [helpButton addTarget:self action:@selector(helpPressed:)
      forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview: helpButton];
    
    frame = CGRectMake(self.scrollView.frame.size.width*3/2-21,self.scrollView.frame.size.height*1/2+13, 42, 21);
    UILabel *nextLbl = [[UILabel alloc]initWithFrame:frame];
    nextLbl.text = @"Help";
    nextLbl.textAlignment = NSTextAlignmentCenter;
    nextLbl.textColor = [UIColor whiteColor];
    nextLbl.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
    [self.scrollView addSubview:nextLbl];
    
    frame = CGRectMake(self.scrollView.frame.size.width-42,self.scrollView.frame.size.height-21, 42, 21);
    nextLbl = [[UILabel alloc]initWithFrame:frame];
    nextLbl.text = @".>>>";
    nextLbl.textAlignment = NSTextAlignmentRight;
    nextLbl.textColor = [UIColor whiteColor];
    nextLbl.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
    [self.scrollView addSubview:nextLbl];
    
    frame = CGRectMake(self.scrollView.frame.size.width*2+100,self.scrollView.frame.size.height*3/15, 200, 70);
    nextLbl = [[UILabel alloc]initWithFrame:frame];
    [nextLbl setNumberOfLines:4];
    nextLbl.text = @"PokerChip 1.0 \nCopyright © 2014,\nBliss (@blyscuit),\nall rights reserved.";
    nextLbl.textAlignment = NSTextAlignmentLeft;
    nextLbl.textColor = [UIColor whiteColor];
    nextLbl.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
    [self.scrollView addSubview:nextLbl];
    
    frame = CGRectMake(self.scrollView.frame.size.width*3+45,self.scrollView.frame.size.height*4/13, 150, 21);
    nextLbl = [[UILabel alloc]initWithFrame:frame];
    [nextLbl setNumberOfLines:1];
    nextLbl.text = @"Designed & Directed\n@confucians";
    nextLbl.textAlignment = NSTextAlignmentCenter;
    nextLbl.textColor = [UIColor grayColor];
    nextLbl.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10];
    [self.scrollView addSubview:nextLbl];
    frame = CGRectMake(self.scrollView.frame.size.width*3+45,self.scrollView.frame.size.height*6/13, 150, 42);
    UIButton *companyBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    companyBtn.frame = frame;
    companyBtn.showsTouchWhenHighlighted=NO;
    [companyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [companyBtn setTitle:@"@confusians" forState:UIControlStateNormal];
    [companyBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14]];
    [companyBtn addTarget:self action:@selector(companyPressed:)
         forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview: companyBtn];
    
    frame = CGRectMake(self.scrollView.frame.size.width*3+45,self.scrollView.frame.size.height*9/13, 150, 42);
    UIButton *email = [UIButton buttonWithType:UIButtonTypeSystem];
    email.frame = frame;
    email.showsTouchWhenHighlighted=NO;
    [email setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [email setTitle:@"confusian.lab@gmail.com" forState:UIControlStateNormal];
    [email.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:11]];
    [email addTarget:self action:@selector(emailPressed:)
         forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview: email];
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width *4,self.scrollView.frame.size.height);
}

-(IBAction)helpPressed:(id)sender{
    [[self.view viewWithTag:10]removeFromSuperview];
    [[self.view viewWithTag:9]removeFromSuperview];
    if(!tutorial){
        CGRect frame;
        
        frame.size = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
        frame.origin.x = (self.view.frame.size.width-frame.size.width)/2;
        frame.origin.y = (self.view.frame.size.height-frame.size.height)/2;
        UIView *tutorialView = [[UIImageView alloc] initWithFrame:frame];
        tutorialView.backgroundColor = [UIColor blackColor];
        tutorialView.alpha = 0.0;
        [self.view addSubview:tutorialView];
        [self.view bringSubviewToFront:tutorialView];
        self.pickerNumberPlay.userInteractionEnabled = NO;
        self.addminus.userInteractionEnabled = NO;
        self.naviBar.userInteractionEnabled = NO;
        self.startMoney.userInteractionEnabled = NO;
        self.scrollView.userInteractionEnabled = NO;
        tutorialView.tag = 9;
        [UIView animateWithDuration:0.2f animations:^{tutorialView.alpha = 0.7;}];
        
        frame.size = CGSizeMake(self.view.frame.size.width * 9/10, self.view.frame.size.width * 9/10 *1.5);
        frame.origin.x = (self.view.frame.size.width-frame.size.width)/2;
        frame.origin.y = (self.view.frame.size.height-frame.size.height)/2;
        UIImageView *tutorialImage = [[UIImageView alloc] initWithFrame:frame];
        tutorialImage.alpha=0.0;
        tutorialImage.image = [UIImage imageNamed:@"tutorial.png"];
        [self.view addSubview:tutorialImage];
        tutorialImage.tag = 10;
        CALayer *btnLayer = [[self.view viewWithTag:10] layer];
        [btnLayer setMasksToBounds:YES];
        [btnLayer setCornerRadius:7.0f];
        [UIView animateWithDuration:0.3f animations:^{tutorialImage.alpha = 1.0;}];

        
        tutorial = YES;
    }
}

-(IBAction)companyPressed:(id)sender{
    NSArray *urls = [NSArray arrayWithObjects:
                     @"twitter://user?screen_name={handle}", // Twitter
                     @"tweetbot:///user_profile/{handle}", // TweetBot
                     @"echofon:///user_timeline?{handle}", // Echofon
                     @"twit:///user?screen_name={handle}", // Twittelator Pro
                     @"x-seesmic://twitter_profile?twitter_screen_name={handle}", // Seesmic
                     @"x-birdfeed://user?screen_name={handle}", // Birdfeed
                     @"tweetings:///user?screen_name={handle}", // Tweetings
                     @"simplytweet:?link=http://twitter.com/{handle}", // SimplyTweet
                     @"icebird://user?screen_name={handle}", // IceBird
                     @"fluttr://user/{handle}", // Fluttr
                     @"http://twitter.com/{handle}",
                     nil];
    
    UIApplication *application = [UIApplication sharedApplication];
    
    for (NSString *candidate in urls) {
        NSURL *url = [NSURL URLWithString:[candidate stringByReplacingOccurrencesOfString:@"{handle}" withString:@"confusians"]];
        if ([application canOpenURL:url]) {
            [application openURL:url];
            
            return;
        }
    }
}

-(IBAction)emailPressed:(id)sender{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    
    [picker setSubject:@"PokerChip Support"];
    
    // Set up the recipients.
    NSArray *toRecipients = [NSArray arrayWithObjects:@"confusian.lab@gmail.com",
                             nil];
    
    [picker setToRecipients:toRecipients];
    
    // Present the mail composition interface.
    picker.modalPresentationStyle = UIModalPresentationPageSheet;
    [self presentModalViewController:picker animated:YES];
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    if (result == MFMailComposeResultSent) {
        NSLog(@"It's away!");
    }
    [self dismissModalViewControllerAnimated:YES];
}

-(void)resetMoneyinArray{
    [arrPlayerMoney removeAllObjects];
    [arrPlayerMoney addObject:[NSNumber numberWithInt:numberPlay]];
    int intStartMoney = self.startMoney.text.intValue;
    for (int i=1; i<=numberPlay; i++) {
        [arrPlayerMoney addObject:[NSNumber numberWithInt:intStartMoney]];
    }
    [arrPlayerMoney addObject:@"0"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width, 44)];
    //label.backgroundColor = [UIColor grayColor];
    label.textColor = [UIColor whiteColor];
    //label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
    label.text = [NSString stringWithFormat:@" %d Players", row+1];
    label.textAlignment = NSTextAlignmentCenter;
    return label;    
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    //One column
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    //set number of rows
    return arrNumberList.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    //set item per row
    return [arrNumberList objectAtIndex:row];
}


-(void)sendMoney{
    
    [self saveData];
}

#pragma mark - Actions

- (IBAction)done:(id)sender
{
    [self sendMoney];
    
    [self.delegate flipsideViewControllerDidFinish:self];
    
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
inComponent:(NSInteger)component
{
    numberPlay = [[arrNumberList objectAtIndex:row] integerValue];
    self.ttlFlip.title = [NSString stringWithFormat:@"%i Players",numberPlay];
    self.addminus.value = numberPlay;
    
    
}

- (IBAction)stepperValueChange:(id)sender {
    numberPlay = _addminus.value;
    self.ttlFlip.title = [NSString stringWithFormat:@"%i Players",numberPlay];
    [self.pickerNumberPlay selectRow:numberPlay-1 inComponent:0 animated:YES];
    
}
- (IBAction)deleteGame:(id)sender {
    [self.startMoney resignFirstResponder];
    if(self.startMoney.text.intValue<=0)self.startMoney.text=@"2000";
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"%i Players with $%i each?",numberPlay, self.startMoney.text.intValue]
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:@"New Game"
                                                    otherButtonTitles:nil];
    
    [actionSheet showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        [self resetMoneyinArray];
        
        
        [self done:self];
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.startMoney resignFirstResponder];
    
    if (tutorial) {
        //[[self.view viewWithTag:10]removeFromSuperview];
        //[[self.view viewWithTag:9]removeFromSuperview];
        
        [UIView animateWithDuration:0.2f animations:^{[self.view viewWithTag:10].alpha = 0.0;}];
        
        [UIView animateWithDuration:0.2f animations:^{[self.view viewWithTag:9].alpha = 0.0;}];
        self.pickerNumberPlay.userInteractionEnabled = YES;
        self.addminus.userInteractionEnabled = YES;
        self.naviBar.userInteractionEnabled = YES;
        self.startMoney.userInteractionEnabled = YES;
        self.scrollView.userInteractionEnabled = YES;
        tutorial=NO;
    }
}
@end
