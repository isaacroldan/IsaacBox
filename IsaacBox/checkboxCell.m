//
//  checkboxCell.m
//  IsaacBox
//
//  Created by Pedro Piñera Buendía on 28/07/13.
//  Copyright (c) 2013 cowders. All rights reserved.
//

#import "checkboxCell.h"
@interface checkboxCell()
@property (nonatomic,strong) UIButton *checkButton;
@end
@implementation checkboxCell
@synthesize checkButton=_checkButton;
-(id)initWithTitle:(NSString*)title andStyle:(formRowStyle)style andPlaceholder:(NSString*)placeholder{
    self=[super init];
    if(self){
        self.style=style;
        CGSize labelsize=[title sizeWithFont:cell_title_font];
        float rowheight=[self getRowSize];
        self.canBecomeActive=NO;
        
        //Selected style none
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        
        //Initialize label
        self.titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(cell_text_margin, 0, labelsize.width, rowheight)];
        self.titleLabel.textAlignment=NSTextAlignmentLeft;
        self.titleLabel.backgroundColor=[UIColor clearColor];
        self.titleLabel.text=title;
        self.titleLabel.font=cell_title_font;
        [self.contentView addSubview:self.titleLabel];
        
               
        //Initializing check Button
        UIImage *checkButtonImage=[UIImage imageNamed:@"check.png"];
        UIImage *checkButtonImaged=[UIImage imageNamed:@"checkd.png"];
        self.checkButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [self.checkButton addTarget:self action:@selector(checkSelected:) forControlEvents:UIControlEventTouchUpInside];
        [self.checkButton setImage:checkButtonImage forState:UIControlStateNormal];
        [self.checkButton setImage:checkButtonImaged forState:UIControlStateHighlighted];
        [self.checkButton setImage:checkButtonImaged forState:UIControlStateSelected];

        self.checkButton.frame=CGRectMake(self.contentView.frame.size.width-cell_text_margin-checkButtonImage.size.width, rowheight/2-checkButtonImage.size.height/2, checkButtonImage.size.width, checkButtonImage.size.height);
        [self.contentView addSubview:self.checkButton];

        
        //Adding UITextField Accesory Bar
        [self addAccesoryViewToTextField:self.textField];
        
        //Customize cell
        [self customizeCellWithStyle];
        
    }
    return self;
}
-(IBAction)checkSelected:(id)sender{
    [self.checkButton setSelected:!self.checkButton.selected];
}

-(BOOL)getRowValue{
    return self.checkButton.selected;
}
@end
