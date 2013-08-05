//
//  ViewController.m
//  IsaacBox
//
//  Created by Isaac Roldan Armengol on 29/06/13.
//  Copyright (c) 2013 cowders. All rights reserved.
//

#import "ViewController.h"
#import "AFOAuth2Client.h"
#import "TBTask.h"
#import "TBTaskList.h"
#import "UIBAlertView.h"
#import "NewTaskViewController.h"
@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.searchIsActive = false;
    
    //Custom Logout button
    UIButton *myButton = [[UIButton alloc] init];
    [myButton setBackgroundImage:[UIImage imageNamed:@"navButton.png"] forState:UIControlStateNormal];
    [myButton setBackgroundImage:[UIImage imageNamed:@"navButtonDown.png"] forState:UIControlStateHighlighted];
    [myButton setTitle:@"Logout" forState:UIControlStateNormal];
    [myButton.titleLabel setTextColor:[UIColor whiteColor]];
    [myButton.titleLabel setShadowColor:[UIColor colorWithRed:61.0/255.0 green:170.0/255.0 blue:190.0/255.0 alpha:1]];
    [myButton.titleLabel setShadowOffset:CGSizeMake(0, -0.5)];
    [myButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12]];
    [myButton setFrame:CGRectMake(100, 100, 65, 30)];
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithCustomView:myButton];
    [myButton addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItem:button];
    
    
    //Adding back button
    UIButton *addButton=[UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame=CGRectMake(0, 0, 63, 36);
    [addButton addTarget:self action:@selector(newTask) forControlEvents:UIControlEventTouchUpInside];
    [addButton setImage:[UIImage imageNamed:@"addTaskButton.png"] forState:UIControlStateNormal];
    UIBarButtonItem *addBarButton=[[UIBarButtonItem alloc] initWithCustomView:addButton];
    self.navigationItem.leftBarButtonItem=addBarButton;

    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [refresh addTarget:self
                action:@selector(loadData)
      forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    [self.tableView addSubview:self.refreshControl];
    
    
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.searchDisplayController.searchResultsTableView setBackgroundColor:[UIColor lightGrayColor]];
    [self.searchDisplayController.searchResultsTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    
    //A Task will inform via NotificationCenter if it is updated or deleted
    [[NSNotificationCenter defaultCenter] addObserverForName:@"TaskUpdated" object:nil queue:nil usingBlock:^(NSNotification *note){
        NSLog(@"Task Updated!!");
        NSString *info = [[note userInfo] objectForKey:@"Message"];
        [SVProgressHUD showSuccessWithStatus:info];
            [self loadData];
    }];
    
    
    //Custon SearchBar Background
    for (UIView *subview in [self.searchDisplayController.searchBar subviews]) {
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
        {
            UIImageView *barback=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellUp.png"]];
            barback.contentMode=UIViewContentModeScaleAspectFill;
            [subview addSubview:barback];
        }
    }
    
    [self login];
}


//If there is no valid credential, show the login view, else: start downloading the data from TB.
-(void)login{
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:@"IsaacBox"];
    if (!credential || [credential isExpired]) {
        LoginViewController *loginView = [[LoginViewController alloc] init];
        loginView.delegate = self;
        [self presentViewController:loginView animated:YES completion:nil];
    }else{
        [self loadData];
    }
}


//Delete the current credential and show the login view
-(IBAction)logout:(id)sender{
    [AFOAuthCredential deleteCredentialWithIdentifier:@"IsaacBox"];
    [self login];
}

