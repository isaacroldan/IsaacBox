//
//  TBProject.h
//  IsaacBox
//
//  Created by Pedro Piñera Buendía on 28/07/13.
//  Copyright (c) 2013 cowders. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBProject : NSObject

@property(nonatomic) BOOL archived;
@property(nonatomic) BOOL public;
@property(nonatomic,readonly) NSDate *created_at;
@property(nonatomic,readonly) NSString *project_id;
@property(nonatomic,readonly) NSDictionary *metadata;
@property(nonatomic,readonly) NSString *name;
@property(nonatomic,readonly) NSString *organization_id;
@property(nonatomic,readonly) NSString *permalink;
@property(nonatomic,readonly) NSNumber *publish_pages;
@property(nonatomic,readonly) NSDictionary *settings;
@property(nonatomic,readonly) NSNumber *tracks_time;
@property(nonatomic,readonly) NSString *type;
@property(nonatomic,readonly) NSDate *updated_at;
@property(nonatomic,readonly) NSArray *users;
@property(nonatomic,readonly) NSArray *tasklists;

-(id)initWithDictionary:(NSDictionary*)projDict;
-(void)setTasklists:(NSArray *)tasklists;
-(void)setUsers:(NSArray *)users;

//Getters
-(NSString*)getId;
-(NSString*)getName;
@end
