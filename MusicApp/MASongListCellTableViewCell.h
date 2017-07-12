//
//  MASongListCellTableViewCell.h
//  MusicApp
//
//  Created by Navdeep Singh on 11/07/17.
//  Copyright © 2017 Navdeep Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MAModel.h"
#import "FLAnimatedImageView.h"
#import "FLAnimatedImage.h"

@interface MASongListCellTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *imgArtistArt;
@property (weak, nonatomic) IBOutlet UILabel *lblSongName;
@property (weak, nonatomic) IBOutlet UILabel *lblArtistname;
@property (weak, nonatomic) IBOutlet UILabel *lblArtistAlbum;
@property (weak, nonatomic) IBOutlet UIImageView *imgPlayIndicator;


-(void)cellWithData:(MAModel *)songObject isPlaying:(BOOL)isPlaying;

@end