//This ViewController is the delegate of the LoginView, and the LoginView will inform when this controller should dismiss it.
- (void)LoginViewControllerDidFinish:(LoginViewController *)controller{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self loadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




//LazyInstantations
-(NSMutableArray *)searchResults{
    if(!_searchResults)_searchResults = [[NSMutableArray alloc] init];
    return _searchResults;
}
-(NSMutableArray *)searchResultsTasks{
    if(!_searchResultsTasks)_searchResultsTasks = [[NSMutableArray alloc] init];
    return _searchResultsTasks;
}
-(NSMutableArray *)tableData{
    if(!_tableData) _tableData = [[NSMutableArray alloc] init];
    return _tableData;
}





//First download data from Task Lists and then, download data from Tasks.
//Operations defined with AFNetworking
//Using a NSOperationQueue and Depencencies.
-(void)loadData{
    [SVProgressHUD showWithStatus:@"Downloading data..."];
        
    NSString *stringLists = [NSString stringWithFormat:@"https://teambox.com/api/2/task_lists?access_token=%@",[[AFOAuthCredential retrieveCredentialWithIdentifier:@"IsaacBox"] accessToken]];
    NSURL *urlLists = [NSURL URLWithString:stringLists];
    NSMutableURLRequest *requestLists = [NSMutableURLRequest requestWithURL:urlLists];
    [requestLists setHTTPMethod:@"GET"];
    AFJSONRequestOperation *operationLists = [AFJSONRequestOperation JSONRequestOperationWithRequest:requestLists success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON){
        NSMutableArray *auxArray = [[NSMutableArray alloc] init];
        for(NSDictionary *item in JSON) {
            TBTaskList *newList = [[TBTaskList alloc] initWithDictionary:item];
            [newList setTableViewSectionExpanded:YES];
            [auxArray addObject:newList];
        }
        [self setTableData:auxArray];
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            NSLog(@"%@", [error userInfo]);
            [SVProgressHUD showErrorWithStatus:@"Error :("];
            [self.refreshControl endRefreshing];
            [self.tableView reloadData];
    }];
    
    
    
    NSString *stringTasks = [NSString stringWithFormat:@"https://teambox.com/api/2/tasks?access_token=%@",[[AFOAuthCredential retrieveCredentialWithIdentifier:@"IsaacBox"] accessToken]];
    NSURL *urlTasks = [NSURL URLWithString:stringTasks];
    NSMutableURLRequest *requestTasks = [NSMutableURLRequest requestWithURL:urlTasks];
    [requestTasks setHTTPMethod:@"GET"];
    AFJSONRequestOperation *operationTasks = [AFJSONRequestOperation JSONRequestOperationWithRequest:requestTasks success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON){
        for(NSDictionary *item in JSON) {
            TBTask *newTask = [[TBTask alloc] initWithDictionary:item];
            NSArray *filtered = [self.tableData filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"taskListId = %@",newTask.taskListId]];
            if ([filtered count]){
                TBTaskList *myList = filtered[0];
                [myList.taskArray addObject:newTask];
            }
            //NSLog(@"Task: %@", item);
        }
        [self.tableView reloadData];
        [SVProgressHUD showSuccessWithStatus:@"Done!"];
        [self.refreshControl endRefreshing];

    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            NSLog(@"%@", [error userInfo]);
            [SVProgressHUD showErrorWithStatus:@"Error :("];
            [self.refreshControl endRefreshing];
            [self.tableView reloadData];
    }];
    
    
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    [operationTasks addDependency:operationLists];
    [operationQueue addOperations:@[operationLists, operationTasks] waitUntilFinished:NO];
    
    
}





#pragma mark - UISearchDisplayDelegate

