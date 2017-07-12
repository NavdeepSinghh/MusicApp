//
//  MANetworkHandler.h
//  MusicApp
//
//  Created by Navdeep Singh on 10/07/17.
//  Copyright © 2017 Navdeep Singh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MAModel.h"

@interface MANetworkHandler : NSObject

+ (id) getInstance;
-(void)getTopSongList:(NSString *)query withCompletionHandler:(void (^)(NSArray *MAModel,NSError *error))handler;

@end
