/*
 *  FileHelpers.m
 *  Homepwner
 *
 *  Created by Chris Readle (GMC-MSV-IT CONTRACTOR) on 10/13/10.
 *  Copyright 2010 __MyCompanyName__. All rights reserved.
 *
 */

#include "FileHelpers.h"

NSString *pathInDocumentDirectory(NSString *fileName)
{
	NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory
																	   , NSUserDomainMask, YES);
	NSString *documentDirectory = [documentDirectories objectAtIndex:0];
	return [documentDirectory stringByAppendingPathComponent:fileName];
}