//Create Custom button when the search starts. This can't be done in the viewDidLoad
-(void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller{
    self.searchIsActive = true;
    [controller.searchBar setShowsCancelButton:YES animated:YES];
    for(UIView *subView in controller.searchBar.subviews){
        if([subView isKindOfClass:NSClassFromString(@"UIButton")]){
            UIButton *closebutton=(UIButton*)subView;
            [closebutton setBackgroundImage:[UIImage imageNamed:@"navButton.png"] forState:UIControlStateNormal];
            [closebutton setBackgroundImage:[UIImage imageNamed:@"navButtonDown.png"] forState:UIControlStateHighlighted];
            [closebutton.titleLabel setTextColor:[UIColor whiteColor]];
            [closebutton.titleLabel setShadowColor:[UIColor colorWithRed:61.0/255.0 green:170.0/255.0 blue:190.0/255.0 alpha:1]];
            [closebutton.titleLabel setShadowOffset:CGSizeMake(0, -0.5)];
            [closebutton setTitle:@"Cancel" forState:UIControlStateNormal];
            [closebutton setTitle:@"Cancel" forState:UIControlStateHighlighted];
        }
    }
}

-(void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller{
    
}

-(void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller{
    self.searchIsActive = false;
    [controller.searchBar setShowsCancelButton:NO animated:YES];
    [self.tableView reloadData];
}

//For each search, we apply our filter
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    return YES;
}
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    return YES;
}

//Filter the data to populate the searchtableview.
//Creates an array of TaskList filtered and an array of Task Filtered
//Careful, the filtered arrays are mutableCopys of the original ones, but the referenced objects inside them are the same!!
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope{

    NSMutableArray *aux = [[NSMutableArray alloc] init];
    NSMutableArray *aux2 = [[NSMutableArray alloc] init];
    for (TBTaskList *item in self.tableData) {
        
        NSPredicate *resultPredicate = [NSPredicate
                                        predicateWithFormat:@"name contains %@",
                                        searchText];
        NSMutableArray *array =[[item.taskArray filteredArrayUsingPredicate:resultPredicate] mutableCopy];
        if ([array count]) {
            [aux2 addObject:array];
            [aux addObject:item];
        }
    }
    self.searchResults=aux;
    self.searchResultsTasks=aux2;
    
    //NSLog(@"RESULTS: %@",self.searchResults);
    //NSLog(@"RESULTS: %@",self.searchResultsTasks);
}



#pragma mark - UITableViewDelegate + UITableViewDataSource methods
//We have four different cells:
//1: main TableView, cell 0 of each section, shows the name of the taskList
//2: main TableView, cell >0 of each section, shows the name of the Tasks included in a taskList (section)
//3: searchDisplay TableView, cell 0 of each section, shows the name of the taskList
//4: searchDisplay TableView, cell >0 of each section, shows the name of the Tasks included in a taskList (section)

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    

	//Main Table View
    if (tableView==self.tableView) {
        TBTaskList *myList = self.tableData[indexPath.section];
        if (indexPath.row==0) {
            static NSString *CellIdentifier = @"Cell";
            UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellUp.png"]];
                cell.selectedBackgroundView  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellDown.png"]];
            }
            cell.textLabel.text = [NSString stringWithFormat:@"%@",[myList name]];
            [cell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16]];
            [cell.textLabel setTextColor:[UIColor whiteColor]];
            [cell.textLabel setBackgroundColor:[UIColor clearColor]];
            [cell.textLabel setShadowColor:[UIColor colorWithRed:61.0/255.0 green:170.0/255.0 blue:190.0/255.0 alpha:1]];
            [cell.textLabel setShadowOffset:CGSizeMake(0, 1)];
            return cell;
        }else{
            MyCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[MyCell cellID]];
            if (!cell)
            {
                cell = [[MyCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:[MyCell cellID]];
                //[cell setBackgroundColor:[UIColor clearColor]];
                //cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellBack.png"]];

            }
            cell.textLabel.text = [myList.taskArray[indexPath.row-1] name];
            cell.textLabel.numberOfLines = 0;
            [cell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12]];
            [cell.textLabel setTextColor:[UIColor darkGrayColor]];
            [cell.textLabel setBackgroundColor:[UIColor clearColor]];
            [cell.textLabel setShadowColor:[UIColor whiteColor]];
            [cell.textLabel setShadowOffset:CGSizeMake(0, 1)];
            cell.delegate = self;
            return cell;
        }
                
    //searchDisplay Table View
    }else{
        TBTaskList *myList = self.searchResults[indexPath.section];
        NSArray *array = self.searchResultsTasks[indexPath.section];
        if (indexPath.row==0) {
            static NSString *CellIdentifier = @"SearchCell";
            UITableViewCell *cell = [self.searchDisplayController.searchResultsTableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellUp.png"]];
                cell.selectedBackgroundView  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellDown.png"]];
            }
            cell.textLabel.text = [NSString stringWithFormat:@"%@",[myList name]];
            [cell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16]];
            [cell.textLabel setTextColor:[UIColor whiteColor]];
            [cell.textLabel setBackgroundColor:[UIColor clearColor]];
            [cell.textLabel setShadowColor:[UIColor colorWithRed:61.0/255.0 green:170.0/255.0 blue:190.0/255.0 alpha:1]];
            [cell.textLabel setShadowOffset:CGSizeMake(0, 1)];
            return cell;
        }else{
            MyCell *cell = [self.searchDisplayController.searchResultsTableView dequeueReusableCellWithIdentifier:[MyCell cellID]];
            if (!cell)
            {
                cell = [[MyCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:[MyCell cellID]];
            }
            cell.textLabel.text = [array[indexPath.row-1] name];
            cell.textLabel.numberOfLines = 0;
            [cell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12]];
            [cell.textLabel setTextColor:[UIColor darkGrayColor]];
            [cell.textLabel setBackgroundColor:[UIColor clearColor]];
            [cell.textLabel setShadowColor:[UIColor whiteColor]];
            [cell.textLabel setShadowOffset:CGSizeMake(0, 1)];
            cell.delegate = self;
            return cell;
        }
    }
    
	
}


//If the user selects a row at index 0, i.e. the row with the name of the TaskList
//That section will expand or collapse.
//Different for each TableView
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        TBTaskList *myList;
        
        if (tableView==self.tableView) {
            myList = self.tableData[indexPath.section];
            myList.tableViewSectionExpanded = !myList.tableViewSectionExpanded;
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
        }else{
            myList = self.searchResults[indexPath.section];
            myList.tableViewSectionExpanded = !myList.tableViewSectionExpanded;
            [self.searchDisplayController.searchResultsTableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    
    }
}


//Each TableView has a different number of sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView==self.tableView) {
        return [self.tableData count];
    }else{
        return [self.searchResults count];
    }
	
}


//For each section (TaskList), the number of Tasks.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        TBTaskList *myList = self.tableData[section];
        return myList.tableViewSectionExpanded ? [myList.taskArray count]+1 : 1;
    }else{
        TBTaskList *myList = self.searchResults[section];
        NSArray *myArray = self.searchResultsTasks[section];
        return myList.tableViewSectionExpanded ? [myArray count]+1 : 1;
    }
}


