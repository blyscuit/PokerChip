//
//  LeftTableViewController.m
//  PokerChip
//
//  Created by Pisit Wetchayanwiwat on BE2556/05/24.
//  Copyright (c) 仏暦2556年 betaescape. All rights reserved.
//

#import "LeftTableViewController.h"
#import "MainViewController.h"
@interface LeftTableViewController ()

@end

@implementation LeftTableViewController
@synthesize intBetting;

-(NSString*)dataFilePath{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"datafile.plist"];
}


-(void)readNumbersFromFile{
    ///arrPlayerMoney = [NSMutableArray arrayWithContentsOfFile:[self dataFilePath]];
    SWRevealViewController *revealController = self.revealViewController;
    ///[revealController setFrontViewPosition:FrontViewPositionLeft animated:YES];
    MainViewController *mainView = [revealController.frontViewController initWithNibName:@"MainViewController" bundle:nil];
    
    //NSLog(@"mainview %i arrcurrentbetting%@",mainView.arrCurrentBetting.count, mainView.arrCurrentBetting);
    
    arrPlayerMoney = [NSMutableArray arrayWithArray:mainView.arrMoney];
}


-(IBAction)saveData{
    [arrPlayerMoney writeToFile:[self dataFilePath] atomically:YES];
}

-(void)setupTableColor{
    self.clearsSelectionOnViewWillAppear = NO;
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.15 alpha:1.0];
    self.tableView.separatorColor = [UIColor colorWithWhite:0.8 alpha:1.0];
}

-(void)setupTableData{
    [self.tableView reloadData];
}

