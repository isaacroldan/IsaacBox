//
//  multiSelectionCell.m
//  IsaacBox
//
//  Created by Pedro Piñera Buendía on 24/07/13.
//  Copyright (c) 2013 cowders. All rights reserved.
//

#import "extensibleCell.h"
#import "KTTextView.h"
@interface extensibleCell()

@end
@implementation extensibleCell
@synthesize numLines=_numLines;
@synthesize rowHeight=_rowHeight;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(id)initWithTitle:(NSString*)title andStyle:(formRowStyle)style andPlaceholder:(NSString *)placeholder{
    self=[super init];
    if(self){
        self.style=style;
        CGSize labelsize=[@"Detail text" sizeWithFont:cell_title_font];
        self.numLines=1;
        self.rowHeight=44;
        float rowheight=[self getRowSize];
        
        //Default Values
        self.canBecomeActive=YES;
        
        
        //Selected style none
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        
        
        //Initialize textview
        self.textView=[[KTTextView alloc] initWithFrame:CGRectMake(cell_text_margin, rowheight/2-(labelsize.height+10)/2,self.contentView.frame.size.width-2*cell_text_margin, labelsize.height+10)];
        self.textView.placeholderText=placeholder;
        self.textView.textAlignment=NSTextAlignmentLeft;
        self.textView.delegate=self;
        self.textView.backgroundColor=[UIColor clearColor];
        self.textView.textColor=[UIColor darkGrayColor];
        self.textView.font=cell_detail_font;
        self.textView.scrollEnabled=NO;
        [self.contentView addSubview:self.textView];
        self.textView.contentInset=UIEdgeInsetsZero;
        

        
        //Adding UITextField Accesory Bar
        [self addAccesoryViewToTextField:self.textView];
        
        //Customize cell
        [self customizeCellWithStyle];
        
    }
    return self;
}
-(CGFloat)getRowSize{
    return self.rowHeight;
}

#pragma mark - TextView Delegate
-(void)textViewDidChange:(UITextView *)textView{
    int numLines = textView.contentSize.height/textView.font.leading;
    if(numLines!=self.numLines){
        //Notifying Tableview
        self.rowHeight=2*textView.frame.origin.y+textView.contentSize.height;
        [self.delegate formRowChanged:self];

        //The number of lines has changued
        self.numLines=numLines;
        
        //Changing textView Fraame
        self.textView.frame=CGRectMake(textView.frame.origin.x, textView.frame.origin.y, self.textView.frame.size.width, textView.contentSize.height);
        self.textView.contentInset=UIEdgeInsetsZero;
    }
}

#pragma mark - TextField Accesory
-(void)cancelFormRow{
    [self.delegate formRowSelectedCancel:self];
}
-(void)becomeActive{
    [self.textView becomeFirstResponder];
}
-(void)resignActive{
    [self.textView resignFirstResponder];
}

-(id)getRowValue{
    return self.textView.text;
}
@end
