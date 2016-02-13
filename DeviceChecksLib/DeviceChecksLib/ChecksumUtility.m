//
//  ChecksumUtility.m
//  DeviceChecksLib
//
//  Created by Suresh.Balla on 13/02/16.
//  Copyright © 2016 sureshballa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChecksumUtilities.h"

@implementation AiChecksum

+(NSString *)md5HashOfPath:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // Make sure the file exists
    if( [fileManager fileExistsAtPath:path isDirectory:nil] )
    {
        NSData *data = [NSData dataWithContentsOfFile:path];
        unsigned char digest[CC_MD5_DIGEST_LENGTH];
        CC_MD5( data.bytes, (CC_LONG)data.length, digest );
        
        NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
        
        for( int i = 0; i < CC_MD5_DIGEST_LENGTH; i++ )
        {
            [output appendFormat:@"%02x", digest[i]];
        }
        
        return output;
    }
    else
    {
        return @"";
    }
}

+(NSString *)shaHashOfPath:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // Make sure the file exists
    if( [fileManager fileExistsAtPath:path isDirectory:nil] )
    {
        NSData *data = [NSData dataWithContentsOfFile:path];
        unsigned char digest[CC_SHA1_DIGEST_LENGTH];
        CC_SHA1( data.bytes, (CC_LONG)data.length, digest );
        
        NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
        
        for( int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++ )
        {
            [output appendFormat:@"%02x", digest[i]];
        }
        
        return output;
    }
    else
    {
        return @"";
    }
}

@end