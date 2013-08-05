//
//  MyCell.h
//  IsaacBox
//
//  Created by Isaac Roldan Armengol on 29/06/13.
//  Copyright (c) 2013 cowders. All rights reserved.
//

#import "MyCell.h"

@implementation MyCell 


//Custom Cell.
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		self.imageSet = SwipeCellImageSetMake([UIImage imageNamed:@"complete"], [UIImage imageNamed:@"complete"], [UIImage imageNamed:@"delete"], [UIImage imageNamed:@"delete"]);
        UIColor *myGreen = [UIColor colorWithRed:50.0/255.0 green:205.0/255.0 blue:50.0/255.0 alpha:1];
        UIColor *myRed = [UIColor colorWithRed:206.0/255.0 green:0 blue:0 alpha:1];
		self.colorSet = SwipeCellColorSetMake(myGreen,myGreen,myRed,myRed);
    }
    return self;
}

+ (NSString*)cellID
{
	return @"myCell";
}

@end