//The first row of each section (TaskList name), is smaller than the rest of the cells.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row==0 ? 35 : 59;
}


#pragma mark - JZSwipeCellDelegate methods
//SwipeCell method. Only two posibilities: right swipe or left swipe (Mark task as completed OR Delete task)
//Different for each tableView.
- (void)swipeCell:(JZSwipeCell*)cell triggeredSwipeWithType:(JZSwipeType)swipeType
{
	if (swipeType == JZSwipeTypeShortRight || swipeType == JZSwipeTypeLongRight)
	{
        
        [SVProgressHUD showWithStatus:@"Updating Task..."];
        if (!self.searchIsActive) {
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            if (indexPath)
            {
                TBTaskList *myList = self.tableData[indexPath.section];
                TBTask *task = myList.taskArray[indexPath.row-1];
                [task markAsCompleted];
                [myList.taskArray removeObjectAtIndex:indexPath.row-1];
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
        }else{
            NSIndexPath *indexPath2= [self.searchDisplayController.searchResultsTableView indexPathForCell:cell];
            if (indexPath2)
            {
                TBTaskList *myList = self.searchResults[indexPath2.section];
                NSMutableArray *tasks = self.searchResultsTasks[indexPath2.section];
                
                int index=[self.tableData indexOfObjectIdenticalTo:myList];
                TBTaskList *myList2 = [self.tableData objectAtIndex:index];
                TBTask *task = myList.taskArray[indexPath2.row-1];
                [task markAsCompleted];
                [myList2.taskArray removeObject:tasks[indexPath2.row-1]];
                //[tasks removeObject:tasks[indexPath2.row-1]];
                
                [self.searchResultsTasks[indexPath2.section] removeObjectAtIndex:indexPath2.row-1];
                [self.searchDisplayController.searchResultsTableView deleteRowsAtIndexPaths:@[indexPath2] withRowAnimation:UITableViewRowAnimationFade];
                
                [self.tableView reloadData];
            }
        }
	}else if (swipeType == JZSwipeTypeShortLeft || swipeType == JZSwipeTypeLongLeft )
	{
        
        UIBAlertView *alert = [[UIBAlertView alloc] initWithTitle:@"Alert" message:@"Delete Task?" cancelButtonTitle:@"Cancel" otherButtonTitles:@"Continue",nil];
        [alert showWithDismissHandler:^(NSInteger selectedIndex, BOOL didCancel) {
            
            if (didCancel) {
                
                NSLog(@"User cancelled");
                if (!self.searchIsActive) {
                    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
                    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                }else{
                    NSIndexPath *indexPath2= [self.searchDisplayController.searchResultsTableView indexPathForCell:cell];
                    [self.searchDisplayController.searchResultsTableView reloadRowsAtIndexPaths:@[indexPath2] withRowAnimation:UITableViewRowAnimationLeft];
                }
                return;
                
            }else{
                
                [SVProgressHUD showWithStatus:@"Deleting Task..."];
                if (!self.searchIsActive) {
                    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
                    if (indexPath)
                    {
                        TBTaskList *myList = self.tableData[indexPath.section];
                        TBTask *task = myList.taskArray[indexPath.row-1];
                        [task deleteTask];
                        [myList.taskArray removeObjectAtIndex:indexPath.row-1];
                        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    }
                }else{
                    NSIndexPath *indexPath2= [self.searchDisplayController.searchResultsTableView indexPathForCell:cell];
                    if (indexPath2)
                    {
                        TBTaskList *myList = self.searchResults[indexPath2.section];
                        NSMutableArray *tasks = self.searchResultsTasks[indexPath2.section];
                        
                        int index=[self.tableData indexOfObjectIdenticalTo:myList];
                        TBTaskList *myList2 = [self.tableData objectAtIndex:index];
                        TBTask *task = myList.taskArray[indexPath2.row-1];
                        [task deleteTask];
                        [myList2.taskArray removeObject:tasks[indexPath2.row-1]];
                        //[tasks removeObject:tasks[indexPath2.row-1]];
                        
                        [self.searchResultsTasks[indexPath2.section] removeObjectAtIndex:indexPath2.row-1];
                        [self.searchDisplayController.searchResultsTableView deleteRowsAtIndexPaths:@[indexPath2] withRowAnimation:UITableViewRowAnimationFade];
                        
                        [self.tableView reloadData];
                    }
                }
                
            }
        }];     
    }	
}

#pragma mark - Actions
-(void)newTask{
    //Presenting new task View Controller
    NewTaskViewController *newTask=[[NewTaskViewController alloc] initWithNibName:@"NewTaskViewController" bundle:[NSBundle mainBundle]];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:newTask] animated:YES completion:nil];
}



@end
