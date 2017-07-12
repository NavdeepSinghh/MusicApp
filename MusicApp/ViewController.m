//
//  ViewController.m
//  MusicApp
//
//  Created by Navdeep Singh on 07/07/17.
//  Copyright © 2017 Navdeep Singh. All rights reserved.
//

#import "ViewController.h"
#import <StoreKit/StoreKit.h>
#import "MAUtilities.h"
#import "MANetworkHandler.h"
#import "MASongListCellTableViewCell.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "MBProgressHUD.h"
#import "FLAnimatedImage.h"
#import "FLAnimatedImageView.h"

NSString *const storeFrontKey=@"au";
NSString *const query=@"charts?types=songs";


@interface ViewController ()<SKCloudServiceSetupViewControllerDelegate,UITableViewDelegate,UITableViewDataSource>
{
    SKCloudServiceController *cloudService;
    SKCloudServiceSetupViewController *setUpVC;
    NSMutableArray *songListArray;
    MPMusicPlayerApplicationController *controller;
    NSIndexPath *playingSong;

}

@property (weak, nonatomic) MBProgressHUD *progressHUD;
@property (weak, nonatomic) IBOutlet UITableView *tblSongList;

@end

@implementation ViewController

// initialization of components
- (void)viewDidLoad {
    [super viewDidLoad];
    cloudService=[[SKCloudServiceController alloc] init];
    setUpVC=[[SKCloudServiceSetupViewController alloc] init];
    songListArray=[[NSMutableArray alloc] init];
    setUpVC.delegate=self;
    self.progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.progressHUD.mode = MBProgressHUDModeIndeterminate;
    [MAUtilities storeAuthorizationToken];
    [self requestForAuthorization];
}


-(void)requestForAuthorization
{
   [SKCloudServiceController requestAuthorization:^(SKCloudServiceAuthorizationStatus status) {
       
       switch (status) {
           case SKCloudServiceAuthorizationStatusAuthorized:
               [self performSelectorOnMainThread:@selector(requestCapabilities) withObject:nil waitUntilDone:YES];
               break;
           case SKCloudServiceAuthorizationStatusDenied:
               break;
           case SKCloudServiceAuthorizationStatusNotDetermined:
               break;
               
           case SKCloudServiceAuthorizationStatusRestricted:
               break;
           default:
               break;
       }
   }];
}

-(void)requestCapabilities
{
    self.progressHUD.label.text = @"Fetching songs";
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
    [weakSelf.progressHUD showAnimated:YES];
    });
    [cloudService requestCapabilitiesWithCompletionHandler:^(SKCloudServiceCapability capabilities, NSError * _Nullable error) {
        switch (capabilities) {
            case SKCloudServiceCapabilityNone:
                break;
            case SKCloudServiceCapabilityMusicCatalogPlayback:
                [self performSelectorOnMainThread:@selector(getTopSongs) withObject:nil waitUntilDone:YES];
                break;
            case SKCloudServiceCapabilityMusicCatalogSubscriptionEligible:
                [self performSelectorOnMainThread:@selector(setUpSubscriptionView) withObject:nil waitUntilDone:YES];
                break;
            case SKCloudServiceCapabilityAddToCloudMusicLibrary:
                break;

            default:
                break;
        }
    }];
}

-(void)getTopSongs
{
    __weak typeof(self) weakSelf = self;
    [[MANetworkHandler getInstance] getTopSongList:nil withCompletionHandler:^(NSArray *MAModel, NSError *error) {
        if(!error)
        {
            [songListArray addObjectsFromArray:MAModel];
            [self performSelectorOnMainThread:@selector(reloadTable) withObject:nil waitUntilDone:YES];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.progressHUD hideAnimated:YES];
        });
    }];
}

-(void)setUpSubscriptionView
{
    NSDictionary<SKCloudServiceSetupOptionsKey, id> *options = @{ SKCloudServiceSetupOptionsActionKey : SKCloudServiceSetupActionSubscribe};
    [setUpVC loadWithOptions:options completionHandler:^(BOOL result, NSError * _Nullable error) {
        if(result)
        {
            [self presentViewController:setUpVC animated:YES completion:nil];
        }
        else{
            NSLog(@"Fail");
        }
    }];
 
}


//service setupview delegate
- (void)cloudServiceSetupViewControllerDidDismiss:(SKCloudServiceSetupViewController *)cloudServiceSetupViewController
{
    [self requestCapabilities];
}

-(void)reloadTable
{
    [_tblSongList setHidden:NO];
    [_tblSongList reloadData];
}

// Button actions
- (IBAction)play:(id)sender {
    if (controller.playbackState == MPMusicPlaybackStatePlaying)
    {
        controller=[MPMusicPlayerController applicationQueuePlayer];
        [controller pause];
    }
    else{
        controller=[MPMusicPlayerController applicationQueuePlayer];
        [controller play];
    }
}

- (IBAction)stop:(id)sender {
    
    [self.viewContolMedia setHidden:YES];
    if (controller.playbackState == MPMusicPlaybackStatePlaying)
    {
        controller=[MPMusicPlayerController applicationQueuePlayer];
        [controller setNowPlayingItem:nil];
    }
    
}

// Table View Delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of sections
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [songListArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"SongIdentifier";
    
    MASongListCellTableViewCell *cell = (MASongListCellTableViewCell *) [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MASongListCell" owner:self options:nil];
        cell = (MASongListCellTableViewCell *)[nib objectAtIndex:0];
    }
    if (indexPath.row == [songListArray count] - 1)
    {
        [self getTopSongs];
    }
    if(playingSong==indexPath){
        [cell cellWithData:[songListArray objectAtIndex:indexPath.row] isPlaying:YES];
    }
    else{
        [cell cellWithData:[songListArray objectAtIndex:indexPath.row] isPlaying:NO];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(playingSong)
    {
        MASongListCellTableViewCell *cell= (MASongListCellTableViewCell *)[tableView cellForRowAtIndexPath:playingSong];
        [cell cellWithData:[songListArray objectAtIndex:playingSong.row] isPlaying:NO];
    }
    MASongListCellTableViewCell *cell= (MASongListCellTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    MAModel *songObject=  [songListArray objectAtIndex:indexPath.row];
    controller = [MPMusicPlayerController applicationQueuePlayer];
    [controller performQueueTransaction:^(MPMusicPlayerControllerMutableQueue * _Nonnull queue) {
        MPMusicPlayerStoreQueueDescriptor *queueDescripter = [[MPMusicPlayerStoreQueueDescriptor alloc] initWithStoreIDs:@[songObject.storeID]];
        [queue insertQueueDescriptor:queueDescripter afterItem:nil];
    } completionHandler:^(MPMusicPlayerControllerQueue * _Nonnull queue, NSError * _Nullable error) {
        [cell cellWithData:[songListArray objectAtIndex:indexPath.row] isPlaying:YES];
        [controller setNowPlayingItem:queue.items[0]];
        [controller prepareToPlay];
        [controller play];
    }];
    
    playingSong=indexPath;
}
@end
