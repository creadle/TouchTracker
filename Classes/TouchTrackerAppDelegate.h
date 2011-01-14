//
//  TouchTrackerAppDelegate.h
//  TouchTracker
//
//  Created by Chris Readle (GMC-MSV-IT CONTRACTOR) on 12/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TouchTrackerAppDelegate : NSObject <UIApplicationDelegate> {
	
	UIView *view;
    UIWindow *window;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UIView *view;

@end

