//
//  TBProject.m
//  IsaacBox
//
//  Created by Pedro Piñera Buendía on 28/07/13.
//  Copyright (c) 2013 cowders. All rights reserved.
//

#import "TBProject.h"

@implementation TBProject
@synthesize archived=_archived;
@synthesize public=_public;
@synthesize created_at=_created_at;
@synthesize project_id=_project_id;
@synthesize metadata=_metadata;
@synthesize name=_name;
@synthesize organization_id=_organization_id;
@synthesize permalink=_permalink;
@synthesize publish_pages=_publish_pages;
@synthesize settings=_settings;
@synthesize tracks_time=_tracks_time;
@synthesize type=_type;
@synthesize updated_at=_updated_at;


-(id)initWithDictionary:(NSDictionary*)projDict{
    //Initializing Project Object from Dictionary
    self=[super init];
    if(self){
        if(projDict[@"archived"]&& ![projDict[@"archived"] isEqual:[NSNull null]]){
            _archived=[projDict[@"archived"] boolValue];
        }

        if(projDict[@"created_at"]&& ![projDict[@"created_at"] isEqual:[NSNull null]]){
            _created_at=projDict[@"created_at"];
        }
        if(projDict[@"id"]&& ![projDict[@"id"] isEqual:[NSNull null]]){
            _project_id=projDict[@"id"];
        }
        if(projDict[@"metadata"]&& ![projDict[@"metadata"] isEqual:[NSNull null]]){
            _metadata=projDict[@"metadata"];
        }
        if(projDict[@"name"]&& ![projDict[@"name"] isEqual:[NSNull null]]){
            _name=projDict[@"name"];
        }
        if(projDict[@"organization_id"] && ![projDict[@"organization_id"] isEqual:[NSNull null]]){
            _organization_id=projDict[@"organization_id"];
        }
        if(projDict[@"permalink"] && ![projDict[@"permalink"] isEqual:[NSNull null]]){
            _permalink=projDict[@"permalink"];
        }
        if(projDict[@"public"] && ![projDict[@"public"] isEqual:[NSNull null]]){
            _public=[projDict[@"public"] boolValue];
        }
        if(projDict[@"publish_pages"]&& ![projDict[@"publish_pages"] isEqual:[NSNull null]]){
            _publish_pages=projDict[@"publish_pages"];
        }
        if(projDict[@"settings"]&& ![projDict[@"settings"] isEqual:[NSNull null]]){
            _settings=projDict[@"settings"];
        }
        if(projDict[@"tracks_time"]&& ![projDict[@"tracks_time"] isEqual:[NSNull null]]){
            _tracks_time=projDict[@"tracks_time"];
        }
        if(projDict[@"updated_at"]&& ![projDict[@"updated_at"] isEqual:[NSNull null]]){
            _updated_at=projDict[@"updated_at"];
        }
    }
    return self;
}
-(void)setTasklists:(NSArray *)tasklists{
    _tasklists=tasklists;
}
-(void)setUsers:(NSArray *)users{
    _users=users;
}

//Getters
-(NSString*)getId{
    return self.project_id;
}
-(NSString*)getName{
    return self.name;
}
@end
