//
//  radioSelectionCell.m
//  IsaacBox
//
//  Created by Pedro Piñera Buendía on 28/07/13.
//  Copyright (c) 2013 cowders. All rights reserved.
//

#import "radioSelectionCell.h"
#import "UIImageView+AFNetworking.h"
@interface defaultImageCell: defaultCell
@property (nonatomic,strong) UIImageView *cellImage;
@property (nonatomic) BOOL cellSelected;
@property (nonatomic,strong) NSString *identifier;
@end
@implementation defaultImageCell
-(id)initWithTitle:(NSString*)title andImageURL:(NSString*)imageURLString andIdentifier:(NSString*)identifier{
    self=[super init];
    if(self){
        self.style=formRowStyleRow;
        float rowheight=[self getRowSize];
        
        //Default Values
        self.canBecomeActive=YES;        
        self.cellSelected=NO;
        self.identifier=identifier;
        
        //Selected style none
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        
        //Initialize label
        self.titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 0, self.contentView.frame.size.width-50-cell_text_margin, rowheight)];
        self.titleLabel.textAlignment=NSTextAlignmentLeft;
        self.titleLabel.backgroundColor=[UIColor clearColor];
        self.titleLabel.text=title;
        self.titleLabel.font=cell_title_font;
        [self.contentView addSubview:self.titleLabel];
        
        
        //Initializa UIImage
        self.cellImage=[[UIImageView alloc] initWithFrame:CGRectMake(0.2*cell_text_margin, rowheight/2-(rowheight/2)*0.7, 0.7*rowheight, 0.7*rowheight)];
        [self.cellImage setImageWithURL:[NSURL URLWithString:imageURLString]];
        [self.contentView addSubview:self.cellImage];
        
        //Customize cell
        [self customizeCellWithStyle];
        
    }
    return self;
}
-(void)selectCell{
    if(self.cellSelected){
        self.cellSelected=NO;
        self.contentView.backgroundColor=[UIColor colorWithWhite:0.95 alpha:1.0];
        self.titleLabel.textColor=[UIColor blackColor];
    }else{
        self.cellSelected=YES;
        self.contentView.backgroundColor=[UIColor colorWithRed:0.0f/255 green:206.0f/255 blue:112.0f/255 alpha:1.0];
        self.titleLabel.textColor=[UIColor whiteColor];
    }
}

@end

@interface radioSelectionCell()
@property (nonatomic,strong) NSMutableArray *subCells;
@end
@implementation radioSelectionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(NSInteger)numberOfSubrows{
    //Because a Cell could have subrows
    return self.subCells.count;
}
-(defaultCell*)getSubCellAtIndex:(NSInteger)index{
    return self.subCells[index];
}
-(void)reconfigureWithValues:(NSArray*)values{
    //Deleting existing cells
    [self.subCells removeAllObjects];
    
    //Generating news
    for (id value in values){
        defaultImageCell *newCell=[[defaultImageCell alloc] initWithTitle:[value getName] andImageURL:[value getImageURL] andIdentifier:[value getId]];
        [self.subCells addObject:newCell];
    }
    
    //Notifying
    [self.delegate formSectionChanged:self];
}
#pragma mark - Lazy Instantiation
-(NSMutableArray*)subCells{
    if(!_subCells)_subCells=[[NSMutableArray alloc] init];
    return _subCells;
}
-(id)getRowValue{
    NSMutableArray *selected=[[NSMutableArray alloc] init];
    for(defaultImageCell *cell in self.subCells){
        if(cell.cellSelected)
            [selected addObject:cell.identifier];
    }
    return selected;
}
@end
