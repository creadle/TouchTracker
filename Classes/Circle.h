//
//  Circle.h
//  TouchTracker
//
//  Created by Chris Readle (GMC-MSV-IT CONTRACTOR) on 1/28/11.
//  Copyright 2011 Chris Readle. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Circle : NSObject {
	
	NSMutableDictionary *touches;
	CGPoint center;
	float radius;
	int touchesEnded;
	
}

@property (nonatomic) CGPoint center;
@property (nonatomic) float radius;
@property (nonatomic, retain) NSMutableDictionary *touches;
@property (nonatomic) int touchesEnded;

-(void)determineCenterPointAndRadius;

@end
