//
//  NSUUIDFormatter.m
//
//  Created by Douglas Pedley on 1/24/14.
//  Copyright (c) 2014 dpedley.com. All rights reserved.
//

#import "NSUUIDFormatter.h"

@implementation NSUUIDFormatter

- (NSString *)stringForObjectValue:(id)anObject
{
    NSUUID *uuid = anObject;
    if ([uuid isKindOfClass:[NSUUID class]])
    {
        return [uuid UUIDString];
    }
    return nil;
}

- (BOOL)getObjectValue:(id *)anObject
             forString:(NSString *)string
      errorDescription:(NSString **)error
{
    BOOL returnValue = NO;

    *anObject = [[NSUUID alloc] initWithUUIDString:string];
    
    if (((NSUUID *)*anObject)!=nil)
    {
        returnValue = YES;
    }
    else
    {
        if (error)
        {
            *error = NSLocalizedString(@"Couldn’t convert  to NSUUID",
                                       @"Error converting");
        }
    }
    return returnValue;
}

@end
