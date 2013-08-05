//
//  TBTaskList.m
//  IsaacBox
//
//  Created by Isaac Roldan Armengol on 29/06/13.
//  Copyright (c) 2013 cowders. All rights reserved.
//

#import "TBTaskList.h"

@implementation TBTaskList

//Custom init with dictionary
-(id)initWithDictionary:(NSDictionary *)dict{
    if (self=[super init]) {
        self.name = [dict objectForKey:@"name"];
        self.taskListId = [dict objectForKey:@"id"];
        self.projectId = [dict objectForKey:@"project_id"];
        self.userId = [dict objectForKey:@"user_id"];
        self.finishOn = [dict objectForKey:@"finish_on"];
    }
    return self;
}


//LazyInstantation
-(NSMutableArray *)taskArray{
    if (!_taskArray) {
        _taskArray = [[NSMutableArray alloc] init];
    }
    return _taskArray;
}
//Getters
-(NSString*)getId{
    return self.taskListId;
}
-(NSString*)getName{
    return self.name;
}

@end
