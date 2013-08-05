//
//  TBTaskList.h
//  IsaacBox
//
//  Created by Isaac Roldan Armengol on 29/06/13.
//  Copyright (c) 2013 cowders. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBTaskList : NSObject

@property(nonatomic,strong) NSString *taskListId;
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *projectId;
@property(nonatomic,strong) NSString *userId;
@property(nonatomic,strong) NSString *finishOn;
@property(nonatomic,strong) NSMutableArray *taskArray;
@property(nonatomic) BOOL tableViewSectionExpanded;

-(id)initWithDictionary:(NSDictionary *)dict;

//Getters
-(NSString*)getId;
-(NSString*)getName;

@end
