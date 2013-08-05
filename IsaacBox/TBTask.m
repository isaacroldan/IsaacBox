//
//  TBTask.m
//  IsaacBox
//
//  Created by Isaac Roldan Armengol on 29/06/13.
//  Copyright (c) 2013 cowders. All rights reserved.
//

#import "TBTask.h"

@implementation TBTask

//Custom init from dictionary
-(id)initWithDictionary:(NSDictionary *)dict{
    if (self=[super init]) {
        self.taskId = [dict objectForKey:@"id"];
        self.name = [dict objectForKey:@"name"];
        self.taskListId = [dict objectForKey:@"task_list_id"];
        self.assignedId = [dict objectForKey:@"assigned_id"];
        self.status = [dict objectForKey:@"status"];
        self.projectId = [dict objectForKey:@"project_id"];
        self.userId = [dict objectForKey:@"user_id"];
        
    }
    return self;
}


//Each task can mark itself as completed in the server.
//Use NotificationCenter to notify the rest of the app if this operation was succesful or not
//If there was some kind of error, the ViewController will receive the notification as an error and reload the data from the server.
-(void)markAsCompleted{
    NSString *stringTasks = [NSString stringWithFormat:@"https://teambox.com/api/2/tasks/%@?status=3&access_token=%@",self.taskId,[[AFOAuthCredential retrieveCredentialWithIdentifier:@"IsaacBox"] accessToken]];
    NSURL *urlTasks = [NSURL URLWithString:stringTasks];
    NSMutableURLRequest *requestTasks = [NSMutableURLRequest requestWithURL:urlTasks];
    [requestTasks setHTTPMethod:@"PUT"];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:requestTasks];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TaskUpdated" object:self userInfo:@{@"Message":@"ok"}];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TaskUpdated" object:self userInfo:@{@"Message":@"error"}];
    }];
    [operation start];
}


//Each task can delete itself in the server.
//Use NotificationCenter to notify the rest of the app if this operation was succesful or not
//If there was some kind of error, the ViewController will receive the notification as an error and reload the data from the server.
-(void)deleteTask{
    NSString *stringTasks = [NSString stringWithFormat:@"https://teambox.com/api/2/tasks/%@?access_token=%@",self.taskId,[[AFOAuthCredential retrieveCredentialWithIdentifier:@"IsaacBox"] accessToken]];
    NSURL *urlTasks = [NSURL URLWithString:stringTasks];
    NSMutableURLRequest *requestTasks = [NSMutableURLRequest requestWithURL:urlTasks];
    [requestTasks setHTTPMethod:@"DELETE"];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:requestTasks success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TaskUpdated" object:self userInfo:@{@"Message":@"ok"}];
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"%@", [error userInfo]);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TaskUpdated" object:self userInfo:@{@"Message":@"error"}];
    }];
    [operation start];
}



@end
