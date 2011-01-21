//
//  Line.m
//  TouchTracker
//
//  Created by Chris Readle (GMC-MSV-IT CONTRACTOR) on 12/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Line.h"


@implementation Line

@synthesize begin, end;

-(void)encodeWithCoder:(NSCoder *)aCoder
{
	//[super encodeWithCoder:aCoder];
	[aCoder encodeCGPoint:begin forKey:@"LineBegin"];
	[aCoder encodeCGPoint:end forKey:@"LineEnd"];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
	[self setBegin:[aDecoder decodeCGPointForKey:@"LineBegin"]];
	[self setEnd:[aDecoder decodeCGPointForKey:@"LineEnd"]];
	return self;
}


@end
