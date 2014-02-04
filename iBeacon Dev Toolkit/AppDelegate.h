//
//  AppDelegate.h
//  iBeacon Dev Toolkit
//
//  Created by Douglas Pedley on 1/23/14.
//  Copyright (c) 2014 dpedley.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class BeaconSimulator;

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (nonatomic, strong) BeaconSimulator *simulator;

@end
