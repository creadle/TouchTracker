//
//  Circle.h
//  TouchTracker
//
//  Created by Chris Readle (GMC-MSV-IT CONTRACTOR) on 1/23/11.
//  Copyright 2011 Chris Readle. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Circle : NSObject {
	
	CGPoint center;
	float radius;

}

@property (nonatomic) CGPoint center;
@property (nonatomic) float radius;

@end
