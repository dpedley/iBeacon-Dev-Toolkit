//
//  BeaconSimulator.m
//  iBeacon Dev Toolkit
//
//  Created by Douglas Pedley on 1/23/14.
//  Copyright (c) 2014 dpedley.com. All rights reserved.
//

#import "BeaconSimulator.h"
#import <IOBluetooth/IOBluetooth.h>
#import "BLCBeaconAdvertisementData.h"
#import "NSUUIDFormatter.h"
#import "AppDelegate.h"
#import "StopGoView.h"
#import "HelpPanel.h"

@interface BeaconSimulator () <CBPeripheralManagerDelegate, NSTextFieldDelegate>

@property (nonatomic, weak) IBOutlet StopGoView *startStopIcon;

@property (nonatomic, weak) IBOutlet NSButton *startStopButton;

@property (nonatomic, weak) IBOutlet NSButton *randomButton;
@property (nonatomic, weak) IBOutlet NSButton *majorTypeButton;
@property (nonatomic, weak) IBOutlet NSButton *minorTypeButton;

@property (nonatomic, weak) IBOutlet NSTextField *proximityUUIDField;
@property (nonatomic, weak) IBOutlet NSTextField *majorField;
@property (nonatomic, weak) IBOutlet NSTextField *minorField;
@property (nonatomic, weak) IBOutlet NSTextField *powerField;

@property (nonatomic, weak) IBOutlet NSMenuItem *randomUUIDMenuItem;
@property (nonatomic, weak) IBOutlet NSMenuItem *startStopMenuItem;

@property (nonatomic, weak) IBOutlet HelpPanel *helpPanel;
@property (nonatomic, weak) IBOutlet HelpPanel *bluetoothOffPanel;

@property (nonatomic,strong) CBPeripheralManager *manager;

@end

@implementation BeaconSimulator

-(IBAction)simulatorToggleAction:(id)sender
{
    if (self.manager.isAdvertising)
    {
        [self.manager stopAdvertising];
        [self.startStopIcon setButtonState:iBDT_SGButtonState_GO];
        [self setUIElementsEnabled:YES];
    }
    else if (self.manager.state==CBPeripheralManagerStatePoweredOn)
    {
        NSUUID *proximityUUID = [self.proximityUUIDField objectValue];
        BLCBeaconAdvertisementData *beaconData = [[BLCBeaconAdvertisementData alloc]
                                                  initWithProximityUUID:proximityUUID
                                                  major:self.majorField.integerValue
                                                  minor:self.minorField.integerValue
                                                  measuredPower:self.powerField.integerValue];
        
        [self.manager startAdvertising:beaconData.beaconAdvertisement];
        [self setUIElementsEnabled:NO];
        [self.startStopIcon setButtonState:iBDT_SGButtonState_STOP];
    }
    else if (self.manager.state==CBPeripheralManagerStatePoweredOff)
    {
        NSApplication *NSApp = [NSApplication sharedApplication];
        [NSApp beginSheet:self.bluetoothOffPanel
           modalForWindow:self
            modalDelegate:self
           didEndSelector:nil
              contextInfo:nil];
        [NSApp runModalForWindow:self.bluetoothOffPanel];
        [NSApp endSheet:self.bluetoothOffPanel];
        [self.bluetoothOffPanel orderOut:nil];
    }
}

-(IBAction)bluetoothPanelClose:(id)sender
{
    [[NSApplication sharedApplication] stopModal];
}

-(IBAction)randomizeUUIDAction:(id)sender
{
    [self.proximityUUIDField setStringValue:[self randomUUIDString]];
}

-(IBAction)showHelp:(id)sender
{
    NSApplication *NSApp = [NSApplication sharedApplication];
    [NSApp beginSheet:self.helpPanel
       modalForWindow:self
        modalDelegate:self
       didEndSelector:nil
          contextInfo:nil];
    [NSApp runModalForWindow:self.helpPanel];
    [NSApp endSheet:self.helpPanel];
    [self.helpPanel orderOut:nil];
}

