//
//  dateCell.m
//  IsaacBox
//
//  Created by Pedro Piñera Buendía on 28/07/13.
//  Copyright (c) 2013 cowders. All rights reserved.
//

#import "dateCell.h"
@interface dateCell()
@property (nonatomic,strong) UIDatePicker *datePicker;
@property (nonatomic,strong) NSDate* selectedDate;
@property (nonatomic,strong) NSDateFormatter *dateFormater;
@end
@implementation dateCell
@synthesize datePicker=_datePicker;
@synthesize dateFormater=_dateFormater;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithTitle:(NSString*)title andStyle:(formRowStyle)style andPlaceholder:(NSString*)placeholder{
    self=[super init];
    if(self){
        self.style=style;
        CGSize labelsize=[title sizeWithFont:cell_title_font];
        float rowheight=[self getRowSize];
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
        
        //Initializing picker
        _datePicker=[[UIDatePicker alloc] init];
        _datePicker.datePickerMode=UIDatePickerModeDateAndTime;
        _datePicker.date=[NSDate date];
        self.textField.text=[self.dateFormater stringFromDate:self.datePicker.date];
        self.selectedDate=self.datePicker.date;
        [_datePicker addTarget:self action:@selector(dateChangued) forControlEvents:UIControlEventValueChanged];
        [self.textField setInputView:self.datePicker];
        
        //Adding UITextField Accesory Bar
        [self addAccesoryViewToTextField:self.textField];
        
        //Customize cell
        [self customizeCellWithStyle];
        
    }
    return self;
}

#pragma mark - Date Picker Delegate
-(void)dateChangued{
    self.selectedDate=self.datePicker.date;
    self.textField.text=[self.dateFormater stringFromDate:self.selectedDate];
}
#pragma mark - Lazy Instantiation
-(NSDateFormatter*)dateFormater{
    if(!_dateFormater){
        _dateFormater=[[NSDateFormatter alloc] init];
        [_dateFormater setDateFormat:@"MM/dd/yyyy HH:mm"];
    }
    return _dateFormater;
}
-(id)getRowValue{
    return self.selectedDate;
}
@end
