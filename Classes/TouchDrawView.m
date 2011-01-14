//
//  TouchDrawView.m
//  TouchTracker
//
//  Created by Chris Readle (GMC-MSV-IT CONTRACTOR) on 12/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TouchDrawView.h"
#import "Line.h"
#import "FileHelpers.h"


@implementation TouchDrawView

@synthesize completedLines;

- (id)initWithCoder:(NSCoder *)c
{
	[super initWithCoder:c];
	linesInProcess = [[NSMutableDictionary alloc] init];
	completeLines = [[NSMutableArray alloc] init];
	
	NSString *linePath = [self lineArrayPath];
	NSLog(@"linePath = ", linePath);
	 
	NSMutableArray *lineArray = [NSKeyedUnarchiver unarchiveObjectWithFile:linePath];
	 
	if (lineArray) {
		NSLog(@"Entered if statement");
		[self setCompletedLines:lineArray];
	}
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
	
	//in process lines are red
	[[UIColor redColor] set];
	for (NSValue *v in linesInProcess) {
		Line *line = [linesInProcess objectForKey:v];
		CGContextMoveToPoint(context, [line begin].x, [line begin].y);
		CGContextAddLineToPoint(context, [line end].x, [line end].y);
		CGContextStrokePath(context);
	}
		
}

- (void)clearAll
{
	[linesInProcess removeAllObjects];
	[completeLines removeAllObjects];
	
	[self setNeedsDisplay];
}

#pragma mark -
#pragma mark Saving and restoring methods

- (NSString *)lineArrayPath
{
	return pathInDocumentDirectory(@"Lines.data");
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
		
		//create a line for the value
		CGPoint loc = [t locationInView:self];
		Line *newLine = [[Line alloc] init];
		[newLine setBegin:loc];
		[newLine setEnd:loc];
		
		//add to dictionary
		[linesInProcess setObject:newLine forKey:key];
		[newLine release];
	}
}

- (void)touchesMoved:(NSSet *)touches 
		   withEvent:(UIEvent *)event
{
	for (UITouch *t in touches) {
		NSValue *key = [NSValue valueWithPointer:t];
		
		//find the line that corresponds to this touch
		Line *line = [linesInProcess objectForKey:key];
		
		//update the line
		CGPoint loc = [t locationInView:self];
		[line setEnd:loc];
	}
	//redraw
	[self setNeedsDisplay];
}

- (void)endTouches:(NSSet *)touches
{
	//remove from the dictionary
	for (UITouch *t in touches) {
		NSValue *key = [NSValue valueWithPointer:t];
		Line *line = [linesInProcess objectForKey:key];
		
		//if it's a double tap, line will be nil
		if (line) {
			[completeLines addObject:line];
			[linesInProcess removeObjectForKey:key];
			
			NSString *linePath = [self lineArrayPath];
			
			NSMutableArray *lineArray = [self completedLines];
			[NSKeyedArchiver archiveRootObject:lineArray toFile:linePath];
			
		}
	}
	//redraw
	[self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches 
		   withEvent:(UIEvent *)event
{
	[self endTouches:touches];
}

- (void)touchesCancelled:(NSSet *)touches 
			   withEvent:(UIEvent *)event
{
	[self endTouches:touches];
}

#pragma mark -
#pragma mark Cleanup

- (void)dealloc {
	[linesInProcess release];
	[completeLines release];
    [super dealloc];
}


@end
