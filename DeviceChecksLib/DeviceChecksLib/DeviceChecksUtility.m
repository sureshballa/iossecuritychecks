//
//  DeviceChecksUtility.m
//  DeviceChecksLib
//
//  Created by Suresh.Balla on 12/02/16.
//  Copyright © 2016 sureshballa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <UIKit/UIKit.h>
#import "DeviceChecksUtility.h"
#import "ChecksumUtilities.h"
@import Security;

@implementation DeviceChecks

BOOL _byPass;
BOOL _isBluetoothOn;


- (id)initWithBybassFlag:(BOOL)byPass
{
    self = [super init];
    if (self) {
        _byPass = byPass;
    }
    
    NSDictionary *options = @{CBCentralManagerOptionShowPowerAlertKey: @NO};
    
    self.bluetoothManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:options];
    
    [self centralManagerDidUpdateState:self.bluetoothManager];
    
    return self;
}

-(BOOL)isJailbroken;
{
    
    if(_byPass){
        return NO;
    }
    
#if !(TARGET_IPHONE_SIMULATOR)
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:@"/Applications/Cydia.app"] ||
        [[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/MobileSubstrate.dylib"] ||
        [[NSFileManager defaultManager] fileExistsAtPath:@"/bin/bash"] ||
        [[NSFileManager defaultManager] fileExistsAtPath:@"/usr/sbin/sshd"] ||
        [[NSFileManager defaultManager] fileExistsAtPath:@"/etc/apt"] ||
        [[NSFileManager defaultManager] fileExistsAtPath:@"/private/var/lib/apt/"])  {
        return YES;
    }
    
    FILE *f = NULL ;
    if ((f = fopen("/bin/bash", "r")) ||
        (f = fopen("/Applications/Cydia.app", "r")) ||
        (f = fopen("/Library/MobileSubstrate/MobileSubstrate.dylib", "r")) ||
        (f = fopen("/usr/sbin/sshd", "r")) ||
        (f = fopen("/etc/apt", "r")))  {
        fclose(f);
        return YES;
    }
    fclose(f);
    
    NSError *error;
    NSString *stringToBeWritten = @"This is a test.";
    [stringToBeWritten writeToFile:@"/private/jailbreak.txt" atomically:YES encoding:NSUTF8StringEncoding error:&error];
    [[NSFileManager defaultManager] removeItemAtPath:@"/private/jailbreak.txt" error:nil];
    if(error == nil)
    {
        return YES;
    }
    
#endif
    
    return NO;
}

-(NSString *)getSHA1: (NSString *)path
{
    NSString *sha1 = [AiChecksum shaHashOfPath:path];
    
    NSLog( @"SHA1: %@", sha1 );
    
    return sha1;
}
-(NSString *)getMD5: (NSString *)path
{
    NSString *md5 = [AiChecksum md5HashOfPath:path];
    
    NSLog( @"MD5: %@", md5 );
    
    return md5;
}


-(BOOL)isCurrentProcessRunningInDebugMode
{
    if(_byPass){
        return false;
    }
    
#ifdef DEBUG
    return YES;
#else
    return NO;
    
#endif
}

-(BOOL)isBluetoothEnabled
{
    if(_byPass){
        return false;
    }
    
    return self.bluetoothManager.state == CBCentralManagerStatePoweredOn;
}

-(BOOL)isUSBConnected
{
    if(_byPass){
        return false;
    }
    
    NSString *stateString = nil;
    BOOL isEnabled = NO;
    
    UIDevice *myDevice = [UIDevice currentDevice];
    [myDevice setBatteryMonitoringEnabled:YES];
    
    if ([myDevice batteryState] == UIDeviceBatteryStateUnplugged){
        stateString = @"Not connected to USB";
        isEnabled = NO;
    } else {
        stateString = @"Connected to USB";
        isEnabled = YES;
    }

    return isEnabled;
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    _isBluetoothOn = NO;
    NSString *stateString = nil;
    switch(self.bluetoothManager.state)
    {
        case CBCentralManagerStateResetting: stateString = @"The connection with the system service was momentarily lost, update imminent."; break;
        case CBCentralManagerStateUnsupported: stateString = @"The platform doesn't support Bluetooth Low Energy."; break;
        case CBCentralManagerStateUnauthorized: stateString = @"The app is not authorized to use Bluetooth Low Energy."; break;
        case CBCentralManagerStatePoweredOff: stateString = @"Bluetooth is currently powered off."; break;
        case CBCentralManagerStatePoweredOn:
            stateString = @"Bluetooth is currently powered on and available to use.";
            _isBluetoothOn = YES;
            break;
        default: stateString = @"State unknown, update imminent."; break;
    }
}

@end