-(void)viewDidAppear:(BOOL)animated{
    //every slided code here:
    [self readNumbersFromFile];
    
    //NSLog(@"SLIDED");
    
    
    intBetting = [arrPlayerMoney.lastObject intValue];
    
    [self setupTableData];
    [[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
}

-(void)viewDidLoad{
    [super viewDidLoad];
  
    [self setupTableColor];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}

- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    
    // configure the destination view controller:
    if ( [segue.destinationViewController isKindOfClass: [MainViewController class]] &&
        [sender isKindOfClass:[UITableViewCell class]] )
    {
        
        /*MainViewController* cvc = segue.destinationViewController;
        
        NSLog(@"from segue%i",cvc.intCurrentIn);
        
        [cvc view];
        
        cvc.intCurrentIn = 0;
        [cvc readNumbersFromFile];
        [cvc resetGame];
        [cvc refreshScreen];*/
        
        
        
        //cvc.label.textColor = c.textLabel.textColor;
        //cvc.label.text = c.textLabel.text;
    }
    
    // configure the segue.
    // in this case we dont swap out the front view controller, which is a UINavigationController.
    // but we could..
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] )
    {
        SWRevealViewControllerSegue* rvcs = (SWRevealViewControllerSegue*) segue;
        
        SWRevealViewController* rvc = self.revealViewController;
        NSAssert( rvc != nil, @"oops! must have a revealViewController" );
        
        NSAssert( [rvc.frontViewController isKindOfClass: [UINavigationController class]], @"oops!  for this segue we want a permanent navigation controller in the front!" );
        
        rvcs.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            
            UINavigationController* nc = (UINavigationController*)rvc.frontViewController;
            [nc setViewControllers: @[ dvc ] animated: YES ];
            
            [rvc setFrontViewPosition: FrontViewPositionLeft animated: YES];
            
        };
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int row = arrPlayerMoney.count;
    row--;
    return row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.0];
    cell.textLabel.textColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    cell.detailTextLabel.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:0.0 alpha:1.0];
    cell.textLabel.font = [UIFont systemFontOfSize:16.0];
    
    SWRevealViewController *revealController = self.revealViewController;
    MainViewController *mainView = [revealController.frontViewController initWithNibName:@"MainViewController" bundle:nil];
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = [NSString stringWithFormat:@"%@ Players",[arrPlayerMoney objectAtIndex:indexPath.row]];
            cell.detailTextLabel.textColor = [UIColor colorWithWhite:0.5 alpha:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
;
            break;
            
        default:
            cell.textLabel.text = [NSString stringWithFormat:@"Player %i", indexPath.row];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"$%@",[arrPlayerMoney objectAtIndex:indexPath.row]];
            if([[mainView.arrFolding objectAtIndex:indexPath.row]boolValue]==YES) {
                cell.detailTextLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.detailTextLabel.text = [NSString stringWithFormat:@"$%@ FOLDED",[arrPlayerMoney objectAtIndex:indexPath.row]];
                cell.textLabel.font = [UIFont italicSystemFontOfSize:13.0];
            }
            
            
            
            break;
    }

    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SWRevealViewController *revealController = self.revealViewController;
    ///[revealController setFrontViewPosition:FrontViewPositionLeft animated:YES];
    MainViewController *mainView = [revealController.frontViewController initWithNibName:@"MainViewController" bundle:nil];
    
    if(indexPath.row!=0&&[[mainView.arrFolding objectAtIndex:indexPath.row]boolValue]==NO){
        
        
        
        if ([[arrPlayerMoney objectAtIndex:indexPath.row]integerValue]==0) {
            
            NSInteger betted = [[mainView.arrCurrentBetting objectAtIndex:indexPath.row]integerValue];
            NSMutableArray *tempArray = [NSMutableArray arrayWithArray:mainView.arrCurrentBetting];
            NSInteger pay = mainView.intCurrentIn;
            for (int i=0; i<[mainView.arrCurrentBetting count]; i++) {
                [tempArray replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:0]];
                NSInteger difference = ([[mainView.arrCurrentBetting objectAtIndex:i]integerValue] - betted);
                if (difference>0) {
                    [tempArray replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:difference]];
                }
            }
            pay -= [[tempArray valueForKeyPath:@"@sum.self"]integerValue];
            
            int new = [[arrPlayerMoney objectAtIndex:indexPath.row]intValue];;
            new += pay;
            [arrPlayerMoney replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithInt:new]];
            
            
            [self saveData];
            
            
            [mainView resetGame];
            
            mainView.arrCurrentBetting = [NSMutableArray arrayWithArray:tempArray];
            
            mainView.intCurrentIn = [[tempArray valueForKeyPath:@"@sum.self"]integerValue];
            
            [mainView refreshScreen];
            
            if (mainView.intCurrentIn>0) {
                [revealController setFrontViewPosition:FrontViewPositionLeft animated:YES];
                [revealController setFrontViewPosition:FrontViewPositionRightMost animated:YES];
                [mainView.betBtt setEnabled:NO];
            }else{
                [mainView resetGame];
                [mainView refreshScreen];
                [mainView.betBtt setEnabled:YES];
                [revealController setFrontViewController:mainView animated:YES];
            }
        }
        
        
        
        
        
        
        
        
        
        
        else{
            //Here: set pile money to zero
            int row=arrPlayerMoney.count;
            row--;
            [arrPlayerMoney replaceObjectAtIndex:row withObject:[NSNumber numberWithInteger:0]];
            
            
            int new = [[arrPlayerMoney objectAtIndex:indexPath.row]intValue];;
            new += mainView.intCurrentIn;
            [arrPlayerMoney replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithInt:new]];
            
            [self saveData];
            
            //[revealController setFrontViewPosition:FrontViewPositionLeft animated:YES];
            
            //[revealController setFrontViewController:mainView animated:NO];
            [mainView resetGame];
            [mainView refreshScreen];
            [revealController setFrontViewController:mainView animated:YES];
        }
        
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"pay" ofType:@"m4a"];
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];
        avPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:NULL];
        avPlayer.delegate = self;
        [avPlayer prepareToPlay];
        [avPlayer play];
        
        
        
    }
}



@end
