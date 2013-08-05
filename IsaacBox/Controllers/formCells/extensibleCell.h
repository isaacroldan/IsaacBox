//
//  multiSelectionCell.h
//  IsaacBox
//
//  Created by Pedro Piñera Buendía on 24/07/13.
//  Copyright (c) 2013 cowders. All rights reserved.
//

#import "defaultCell.h"
#import "KTTextView.h"
@interface extensibleCell : defaultCell<UITextViewDelegate>

//Properties
@property(nonatomic,strong) KTTextView *textView;

@end
