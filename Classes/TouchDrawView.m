//
//  TouchDrawView.m
//  TouchTracker
//
//  Created by Chris Readle (GMC-MSV-IT CONTRACTOR) on 12/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TouchDrawView.h"
#import "Line.h"
#import "Circle.h"


@implementation TouchDrawView

- (id)initWithCoder:(NSCoder *)c
{
	[super initWithCoder:c];
	linesInProcess = [[NSMutableDictionary alloc] init];
	incompleteCircles = [[NSMutableDictionary alloc] init];
	completeCircles = [[NSMutableArray alloc] init];
	completeLines = [[NSMutableArray alloc] init];
	[self setMultipleTouchEnabled:YES];
	return self;
}

/*
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
    }
    return self;
}*/


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetLineWidth(context, 10.0);
	CGContextSetLineCap(context, kCGLineCapRound);
	
	//completed lines are black
	[[UIColor blackColor] set];
	for (Line *line in completeLines){
		CGContextMoveToPoint(context, [line begin].x, [line	begin].y);
		CGContextAddLineToPoint(context, [line end].x, [line end].y);
		CGContextStrokePath(context);
	}
	//so are completed circles
	for (Circle *circle in completeCircles) {
		CGContextAddArc(context, [circle center].x, [circle center].y, [circle radius], 0.0, 360.0, 1);
		CGContextStrokePath(context);
	}
	
	//in process lines are red
	[[UIColor redColor] set];
	for (NSValue *v in linesInProcess) {
		Line *line = [linesInProcess objectForKey:v];
		CGContextMoveToPoint(context, [line begin].x, [line begin].y);
		CGContextAddLineToPoint(context, [line end].x, [line end].y);
		CGContextStrokePath(context);
	}
	//so are in process circles
	for (NSValue *i in incompleteCircles) {
		Circle *circle = [incompleteCircles objectForKey:i];
		CGContextAddArc(context, [circle center].x, [circle center].y, [circle radius], 0.0, 2 * M_PI, 1);
		CGContextStrokePath(context);
	}
		
}

- (void)clearAll
{
	[linesInProcess removeAllObjects];
	[completeLines removeAllObjects];
	[incompleteCircles removeAllObjects];
	[completeCircles removeAllObjects];
	
	[self setNeedsDisplay];
}

#pragma mark -
#pragma mark Touch methods
- (void)touchesBegan:(NSSet *)touches 
		   withEvent:(UIEvent *)event
{
	for (UITouch *t in touches) {
		//double tap?
		if ([t tapCount] > 1) {
			[self clearAll];
			return;
		}
		
		//set the key by wrapping in an nsvalue
		NSValue *key = [NSValue valueWithPointer:t];
		
		//get the location of the touch
		CGPoint loc = [t locationInView:self];
		
		//if we're already tracking a touch, take that touch and this one and create a circle with it and remove it from linesInProcess
		if ([linesInProcess count] == 1) {
			Circle *newCircle = [[Circle alloc] init];
			for (NSValue *v in linesInProcess) {
				Line *line = [linesInProcess objectForKey:v];
				CGPoint firstPoint = [line begin];
				[[newCircle touches] setObject:[NSValue valueWithCGPoint:firstPoint] forKey:v];
				[linesInProcess removeObjectForKey:v];
			}
			
			[[newCircle touches] setObject:[NSValue valueWithCGPoint: loc] forKey:key];
			[newCircle determineCenterPointAndRadius];
			NSValue *circleKey = [NSValue valueWithCGPoint:[newCircle center]];
			[incompleteCircles setObject:newCircle forKey:circleKey];
			[newCircle release];
			
		} else {
			Line *newLine = [[Line alloc] init];
			[newLine setBegin:loc];
			[newLine setEnd:loc];
			
			//add to dictionary
			[linesInProcess setObject:newLine forKey:key];
			[newLine release];
		}
	}
}

- (void)touchesMoved:(NSSet *)touches 
		   withEvent:(UIEvent *)event
{
	for (UITouch *t in touches) {
		NSValue *key = [NSValue valueWithPointer:t];
		
		//find the line that corresponds to this touch
		Line *line = [linesInProcess objectForKey:key];
		
		//get the loc for this touch
		CGPoint loc = [t locationInView:self];
		
		//if it's a line, update the endpoint
		if (line) {
			//update the line
			[line setEnd:loc];
		}else {  //otherwise, find the circle for this touch and update that point
			for (NSValue *i in incompleteCircles) {
				Circle *circle = [incompleteCircles objectForKey:i];
				if ([[circle touches] objectForKey: key]) {
					[[circle touches] setObject:[NSValue valueWithCGPoint:loc] forKey:key];
					[circle determineCenterPointAndRadius];
				}
			}
		}
	}

	//redraw
	[self setNeedsDisplay];
}

- (void)endTouches:(NSSet *)touches
		 withEvent:(UIEvent *) event
{
	//remove from the dictionary
	for (UITouch *t in touches) {
		NSValue *key = [NSValue valueWithPointer:t];
		Line *line = [linesInProcess objectForKey:key];
		
		//if it's a double tap, tapCount == 2
		if ([t tapCount] != 2) {
			if (line) { //if we got a line remove from linesInProcess and add to completeLines
				[completeLines addObject:line];
				[linesInProcess removeObjectForKey:key];
			} else { //otherwise get the circle for which it corresponds
				for (NSValue *i in incompleteCircles) {
					Circle *circle = [incompleteCircles objectForKey:i];
					if ([[circle touches] objectForKey: key]) {
						if ([event allTouches] == nil) {
							[completeCircles addObject:circle];
							[incompleteCircles removeObjectForKey:i];
						}
					}
				}
			}
		}
	}
	//redraw
	[self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches 
		   withEvent:(UIEvent *)event
{
	[self endTouches:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches 
			   withEvent:(UIEvent *)event
{
	[self endTouches:touches withEvent: event];
}

#pragma mark -
#pragma mark Cleanup

- (void)dealloc {
	[linesInProcess release];
	[incompleteCircles release];
	[completeCircles release];
	[completeLines release];
    [super dealloc];
}


@end
