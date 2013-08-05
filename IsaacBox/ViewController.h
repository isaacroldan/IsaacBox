//
//  ViewController.h
//  IsaacBox
//
//  Created by Isaac Roldan Armengol on 29/06/13.
//  Copyright (c) 2013 cowders. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCell.h"  
#import "LoginViewController.h"


@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, JZSwipeCellDelegate, UISearchDisplayDelegate,LoginViewControllerDelegate>{
}

@property(nonatomic,strong) IBOutlet UITableView *tableView;
@property(nonatomic) BOOL searchIsActive;
@property(nonatomic,strong) NSMutableArray *tableData;
@property(nonatomic,strong) UIRefreshControl *refreshControl;
@property(nonatomic,strong) NSMutableArray *searchResults;
@property(nonatomic,strong) NSMutableArray *searchResultsTasks;

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope;
-(IBAction)logout:(id)sender;

@end
