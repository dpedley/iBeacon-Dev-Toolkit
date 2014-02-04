//
//  StopGoView.m
//  iBeacon Dev Toolkit
//
//  Created by Douglas Pedley on 1/28/14.
//  Copyright (c) 2014 dpedley.com. All rights reserved.
//

#import "StopGoView.h"

@implementation StopGoView

-(void)setButtonState:(iBDT_SGButtonState)buttonState
{
    if (_buttonState!=buttonState)
    {
        _buttonState = buttonState;
        [self setNeedsDisplay:YES];
    }
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	
    //// Color Declarations
    NSColor* stopColor = [NSColor colorWithCalibratedRed: 0.886 green: 0 blue: 0 alpha: 1];
    NSColor* whiteFontColor = [NSColor colorWithCalibratedRed: 1 green: 1 blue: 1 alpha: 1];
    NSColor* shapeOutlineColor = [NSColor colorWithCalibratedRed: 0 green: 0 blue: 0 alpha: 1];
    NSColor* goColor = [NSColor colorWithCalibratedRed: 0.114 green: 0.862 blue: 0.114 alpha: 1];
    NSColor* goGlow = [NSColor colorWithCalibratedRed: 0.714 green: 1 blue: 0.571 alpha: 1];
    
    //// Gradient Declarations
    NSGradient* gradient = [[NSGradient alloc] initWithStartingColor: goColor endingColor: goGlow];
    
    //// Shadow Declarations
    NSShadow* shadow = [[NSShadow alloc] init];
    [shadow setShadowColor: whiteFontColor];
    [shadow setShadowOffset: NSMakeSize(1.1, -1.1)];
    [shadow setShadowBlurRadius: 10];
    NSShadow* shadow2 = [[NSShadow alloc] init];
    [shadow2 setShadowColor: [NSColor blackColor]];
    [shadow2 setShadowOffset: NSMakeSize(0.1, 0.1)];
    [shadow2 setShadowBlurRadius: 2];
    
    //// Frames
    NSRect stopFrame = NSMakeRect(0, 0, 64, 64);
    NSRect goFrame = NSMakeRect(0, 0, 64, 64);
    NSRect errorFrame = NSMakeRect(0, 0, 64, 64);
    
    
    //// Abstracted Attributes
    NSString* stopTextContent = @"STOP";
    NSString* goTextContent = @"GO!";
    NSString* errorTextContent = @"ERROR";
    NSString* exclaimationPointContent = @"!";
    
    
    switch (self.buttonState)
    {
        case iBDT_SGButtonState_STOP:
        {
            //// Stop
            {
                //// StopShape Drawing
                NSBezierPath* stopShapePath = [NSBezierPath bezierPath];
                [stopShapePath moveToPoint: NSMakePoint(NSMinX(stopFrame) + 45.25, NSMaxY(stopFrame) - 7)];
                [stopShapePath lineToPoint: NSMakePoint(NSMinX(stopFrame) + 58, NSMaxY(stopFrame) - 19.75)];
                [stopShapePath lineToPoint: NSMakePoint(NSMinX(stopFrame) + 58, NSMaxY(stopFrame) - 45.25)];
                [stopShapePath lineToPoint: NSMakePoint(NSMinX(stopFrame) + 45.25, NSMaxY(stopFrame) - 58)];
                [stopShapePath lineToPoint: NSMakePoint(NSMinX(stopFrame) + 19.75, NSMaxY(stopFrame) - 58)];
                [stopShapePath lineToPoint: NSMakePoint(NSMinX(stopFrame) + 7, NSMaxY(stopFrame) - 45.25)];
                [stopShapePath lineToPoint: NSMakePoint(NSMinX(stopFrame) + 7, NSMaxY(stopFrame) - 19.75)];
                [stopShapePath lineToPoint: NSMakePoint(NSMinX(stopFrame) + 19.75, NSMaxY(stopFrame) - 7)];
                [stopShapePath lineToPoint: NSMakePoint(NSMinX(stopFrame) + 45.25, NSMaxY(stopFrame) - 7)];
                [stopShapePath closePath];
                [stopColor setFill];
                [stopShapePath fill];
                
                ////// StopShape Inner Shadow
                NSRect stopShapeBorderRect = NSInsetRect([stopShapePath bounds], -shadow.shadowBlurRadius, -shadow.shadowBlurRadius);
                stopShapeBorderRect = NSOffsetRect(stopShapeBorderRect, -shadow.shadowOffset.width, -shadow.shadowOffset.height);
                stopShapeBorderRect = NSInsetRect(NSUnionRect(stopShapeBorderRect, [stopShapePath bounds]), -1, -1);
                
                NSBezierPath* stopShapeNegativePath = [NSBezierPath bezierPathWithRect: stopShapeBorderRect];
                [stopShapeNegativePath appendBezierPath: stopShapePath];
                [stopShapeNegativePath setWindingRule: NSEvenOddWindingRule];
                
                [NSGraphicsContext saveGraphicsState];
                {
                    NSShadow* shadowWithOffset = [shadow copy];
                    CGFloat xOffset = shadowWithOffset.shadowOffset.width + round(stopShapeBorderRect.size.width);
                    CGFloat yOffset = shadowWithOffset.shadowOffset.height;
                    shadowWithOffset.shadowOffset = NSMakeSize(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset));
                    [shadowWithOffset set];
                    [[NSColor grayColor] setFill];
                    [stopShapePath addClip];
                    NSAffineTransform* transform = [NSAffineTransform transform];
                    [transform translateXBy: -round(stopShapeBorderRect.size.width) yBy: 0];
                    [[transform transformBezierPath: stopShapeNegativePath] fill];
                }
                [NSGraphicsContext restoreGraphicsState];
                
                [[NSColor blackColor] setStroke];
                [stopShapePath setLineWidth: 1];
                [stopShapePath stroke];
                
                
                //// StopText Drawing
                NSRect stopTextRect = NSMakeRect(NSMinX(stopFrame) + 7, NSMinY(stopFrame) + NSHeight(stopFrame) - 48, 51, 26);
                [NSGraphicsContext saveGraphicsState];
                [shadow2 set];
                NSMutableParagraphStyle* stopTextStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
                [stopTextStyle setAlignment: NSCenterTextAlignment];
                
                NSDictionary* stopTextFontAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                        [NSFont fontWithName: @"Verdana-Bold" size: 16], NSFontAttributeName,
                                                        whiteFontColor, NSForegroundColorAttributeName,
                                                        stopTextStyle, NSParagraphStyleAttributeName, nil];
                
                [stopTextContent drawInRect: NSOffsetRect(stopTextRect, 0, 4) withAttributes: stopTextFontAttributes];
                [NSGraphicsContext restoreGraphicsState];
                
            }
        }
            break;
            
        case iBDT_SGButtonState_GO:
        {
            //// Go
            {
                //// GoShape Drawing
                NSBezierPath* goShapePath = [NSBezierPath bezierPath];
                [goShapePath moveToPoint: NSMakePoint(NSMinX(goFrame) + 50.95, NSMaxY(goFrame) - 52.8)];
                [goShapePath curveToPoint: NSMakePoint(NSMinX(goFrame) + 50.95, NSMaxY(goFrame) - 13.2) controlPoint1: NSMakePoint(NSMinX(goFrame) + 61.68, NSMaxY(goFrame) - 41.86) controlPoint2: NSMakePoint(NSMinX(goFrame) + 61.68, NSMaxY(goFrame) - 24.14)];
                [goShapePath curveToPoint: NSMakePoint(NSMinX(goFrame) + 12.05, NSMaxY(goFrame) - 13.2) controlPoint1: NSMakePoint(NSMinX(goFrame) + 40.21, NSMaxY(goFrame) - 2.27) controlPoint2: NSMakePoint(NSMinX(goFrame) + 22.79, NSMaxY(goFrame) - 2.27)];
                [goShapePath curveToPoint: NSMakePoint(NSMinX(goFrame) + 12.05, NSMaxY(goFrame) - 52.8) controlPoint1: NSMakePoint(NSMinX(goFrame) + 1.32, NSMaxY(goFrame) - 24.14) controlPoint2: NSMakePoint(NSMinX(goFrame) + 1.32, NSMaxY(goFrame) - 41.86)];
                [goShapePath curveToPoint: NSMakePoint(NSMinX(goFrame) + 50.95, NSMaxY(goFrame) - 52.8) controlPoint1: NSMakePoint(NSMinX(goFrame) + 22.79, NSMaxY(goFrame) - 63.73) controlPoint2: NSMakePoint(NSMinX(goFrame) + 40.21, NSMaxY(goFrame) - 63.73)];
                [goShapePath closePath];
                NSRect goShapeBounds = goShapePath.bounds;
                CGFloat goShapeResizeRatio = MIN(NSWidth(goShapeBounds) / 55, NSHeight(goShapeBounds) / 56);
                [NSGraphicsContext saveGraphicsState];
                [goShapePath addClip];
                [gradient drawFromCenter: NSMakePoint(NSMidX(goShapeBounds) + 5.47 * goShapeResizeRatio, NSMidY(goShapeBounds) + 3.29 * goShapeResizeRatio) radius: 3.44 * goShapeResizeRatio
                                toCenter: NSMakePoint(NSMidX(goShapeBounds) + 0 * goShapeResizeRatio, NSMidY(goShapeBounds) + 0 * goShapeResizeRatio) radius: 33.81 * goShapeResizeRatio
                                 options: NSGradientDrawsBeforeStartingLocation | NSGradientDrawsAfterEndingLocation];
                [NSGraphicsContext restoreGraphicsState];
                [shapeOutlineColor setStroke];
                [goShapePath setLineWidth: 1];
                [goShapePath stroke];
                
                
                //// GoText Drawing
                NSRect goTextRect = NSMakeRect(NSMinX(goFrame) + 10, NSMinY(goFrame) + NSHeight(goFrame) - 47, 45, 27);
                [NSGraphicsContext saveGraphicsState];
                [shadow2 set];
                NSMutableParagraphStyle* goTextStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
                [goTextStyle setAlignment: NSCenterTextAlignment];
                
                NSDictionary* goTextFontAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                      [NSFont fontWithName: @"Verdana-Bold" size: 20], NSFontAttributeName,
                                                      whiteFontColor, NSForegroundColorAttributeName,
                                                      goTextStyle, NSParagraphStyleAttributeName, nil];
                
                [goTextContent drawInRect: NSOffsetRect(goTextRect, 0, 5) withAttributes: goTextFontAttributes];
                [NSGraphicsContext restoreGraphicsState];
                
            }
        }
            break;
            
        case iBDT_SGButtonState_ERROR:
        {
            //// Error
            {
                //// ErrorShape Drawing
                NSBezierPath* errorShapePath = [NSBezierPath bezierPath];
                [errorShapePath moveToPoint: NSMakePoint(NSMinX(errorFrame) + 40, NSMaxY(errorFrame) - 7)];
                [errorShapePath lineToPoint: NSMakePoint(NSMinX(errorFrame) + 43, NSMaxY(errorFrame) - 10)];
                [errorShapePath lineToPoint: NSMakePoint(NSMinX(errorFrame) + 57, NSMaxY(errorFrame) - 52.25)];
                [errorShapePath lineToPoint: NSMakePoint(NSMinX(errorFrame) + 55.25, NSMaxY(errorFrame) - 58)];
                [errorShapePath lineToPoint: NSMakePoint(NSMinX(errorFrame) + 9.75, NSMaxY(errorFrame) - 58)];
                [errorShapePath lineToPoint: NSMakePoint(NSMinX(errorFrame) + 8, NSMaxY(errorFrame) - 52.25)];
                [errorShapePath lineToPoint: NSMakePoint(NSMinX(errorFrame) + 23, NSMaxY(errorFrame) - 10)];
                [errorShapePath lineToPoint: NSMakePoint(NSMinX(errorFrame) + 26, NSMaxY(errorFrame) - 7)];
                [errorShapePath lineToPoint: NSMakePoint(NSMinX(errorFrame) + 40, NSMaxY(errorFrame) - 7)];
                [errorShapePath closePath];
                [stopColor setFill];
                [errorShapePath fill];
                
                ////// ErrorShape Inner Shadow
                NSRect errorShapeBorderRect = NSInsetRect([errorShapePath bounds], -shadow.shadowBlurRadius, -shadow.shadowBlurRadius);
                errorShapeBorderRect = NSOffsetRect(errorShapeBorderRect, -shadow.shadowOffset.width, -shadow.shadowOffset.height);
                errorShapeBorderRect = NSInsetRect(NSUnionRect(errorShapeBorderRect, [errorShapePath bounds]), -1, -1);
                
                NSBezierPath* errorShapeNegativePath = [NSBezierPath bezierPathWithRect: errorShapeBorderRect];
                [errorShapeNegativePath appendBezierPath: errorShapePath];
                [errorShapeNegativePath setWindingRule: NSEvenOddWindingRule];
                
                [NSGraphicsContext saveGraphicsState];
                {
                    NSShadow* shadowWithOffset = [shadow copy];
                    CGFloat xOffset = shadowWithOffset.shadowOffset.width + round(errorShapeBorderRect.size.width);
                    CGFloat yOffset = shadowWithOffset.shadowOffset.height;
                    shadowWithOffset.shadowOffset = NSMakeSize(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset));
                    [shadowWithOffset set];
                    [[NSColor grayColor] setFill];
                    [errorShapePath addClip];
                    NSAffineTransform* transform = [NSAffineTransform transform];
                    [transform translateXBy: -round(errorShapeBorderRect.size.width) yBy: 0];
                    [[transform transformBezierPath: errorShapeNegativePath] fill];
                }
                [NSGraphicsContext restoreGraphicsState];
                
                [[NSColor blackColor] setStroke];
                [errorShapePath setLineWidth: 1];
                [errorShapePath stroke];
                
                
                //// ErrorText Drawing
                NSRect errorTextRect = NSMakeRect(NSMinX(errorFrame) + 7, NSMinY(errorFrame) + NSHeight(errorFrame) - 57, 51, 14);
                [NSGraphicsContext saveGraphicsState];
                [shadow2 set];
                NSMutableParagraphStyle* errorTextStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
                [errorTextStyle setAlignment: NSCenterTextAlignment];
                
                NSDictionary* errorTextFontAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                         [NSFont fontWithName: @"Verdana-Bold" size: [NSFont labelFontSize]], NSFontAttributeName,
                                                         whiteFontColor, NSForegroundColorAttributeName,
                                                         errorTextStyle, NSParagraphStyleAttributeName, nil];
                
                [errorTextContent drawInRect: NSOffsetRect(errorTextRect, 0, 2) withAttributes: errorTextFontAttributes];
                [NSGraphicsContext restoreGraphicsState];
                
                
                
                //// ExclaimationPoint Drawing
                NSRect exclaimationPointRect = NSMakeRect(NSMinX(errorFrame) + 7, NSMinY(errorFrame) + NSHeight(errorFrame) - 48, 51, 41);
                [NSGraphicsContext saveGraphicsState];
                [shadow2 set];
                NSMutableParagraphStyle* exclaimationPointStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
                [exclaimationPointStyle setAlignment: NSCenterTextAlignment];
                
                NSDictionary* exclaimationPointFontAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                 [NSFont fontWithName: @"Verdana-Bold" size: 32], NSFontAttributeName,
                                                                 whiteFontColor, NSForegroundColorAttributeName,
                                                                 exclaimationPointStyle, NSParagraphStyleAttributeName, nil];
                
                [exclaimationPointContent drawInRect: NSOffsetRect(exclaimationPointRect, 0, 9) withAttributes: exclaimationPointFontAttributes];
                [NSGraphicsContext restoreGraphicsState];
                
            }
        }
            break;
            
        default:
            break;
    }
}

@end
