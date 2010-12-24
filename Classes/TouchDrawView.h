//
//  TouchDrawView.h
//  TouchTracker
//
//  Created by Chris Readle (GMC-MSV-IT CONTRACTOR) on 12/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TouchDrawView : UIView {
	
	NSMutableDictionary *linesInProcess;
	NSMutableArray *completeLines;

}

@property (nonatomic, retain) NSMutableArray *completedLines;

- (NSString *)lineArrayPath;

@end
