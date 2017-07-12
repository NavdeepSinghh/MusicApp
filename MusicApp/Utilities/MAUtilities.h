//
//  MAUtilities.h
//  MusicApp
//
//  Created by Navdeep Singh on 09/07/17.
//  Copyright © 2017 Navdeep Singh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MAUtilities : NSObject

+ (NSString*)encodeStringTo64:(NSString*)fromString;
+(NSString *)getAuthorizationToken;
+(NSString *)getBaseURL;
+(NSString *)getQueryForURL;
+(void)setQueryForURL:(NSString *)url;
+(void)storeAuthorizationToken;

@end
