//
//  NewTaskViewController.m
//  IsaacBox
//
//  Created by Pedro Piñera Buendía on 23/07/13.
//  Copyright (c) 2013 cowders. All rights reserved.
//

#import "NewTaskViewController.h"

@interface NewTaskViewController ()
@property (nonatomic,strong) NSMutableArray *formFields;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *projectsArray;
@property(nonatomic,strong) NSArray *users;
@end

@implementation NewTaskViewController

@synthesize projectsArray=_projectsArray; //Array with available PROJECTS
@synthesize users=_users; //Array with all USERS

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=@"New task";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //Customizing navigation Bar
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBarBack2.png"] forBarMetrics:UIBarMetricsDefault];
    
    
    //Adding close button
    UIBarButtonItem *closeButton=[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(close)];
    [self.navigationItem setLeftBarButtonItem:closeButton];
    
    //Initialize form
    [self downloadProjectsAndLists];
    
    //Keyboard Observers
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //Adding back button
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame=CGRectMake(0, 0, 63, 36);
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"backButton.png"] forState:UIControlStateNormal];
    UIBarButtonItem *backBarButton=[[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=backBarButton;
    
    //Adding save button
    UIBarButtonItem *saveButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(saveTask)];
    self.navigationItem.rightBarButtonItem=saveButton;
}
-(void)back{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
-(void)saveTask{
    NSString *taskname=[(defaultCell*)self.formFields[0] getRowValue];
    NSString *taskdesc=[(defaultCell*)self.formFields[2] getRowValue];
    NSString *taskproj=[(multiChoiceCell*)self.formFields[3] getRowValue];
    NSString *tasklist=[(multiChoiceCell*)self.formFields[4] getRowValue];
    NSDate *duedate=[(dateCell*)self.formFields[5] getRowValue];
    BOOL private=[(checkboxCell*)self.formFields[6] getRowValue];
    BOOL urgent=[(checkboxCell*)self.formFields[7] getRowValue];
    NSMutableArray *watchersArray=[(radioSelectionCell*)self.formFields[8] getRowValue];

    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
    params[@"name"]=taskname;
    params[@"project_id"]=taskproj;
    params[@"task_list_id"]=tasklist;
    NSDateFormatter *formater=[[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd"];
    params[@"due_on"]=[formater stringFromDate:duedate];
    params[@"comments_attributes"]=@[@{@"body":taskdesc}];
    params[@"type"]=@"Task";
    params[@"watcher_ids"]=@[];
    params[@"is_private"]=@(private);
    params[@"urgent"]=@(urgent);
    params[@"created_at"]=[NSDate date];
    params[@"watcher_ids"]=watchersArray;
    
    NSLog(@"Task params: %@",params);
    
    NSString *path = [NSString stringWithFormat:@"tasks?access_token=%@",[[AFOAuthCredential retrieveCredentialWithIdentifier:@"IsaacBox"] accessToken]];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://teambox.com/api/2/"]];
        
    
    [client postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TaskUpdated" object:nil userInfo:@{@"Message":@"Task created"}];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"Error creating task"];
        NSLog(@"ERror: %@",error);
    }];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Actions
-(void)close{
    // Dismissing view controller
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Lazy instantiations
-(NSMutableArray*)formFields{
    if(!_formFields)_formFields=[[NSMutableArray alloc] init];
    return _formFields;
}
-(NSArray*)projectsArray{
    if(!_projectsArray)_projectsArray=[[NSMutableArray alloc] init];
    return _projectsArray;
}


#pragma mark - Form
-(void)initializeForm{
    // In this method we add each kind of UITableViewCell in an Array
    // TableView will load array cells like a Form
    
    //Task title
    defaultCell *taskTitleCell =[[defaultCell alloc] initWithTitle:@"Task title" andStyle:formRowStyleRow andPlaceholder:@"Task title here"];
    taskTitleCell.delegate=self;
    [self.formFields addObject:taskTitleCell];
    
    //Task detail
    defaultCell *taskDetailCell =[[defaultCell alloc] initWithTitle:@"Task detail" andStyle:formRowStyleHeader andPlaceholder:nil];
    taskDetailCell.delegate=self;
    taskDetailCell.textField.enabled=NO;
    taskDetailCell.canBecomeActive=NO;
    [self.formFields addObject:taskDetailCell];
    
    //Extensible cell for detail
    extensibleCell *taskDetailCellBody=[[extensibleCell alloc] initWithTitle:nil andStyle:formRowStyleRow andPlaceholder:@"Introduce a description for your task"];
    taskDetailCellBody.delegate=self;
    taskDetailCellBody.canBecomeActive=YES;
    [self.formFields addObject:taskDetailCellBody];
    
    //MultiChoice Cell for Project
    multiChoiceCell *projectCell=[[multiChoiceCell alloc] initWithTitle:@"Project" andStyle:formRowStyleRowBlue andPlaceholder:@"Choose project"];
    projectCell.delegate=self;
    projectCell.dataSource=self;
    [self.formFields addObject:projectCell];
    
    //MultiChoice Cell for Tasks Lists
    multiChoiceCell *tasksListsCell=[[multiChoiceCell alloc] initWithTitle:@"Tasks list" andStyle:formRowStyleRowBlue andPlaceholder:@"Choose list"];
    tasksListsCell.delegate=self;
    tasksListsCell.dataSource=self;
    [self.formFields addObject:tasksListsCell];
    
    //Due Date cell
    dateCell *dueDateCell=[[dateCell alloc] initWithTitle:@"Due date" andStyle:formRowStyleRowBlue andPlaceholder:@"Choose due date"];
    dueDateCell.delegate=self;
    [self.formFields addObject:dueDateCell];
    
    //is_private Cell
    checkboxCell *isPrivateCell=[[checkboxCell alloc] initWithTitle:@"Is your task private?" andStyle:formRowStyleRow andPlaceholder:nil];
    isPrivateCell.delegate=self;
    [self.formFields addObject:isPrivateCell];
    
    //URGENT Cell
    checkboxCell *urgentCell=[[checkboxCell alloc] initWithTitle:@"Is your task urgent?" andStyle:formRowStyleRow andPlaceholder:nil];
    urgentCell.delegate=self;
    [self.formFields addObject:urgentCell];
    
    //Watchers
    radioSelectionCell  *watchersCell=[[radioSelectionCell alloc] initWithTitle:@"Watchers" andStyle:formRowStyleHeader andPlaceholder:nil];
    watchersCell.delegate=self;
    watchersCell.textField.enabled=NO;
    watchersCell.canBecomeActive=NO;
    [self.formFields addObject:watchersCell];

    //Reloading table
    [self.tableView reloadData];
}

#pragma mark - TableView Data Source
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //Returning the number of cells in Section. We add +1 to the subrows due to de MAINCELL
    return [(defaultCell*)self.formFields[section] numberOfSubrows]+1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //Depends on the number of cells in the array
    return self.formFields.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //If indexpath.row==0 we are refereing to MAINCELL otherwise we are refering to SUBCELLS
    CGFloat rowHeight;
    if(indexPath.row==0){
        rowHeight=[(defaultCell*)self.formFields[indexPath.section] getRowSize];
    }else{
        rowHeight=[[(defaultCell*)self.formFields[indexPath.section] getSubCellAtIndex:indexPath.row-1] getRowSize];
    }
    return rowHeight;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //If indexpath.row==0 we are refereing to MAINCELL otherwise we are refering to SUBCELLS
    if(indexPath.row==0){
        return self.formFields[indexPath.section];
    }else{
        return [(defaultCell*)self.formFields[indexPath.section] getSubCellAtIndex:indexPath.row-1];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //The only cell can be selected is RADIOSELECTIONCELL
    //We call subclass method selectCell
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    defaultCell *cell=(defaultCell*)[tableView cellForRowAtIndexPath:indexPath];
    [cell selectCell];
}
#pragma mark - Form Row Data Source
//This datasource gives multiChoiceCell values to load into cell ( PickerView )

- (NSArray*)getValuesForMultiChoiceCell:(id)sender{
    //Project cell
    if([sender isEqual:self.formFields[3]]){
        return self.projectsArray;
        
    //List Cell
    }else if([sender isEqual:self.formFields[4]]){
        //Detecting if the project has been selected before
        if([self.formFields[3] SelectedItem]){
            TBProject *selectedProject=(TBProject*)[self.formFields[3] SelectedItem];
            return [selectedProject tasklists];
        }else{
            return nil;
        }
    }
    else{
        return nil;
    }
}

#pragma mark - Form Row Delegate
-(void)formRowBecameActive:(id)sender{
    defaultCell *currentCell=(defaultCell*)sender;
    
    //Scrolling tableview
    [self.tableView scrollToRowAtIndexPath:[self.tableView indexPathForCell:currentCell] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
}
-(void)formRowEndActive:(id)sender{
    //Project cell
    if([sender isEqual:self.formFields[3]]){
        //If the cell is Project Cell we reconfigure USERS cells with selected project USERS
        if([(multiChoiceCell*)self.formFields[3] SelectedItem]){
            [(radioSelectionCell*)self.formFields[8] reconfigureWithValues:[(TBProject*)[(multiChoiceCell*)self.formFields[3] SelectedItem] users]];
        }
    }
}
-(void)formRowSelectedNext:(id)sender{
    defaultCell *currentCell=(defaultCell*)sender;
    [currentCell resignActive];
    
    //Getting index
    int currentIndex=[self.formFields indexOfObject:currentCell];
    
    //Checking if there is next field
    if(currentIndex<self.formFields.count-1){
        //There are more cells
        defaultCell *nextCell=(defaultCell*)[self.formFields objectAtIndex:currentIndex+1];
        if(nextCell.canBecomeActive)
            [nextCell becomeActive];
        else
            [self formRowSelectedNext:nextCell];
    }else{
        //There is no cell
        [currentCell resignActive];
    }
}
-(void)formRowSelectedPrevious:(id)sender{
    defaultCell *currentCell=(defaultCell*)sender;
    [currentCell resignActive];

    //Getting index
    int currentIndex=[self.formFields indexOfObject:currentCell];
    
    //Checking if there is previous cell
    if(currentIndex!=0){
        //There are more cells
        defaultCell *previousCell=(defaultCell*)[self.formFields objectAtIndex:currentIndex-1];
        
        //If the previous cell can become active
        if(previousCell.canBecomeActive)
            [previousCell becomeActive];
        else
            [self formRowSelectedPrevious:previousCell];
    }else{
        //There is no cell
        [currentCell resignActive];
    }

}
-(void)formRowSelectedCancel:(id)sender{
    //Resigning current cell
    defaultCell *currentCell=(defaultCell*)sender;
    [currentCell resignActive];
}
-(void)formRowChanged:(id)sender{
    //Reloading this cell
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}
-(void)formSectionChanged:(id)sender{
    //Reloading the table
    [self.tableView reloadData];
}
#pragma mark - Keyboard Observers
- (void)keyboardWillShow:(NSNotification *)sender
{
    //Setting tableview contentInset in order to avoid the keyboard hidding form
    CGSize kbSize = [[[sender userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSTimeInterval duration = [[[sender userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, 0, kbSize.height, 0);
        [self.tableView setContentInset:edgeInsets];
        [self.tableView setScrollIndicatorInsets:edgeInsets];
    }];
}

- (void)keyboardWillHide:(NSNotification *)sender
{
    //Setting tableview contentInset in order to avoid the keyboard hidding form

    NSTimeInterval duration = [[[sender userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
        [self.tableView setContentInset:edgeInsets];
        [self.tableView setScrollIndicatorInsets:edgeInsets];
    }];
}

#pragma mark - Downloads Methods
-(void)downloadProjectsAndLists{
    //Showing HUD
    [SVProgressHUD showWithStatus:@"Loading information"];
    
     NSString *projectsURLString = [NSString stringWithFormat:@"https://teambox.com/api/2/projects?access_token=%@",[[AFOAuthCredential retrieveCredentialWithIdentifier:@"IsaacBox"] accessToken]];
    NSString *tasksListsURLString = [NSString stringWithFormat:@"https://teambox.com/api/2/task_lists?access_token=%@",[[AFOAuthCredential retrieveCredentialWithIdentifier:@"IsaacBox"] accessToken]];
    NSString *usersListsURLString = [NSString stringWithFormat:@"https://teambox.com/api/2/users?access_token=%@",[[AFOAuthCredential retrieveCredentialWithIdentifier:@"IsaacBox"] accessToken]];
    NSString *peopleListsURLString = [NSString stringWithFormat:@"https://teambox.com/api/2/people?access_token=%@",[[AFOAuthCredential retrieveCredentialWithIdentifier:@"IsaacBox"] accessToken]];

    /// Downloading projects - NSOPERATION //
    NSMutableURLRequest *projectsRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:projectsURLString]];
    [projectsRequest setHTTPMethod:@"GET"];
    AFJSONRequestOperation *operationProjects = [AFJSONRequestOperation JSONRequestOperationWithRequest:projectsRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON){
        
        //Generating TBProjects and storing in Array
        for (id project in JSON){
            //Checking if the project has not been archived
            TBProject *projectObject=[[TBProject alloc] initWithDictionary:project];
            if(!projectObject.archived)
                [self.projectsArray addObject:projectObject];
        }
        
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"%@", [error userInfo]);
        [SVProgressHUD showErrorWithStatus:@"Error downloading projects list"];
    }];
    
    /// Downloading taskLists - NSOPERATION //
    NSMutableURLRequest *taskslistsRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:tasksListsURLString]];
    [projectsRequest setHTTPMethod:@"GET"];
    AFJSONRequestOperation *operationLists = [AFJSONRequestOperation JSONRequestOperationWithRequest:taskslistsRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON){
        //Ading tasks-lists to projects
        for(TBProject *project in self.projectsArray){
            NSMutableArray *projectLists=[[NSMutableArray alloc] init];
            for(id tasksList in [JSON filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"project_id == %@",project.project_id]]){
                TBTaskList *list=[[TBTaskList alloc] initWithDictionary:tasksList];
                [projectLists addObject:list];
            }
            //Storing to project
            [project setTasklists:projectLists];
        }
        [SVProgressHUD dismiss];
        dispatch_async(dispatch_get_main_queue(), ^{
            //Initializing form
            [self initializeForm]; 
        });
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"%@", [error userInfo]);
        [SVProgressHUD showErrorWithStatus:@"Error downloading tasks lists"];
    }];
    
    /// Downloading users - NSOPERATION //
    NSMutableURLRequest *usersListRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:usersListsURLString]];
    [projectsRequest setHTTPMethod:@"GET"];
    AFJSONRequestOperation *operationUsers = [AFJSONRequestOperation JSONRequestOperationWithRequest:usersListRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON){
        self.users=JSON;
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"%@", [error userInfo]);
        [SVProgressHUD showErrorWithStatus:@"Error downloading users"];
    }];
    
    /// Downloading people - NSOPERATION //
    NSMutableURLRequest *peopleListRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:peopleListsURLString]];
    [peopleListRequest setHTTPMethod:@"GET"];
    AFJSONRequestOperation *operationPeople = [AFJSONRequestOperation JSONRequestOperationWithRequest:peopleListRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON){
        for(TBProject *project in self.projectsArray){
            NSMutableArray *projectPeople=[[NSMutableArray alloc] init];
            for(id person in [JSON filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"project_id == %@",project.project_id]]){
                //Generating user with real information
                NSArray *realUserArray=[self.users filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"id==%@",person[@"user_id"]]];
                if(realUserArray.count!=0){
                    [projectPeople addObject:[[TBUser alloc] initWithDictionary:realUserArray[0]]];
                }
            }
            //Setting users to project
            [project setUsers:projectPeople];
        }
        
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"%@", [error userInfo]);
        [SVProgressHUD showErrorWithStatus:@"Error downloading users"];
    }];
    
    
    // PROCESSING QUEQUE //
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    [operationLists addDependency:operationProjects];
    [operationLists addDependency:operationProjects];
    [operationPeople addDependency:operationUsers];
    [operationPeople addDependency:operationProjects];
    [operationQueue addOperations:@[operationProjects,operationLists,operationUsers,operationPeople] waitUntilFinished:NO];

}
@end
