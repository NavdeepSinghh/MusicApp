//
//  MAParser.h
//  MusicApp
//
//  Created by Navdeep Singh on 10/07/17.
//  Copyright © 2017 Navdeep Singh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MAParser : NSObject

-(void)parseRespose:(NSData *)responseData completion:(void (^)(NSArray *songListArray, NSError *error))handler;

@end
