//
//  defaultCell.h
//  IsaacBox
//
//  Created by Pedro Piñera Buendía on 24/07/13.
//  Copyright (c) 2013 cowders. All rights reserved.
//

#import <UIKit/UIKit.h>
#define cell_text_margin 15
#define cell_text_size 15
#define cell_title_font [UIFont boldSystemFontOfSize:15]
#define cell_detail_font [UIFont systemFontOfSize:15]
@protocol FormCellDelegate
-(void)formRowChanged:(id)sender;
-(void)formSectionChanged:(id)sender;
-(void)formRowSelectedPrevious:(id)sender;
-(void)formRowSelectedNext:(id)sender;
-(void)formRowSelectedCancel:(id)sender;
-(void)formRowBecameActive:(id)sender;
-(void)formRowEndActive:(id)sender;

@end

typedef enum formRowStyle : NSUInteger {
    formRowStyleHeader,
    formRowStyleRow,
    formRowStyleRowBlue,
} formRowStyle;

@interface defaultCell : UITableViewCell<UITextFieldDelegate>{

}
//Methods
-(id)initWithTitle:(NSString*)title andStyle:(formRowStyle)style andPlaceholder:(NSString*)placeholder;
-(id)getFormRowValue;
-(CGFloat)getRowSize;
-(NSInteger)numberOfSubrows;
-(defaultCell*)getSubCellAtIndex:(NSInteger)index;
-(void)selectCell;
-(void)becomeActive;
-(void)resignActive;
-(void)addAccesoryViewToTextField:(id)textField;
-(void)customizeCellWithStyle;

-(id)getRowValue;

//Properties
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UITextField *textField;
@property(nonatomic) BOOL isSecure;
@property(nonatomic) BOOL canBecomeActive;
@property (nonatomic) NSInteger numLines;
@property (nonatomic) CGFloat rowHeight;
@property (nonatomic) formRowStyle style;
@property(nonatomic, assign) id<FormCellDelegate> delegate;

@end
