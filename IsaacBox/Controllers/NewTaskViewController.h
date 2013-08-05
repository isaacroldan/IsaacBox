//
//  NewTaskViewController.h
//  IsaacBox
//
//  Created by Pedro Piñera Buendía on 23/07/13.
//  Copyright (c) 2013 cowders. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "defaultCell.h"
#import "extensibleCell.h"
#import "multiChoiceCell.h"
#import "TBProject.h"
#import "TBTaskList.h"
#import "dateCell.h"
#import "checkboxCell.h"
#import "radioSelectionCell.h"
@interface NewTaskViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,FormCellDelegate,FormCellDataSource>



@end
