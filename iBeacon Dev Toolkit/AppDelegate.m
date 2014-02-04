//
//  AppDelegate.m
//  iBeacon Dev Toolkit
//
//  Created by Douglas Pedley on 1/23/14.
//  Copyright (c) 2014 dpedley.com. All rights reserved.
//

#import "AppDelegate.h"
#import "BeaconSimulator.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

-(BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    return YES;
}

-(void)applicationWillTerminate:(NSNotification *)notification
{
    NSLog(@"Goodbye");
    if (self.simulator)
    {
        [self.simulator writeSettings];
        self.simulator = nil;
    }
}

@end
