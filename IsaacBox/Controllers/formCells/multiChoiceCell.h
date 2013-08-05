//
//  multiChoiceCell.h
//  IsaacBox
//
//  Created by Pedro Piñera Buendía on 28/07/13.
//  Copyright (c) 2013 cowders. All rights reserved.
//

#import "defaultCell.h"
@protocol FormCellDataSource
- (NSArray*)getValuesForMultiChoiceCell:(id)sender;
@end

@interface multiChoiceCell : defaultCell<UIPickerViewDataSource,UIPickerViewDelegate>

// Properties
@property (assign) id <FormCellDataSource> dataSource;
@property (nonatomic,readonly) id SelectedItem;
@property (nonatomic) BOOL canBecomeActive;
@end
