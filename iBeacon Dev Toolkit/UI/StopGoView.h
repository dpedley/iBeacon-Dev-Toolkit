//
//  StopGoView.h
//  iBeacon Dev Toolkit
//
//  Created by Douglas Pedley on 1/28/14.
//  Copyright (c) 2014 dpedley.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef enum
{
    iBDT_SGButtonState_GO = 0,
    iBDT_SGButtonState_STOP = 1,
    iBDT_SGButtonState_ERROR = 2,
} iBDT_SGButtonState;

@interface StopGoView : NSView

@property (nonatomic, assign) iBDT_SGButtonState buttonState;

@end
