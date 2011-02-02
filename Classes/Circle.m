//
//  Circle.m
//  TouchTracker
//
//  Created by Chris Readle (GMC-MSV-IT CONTRACTOR) on 1/28/11.
//  Copyright 2011 Chris Readle. All rights reserved.
//

#import "Circle.h"
#include <stdlib.h>


@implementation Circle

@synthesize center, radius, touches, touchesEnded;

/*-(id)init
{
	NSMutableDictionary *touches = [[NSMutableDictionary alloc] init];
	return self;
}*/

-(void)determineCenterPointAndRadius
{
	//get the touches
	NSArray *touchArray = [NSArray arrayWithArray:[[self touches] allValues]];
	
	if ([touchArray count] == 2) {
		CGPoint firstTouch = [[touchArray objectAtIndex:0] CGPointValue];
		CGPoint secondTouch = [[touchArray objectAtIndex:1] CGPointValue];
		
		
		//determine the x and y coordinates of the centerpoint and the radius using the touches as the corners of a bounding box
		CGFloat centerPointX, centerPointY;
		if (firstTouch.x > secondTouch.x) {
			centerPointX = firstTouch.x - ((firstTouch.x - secondTouch.x) /2);
			[self setRadius: firstTouch.x - [self center].x];
		}else {
			centerPointX = secondTouch.x - ((secondTouch.x - firstTouch.x) /2);
			[self setRadius:secondTouch.x - [self center].x];
		}
		if (firstTouch.y > secondTouch.y) {
			centerPointY = firstTouch.y - ((firstTouch.y - secondTouch.y) /2);
		}else {
			centerPointY = secondTouch.y - ((secondTouch.y - firstTouch.y) /2);
		}
		[self setCenter:CGPointMake(centerPointX, centerPointY)];
	}else {
		[self setCenter:CGPointMake(arc4random() % 320, arc4random() % 480)];
		[self setRadius:arc4random() % 200];
	}
}
-(void)dealloc
{
	[touches release];
	[super dealloc];
}

@end
