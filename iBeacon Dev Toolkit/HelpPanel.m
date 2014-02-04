//
//  HelpPanel.m
//  iBeacon Dev Toolkit
//
//  Created by Douglas Pedley on 1/28/14.
//  Copyright (c) 2014 dpedley.com. All rights reserved.
//

#import "HelpPanel.h"

@implementation HelpPanel

-(IBAction)openSystemPreferences:(id)sender
{
    NSURL * url = [NSURL fileURLWithPath:@"/System/Library/PreferencePanes/Bluetooth.prefPane"];
    [[NSWorkspace sharedWorkspace] openURL:url];
}

-(IBAction)urlClicked:(id)sender
{
    if ([sender isKindOfClass:[NSButton class]])
    {
        NSButton *urlTextField = sender;
        NSURL *theURL = [NSURL URLWithString:[urlTextField title]];
        if (theURL)
        {
            [[NSWorkspace sharedWorkspace] openURL:theURL];
        }
    }
}

@end
