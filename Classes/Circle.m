//
//  Circle.m
//  TouchTracker
//
//  Created by Chris Readle (GMC-MSV-IT CONTRACTOR) on 1/28/11.
//  Copyright 2011 Chris Readle. All rights reserved.
//

#import "Circle.h"


@implementation Circle

@synthesize center, radius, touches;

-(void)determineCenterPointAndRadius
{
	[self setCenter:CGPointMake(200, 200)];
	[self setRadius:100.0];
}

@end