-(void)awakeFromNib
{
    // set property in app delegate.
    [(AppDelegate *)[[NSApplication sharedApplication] delegate] setSimulator:self];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    // Load the uuid, or create a random one.
    NSString *uuidStr = [userDefaults objectForKey:@"iBDT_proximityUUID"];
    if (!uuidStr)
    {
        uuidStr = [self randomUUIDString];
    }
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:uuidStr];
    [self.proximityUUIDField setObjectValue:uuid];
    
    // Load the major and minor, or set default
    NSNumber *majorNumber = [userDefaults objectForKey:@"iBDT_major"];
    NSNumber *minorNumber = [userDefaults objectForKey:@"iBDT_minor"];
    NSNumber *powerNumber = [userDefaults objectForKey:@"iBDT_power"];
    
    if (majorNumber)
    {
        [self.majorField setIntegerValue:(NSInteger)[majorNumber unsignedShortValue]];
    }
    else
    {
        [self.majorField setIntegerValue:312];
    }
    
    if (minorNumber)
    {
        [self.minorField setIntegerValue:(NSInteger)[minorNumber unsignedShortValue]];
    }
    else
    {
        [self.minorField setIntegerValue:1971];
    }
    
    if (powerNumber)
    {
        [self.powerField setIntegerValue:(NSInteger)[powerNumber integerValue]];
    }
    else
    {
        [self.powerField setIntegerValue:(-71)];
    }
    
    [self.startStopButton setEnabled:NO];
    [self.startStopMenuItem setEnabled:NO];
    self.manager = [[CBPeripheralManager alloc] initWithDelegate:self
                                                       queue:nil];
    
    // TODO: setup the beacon major minor type buttons
    [self.minorTypeButton setHidden:YES];
    [self.majorTypeButton setHidden:YES];
}

- (void)writeSettings
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSUUID *uuid = [self.proximityUUIDField objectValue];
    [userDefaults setObject:[uuid UUIDString] forKey:@"iBDT_proximityUUID"];
    
    NSNumber *majorNumber = [NSNumber numberWithInteger:[self.majorField integerValue]];
    [userDefaults setObject:majorNumber forKey:@"iBDT_major"];
    
    NSNumber *minorNumber = [NSNumber numberWithInteger:[self.minorField integerValue]];
    [userDefaults setObject:minorNumber forKey:@"iBDT_minor"];
    
    NSNumber *powerNumber = [NSNumber numberWithInteger:[self.powerField integerValue]];
    [userDefaults setObject:powerNumber forKey:@"iBDT_power"];
}

- (void)setUIElementsEnabled:(BOOL)uiEnabled
{
    [self.proximityUUIDField setEnabled:uiEnabled];
    [self.majorField setEnabled:uiEnabled];
    [self.minorField setEnabled:uiEnabled];
    [self.powerField setEnabled:uiEnabled];
    [self.randomButton setEnabled:uiEnabled];
    [self.majorTypeButton setEnabled:uiEnabled];
    [self.minorTypeButton setEnabled:uiEnabled];
    [self.randomUUIDMenuItem setEnabled:uiEnabled];
}

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    if (peripheral.state == CBPeripheralManagerStatePoweredOn)
    {
        if ([[NSApplication sharedApplication] modalWindow])
        {
            [[NSApplication sharedApplication] stopModal];
        }
        
        [self.startStopIcon setButtonState:iBDT_SGButtonState_GO];
        [self.startStopButton setEnabled:YES];
        [self.startStopMenuItem setEnabled:YES];
        [self setUIElementsEnabled:YES];
    }
    else if (peripheral.state == CBPeripheralManagerStatePoweredOff)
    {
        [self.startStopIcon setButtonState:iBDT_SGButtonState_ERROR];
        [self.startStopMenuItem setEnabled:NO];
        [self.startStopButton setEnabled:YES];
        [self setUIElementsEnabled:YES];
    }
    else if (peripheral.state == CBPeripheralManagerStateUnsupported)
    {
    }
}

-(NSString *)randomUUIDString
{
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    NSString *uuidStr = (__bridge_transfer NSString *)CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    return uuidStr;
}

#pragma mark - NSTextFieldDelegate

- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor
{
    return YES;
}

@end
