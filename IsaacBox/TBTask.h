//
//  TBTask.h
//  IsaacBox
//
//  Created by Isaac Roldan Armengol on 29/06/13.
//  Copyright (c) 2013 cowders. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBTask : NSObject

@property (nonatomic,strong) NSString *taskId;
@property (nonatomic,strong) NSString *projectId;
@property (nonatomic,strong) NSString *taskListId;
@property (nonatomic,strong) NSString *userId;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *assignedId;
@property (nonatomic,strong) NSString *status;

-(id)initWithDictionary:(NSDictionary *)dict;
-(void)deleteTask;
-(void)markAsCompleted;
@end

