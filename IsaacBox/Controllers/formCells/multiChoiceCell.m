//
//  multiChoiceCell.m
//  IsaacBox
//
//  Created by Pedro Piñera Buendía on 28/07/13.
//  Copyright (c) 2013 cowders. All rights reserved.
//

#import "multiChoiceCell.h"
@interface multiChoiceCell()
@property (nonatomic,strong) UIPickerView *picker;
@property (nonatomic,strong) id SelectedItem;
@end
@implementation multiChoiceCell
@synthesize picker=_picker;
@synthesize SelectedItem=_SelectedItem;
@synthesize canBecomeActive=_canBecomeActive;

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
        _picker=[[UIPickerView alloc] init];
        _picker.delegate=self;
        _picker.dataSource=self;
        _picker.showsSelectionIndicator=YES;
        [self.textField setInputView:self.picker];
        [self pickerView:self.picker didSelectRow:0 inComponent:0];

        
        //Adding UITextField Accesory Bar
        [self addAccesoryViewToTextField:self.textField];
        
        //Customize cell
        [self customizeCellWithStyle];
        
        
    }
    return self;
}
#pragma mark - Getters
-(BOOL)canBecomeActive{
    //Asking if there is data to our Cell
    //If there is data the cell can become active.
    if([self.dataSource getValuesForMultiChoiceCell:self])
        return YES;
    else
        return NO;
}
#pragma mark- TextField Delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    //Asking if canbecomeactive before showing the Picker
    return self.canBecomeActive;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    //Selecting a default value
    [self pickerView:self.picker didSelectRow:0 inComponent:0];
}
#pragma mark - Data Picker Delegate and DataSource
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    //Calling selectItemAtIndex to update the value in SelectedItem and the TextField text
    [self selectItemAtIndex:row];
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
   return [[self.dataSource getValuesForMultiChoiceCell:self] count];
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if([[self.dataSource getValuesForMultiChoiceCell:self][row]  respondsToSelector:@selector(getName)]){
        return [[self.dataSource getValuesForMultiChoiceCell:self][row] getName];
    }else{
        return @"";
    }
}
-(void)selectItemAtIndex:(NSInteger)index{
    self.SelectedItem=[self.dataSource getValuesForMultiChoiceCell:self][index];
    if([[self.dataSource getValuesForMultiChoiceCell:self][index]  respondsToSelector:@selector(getName)]){
        self.textField.text= [[self.dataSource getValuesForMultiChoiceCell:self][index] getName];
    }else{
        self.textField.text= @"";
    }
}

-(id)getRowValue{
    return [self.SelectedItem getId];
}
@end
