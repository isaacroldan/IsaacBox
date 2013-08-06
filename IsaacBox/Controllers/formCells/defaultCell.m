//
//  defaultCell.m
//  IsaacBox
//
//  Created by Pedro Piñera Buendía on 24/07/13.
//  Copyright (c) 2013 cowders. All rights reserved.
//

#import "defaultCell.h"
@interface defaultCell()
@end

@implementation defaultCell
@synthesize titleLabel=_titleLabel;
@synthesize textField=_textField;
@synthesize isSecure=_isSecure;
@synthesize delegate;
@synthesize canBecomeActive;
@synthesize style=_style;


-(id)initWithTitle:(NSString*)title andStyle:(formRowStyle)style andPlaceholder:(NSString*)placeholder{
    self=[super init];
    if(self){
        self.style=style;
        CGSize labelsize=[title sizeWithFont:cell_title_font];
        float rowheight=[self getRowSize];
        
        //Default Values
        self.canBecomeActive=YES;
        
        
        //Selected style none
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        
        //Initialize label
        self.titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(cell_text_margin, 0, labelsize.width, rowheight)];
        self.titleLabel.textAlignment=NSTextAlignmentLeft;
        self.titleLabel.backgroundColor=[UIColor clearColor];
        self.titleLabel.text=title;
        self.titleLabel.font=cell_title_font;
        [self.contentView addSubview:self.titleLabel];
        
        //Initialize textfield
         self.textField=[[UITextField alloc] initWithFrame:CGRectMake(2*cell_text_margin+labelsize.width, rowheight/2-labelsize.height/2,self.contentView.frame.size.width-3*cell_text_margin-labelsize.width , labelsize.height)];
        self.textField.textAlignment=NSTextAlignmentRight;
        [self.textField setClearButtonMode:UITextFieldViewModeWhileEditing];
        self.textField.delegate=self;
        self.textField.textColor=[UIColor darkGrayColor];
        self.textField.font=cell_detail_font;
        if(placeholder)
            self.textField.placeholder=placeholder;
        [self.contentView addSubview:self.textField];
        
        //Adding UITextField Accesory Bar
        [self addAccesoryViewToTextField:self.textField];
        
        //Customize cell
        [self customizeCellWithStyle];

    }
    return self;
}
-(void)customizeCellWithStyle{
    ///// CUSTOMIZE CELL ////
    if(self.style==formRowStyleHeader){
        self.titleLabel.textColor=[UIColor whiteColor];
        self.backgroundView =  [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"category.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
    
    }
    else if (self.style == formRowStyleRow){
        self.backgroundView.backgroundColor=[UIColor colorWithWhite:0.95 alpha:1.0];

    }else if (self.style == formRowStyleRowBlue){
        self.backgroundView =  [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"cellUp.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
        self.titleLabel.textColor=[UIColor whiteColor];
        self.textField.textColor=[UIColor whiteColor];
        [self.textField setValue:[UIColor darkGrayColor]
                        forKeyPath:@"_placeholderLabel.textColor"];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)addAccesoryViewToTextField:(id)textField{
    //Adding accesory bar to textField
    //Adding comment
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    [toolbar setBarStyle:UIBarStyleBlackTranslucent];
    [toolbar sizeToFit];
    
    UIBarButtonItem *previousButton=[[UIBarButtonItem alloc] initWithTitle:@"Previous" style:UIBarButtonItemStyleBordered target:self action:@selector(previousFormRow)];
    UIBarButtonItem *flexButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *cancelButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(cancelFormRow)];
    UIBarButtonItem *flexButton2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *nextButton=[[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(nextFormRow)];
    
    NSArray *itemsArray = [NSArray arrayWithObjects:previousButton,flexButton,cancelButton,flexButton2, nextButton, nil];
    [toolbar setItems:itemsArray];
    [textField setInputAccessoryView:toolbar];
}

#pragma mark - TextField Accesory
-(void)previousFormRow{
    //Notifying delegate
    [delegate formRowSelectedPrevious:self];
}
-(void)nextFormRow{
    //Notifying delegate
    [delegate formRowSelectedNext:self];

}
-(void)cancelFormRow{
    //Notifying delegate
    [delegate formRowSelectedCancel:self];
}
-(void)becomeActive{
    //Becoming first responder
    [self.textField becomeFirstResponder];
}
-(void)resignActive{
    //Resigning first responder
    [self.textField resignFirstResponder];
}
-(void)selectCell{
}
#pragma mark - UITextField Delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    //Notifying delegate
    [delegate formRowBecameActive:self];
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    //Notifying delegate
    [delegate formRowEndActive:self];
}
#pragma mark - Setters
-(void)setIsSecure:(BOOL)isSecure{
    //Setting isSecure to textField
    self.isSecure=isSecure;
    [self.textField setSecureTextEntry:isSecure];
}

#pragma mark - Getters
-(id)getFormRowValue{
    //It depends on the kind of defaultCell subclass
    //It might be a NSDate, NSString for example...
    return nil;
}
-(CGFloat)getRowSize{
    //Static method to return Row Size to the TableView
    // Row size can be Static or Dynamic
    switch (self.style) {
        case formRowStyleHeader:
            return 24;
            break;
        case formRowStyleRow:
            return 44;
            break;
        case formRowStyleRowBlue:
            return 44;
            break;
        default:
            return 0;
            break;
    }
}
-(NSInteger)numberOfSubrows{
    //Because a Cell could have subrows
    return 0;
}
-(defaultCell*)getSubCellAtIndex:(NSInteger)index{
    //If the cell has subrows this method returns the subCell of a given index
    return nil;
}

-(id)getRowValue{
    return self.textField.text;
}
@end
