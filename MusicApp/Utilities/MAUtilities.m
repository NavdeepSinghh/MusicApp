//
//  MAUtilities.m
//  MusicApp
//
//  Created by Navdeep Singh on 09/07/17.
//  Copyright © 2017 Navdeep Singh. All rights reserved.
//

#import "MAUtilities.h"
#import "KeychainWrapper.h"

@implementation MAUtilities

static NSString *query=@"v1/catalog/au/charts?types=songs&offsets=20";

// Base64 conversion
+ (NSString*)encodeStringTo64:(NSString*)fromString
{
    NSData *plainData = [fromString dataUsingEncoding:NSUTF8StringEncoding];
    return [plainData base64EncodedStringWithOptions:kNilOptions];
}
// Methods to form fully qualified URL from base url
+(NSString *)getBaseURL
{
    return @"https://api.music.apple.com/";
}

+(NSString *)getQueryForURL
{
    return query;
}

+(void)setQueryForURL:(NSString *)url
{
    if(url){
    query=url;
    }
    else{
        query=@"v1/catalog/au/charts?types=songs&offsets=20";
    }
}

// JWT token to authenticate
+(void)storeAuthorizationToken
{
    KeychainWrapper* keychain = [[KeychainWrapper alloc] init ];
    [keychain mySetObject:@"Bearer eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IjhGUTVDWTRQMk0ifQ.eyJpc3MiOiJKNzI4NU1YMjI5IiwiaWF0IjoxNDk5NzUxNjQzLCJleHAiOjE1MTUzMDM2NDN9.PxlhSei6uFb3GhHV1PX6OHyO80Yfy4M26KRBKEB6AX6gF_rLtCl8Cvm9ClbbRKspuqIwGS9y9aXZFdi9GSkA-g" forKey:kSecValueData];
    [keychain writeToKeychain];
}

+(NSString *)getAuthorizationToken
{
    KeychainWrapper* keychain = [[KeychainWrapper alloc] init ];
    return [keychain myObjectForKey:kSecValueData];
}



@end
