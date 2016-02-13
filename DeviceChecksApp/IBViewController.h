//
//  IBViewController.h
//  Signature
//
//  Created by Suresh.Balla on 04/02/16.
//  Copyright © 2016 Suresh.Balla. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <DeviceChecksLib/DeviceChecksLib.h>


@interface IBViewController : UIViewController

@property CBCentralManager *bluetoothManager;
@property DeviceChecks *deviceChecks;

@end
