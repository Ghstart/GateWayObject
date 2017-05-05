//
//  GhViewController.m
//  GateWayObject
//
//  Created by Ghstart on 05/05/2017.
//  Copyright (c) 2017 Ghstart. All rights reserved.
//

#import "GhViewController.h"
#import "GateWayObject.h"

@interface GhViewController ()
@property (weak, nonatomic) IBOutlet UITextField *relativeURL;

@end

@implementation GhViewController

- (IBAction)showCurrentURL:(id)sender {
    NSString *relative = (self.relativeURL.text == nil || [self.relativeURL.text isEqualToString:@""]) ? @"None" : self.relativeURL.text;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reques URL is:"
                                                    message:[[GateWayObject currentGateWay] currentURLBaseOnRelativeURL:relative]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (IBAction)swichCarRole:(id)sender {
    [[GateWayObject currentGateWay] swichGateWayBaseOn:@"carownerRole"];
}

- (IBAction)swichDriverRole:(id)sender {
   [[GateWayObject currentGateWay] swichGateWayBaseOn:@"driverRole"];
}

@end
