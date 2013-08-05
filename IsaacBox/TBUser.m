//
//  TBUser.m
//  IsaacBox
//
//  Created by Pedro Piñera Buendía on 28/07/13.
//  Copyright (c) 2013 cowders. All rights reserved.
//

#import "TBUser.h"

@implementation TBUser
@synthesize username=_username;
@synthesize update_at=_update_at;
@synthesize needs_profile=_needs_profile;
@synthesize micro_avatar_url=_micro_avatar_url;
@synthesize metadata=_metadata;
@synthesize last_name=_last_name;
@synthesize user_id=_user_id;
@synthesize first_name=_first_name;
@synthesize email=_email;
@synthesize deleted=_deleted;
@synthesize created_at=_created_at;
@synthesize avatar_url=_avatar_url;

-(id)initWithDictionary:(NSDictionary*)userDict{
    self=[super init];
    if(self){
        if(userDict[@"username"]&& ![userDict[@"username"] isEqual:[NSNull null]]){
            _username=userDict[@"username"];
        }
        if(userDict[@"update_at"]&& ![userDict[@"update_at"] isEqual:[NSNull null]]){
            _update_at=userDict[@"update_at"];
        }
        if(userDict[@"needs_profile"]&& ![userDict[@"needs_profile"] isEqual:[NSNull null]]){
            _needs_profile=[userDict[@"needs_profile"] boolValue];
        }
        if(userDict[@"micro_avatar_url"]&& ![userDict[@"micro_avatar_url"] isEqual:[NSNull null]]){
            _micro_avatar_url=userDict[@"micro_avatar_url"];
        }
        if(userDict[@"metadata"]&& ![userDict[@"metadata"] isEqual:[NSNull null]]){
            _metadata=userDict[@"metadata"];
        }
        if(userDict[@"last_name"]&& ![userDict[@"last_name"] isEqual:[NSNull null]]){
            _last_name=userDict[@"last_name"];
        }
        if(userDict[@"id"]&& ![userDict[@"id"] isEqual:[NSNull null]]){
            _user_id=userDict[@"id"];
        }
        if(userDict[@"first_name"]&& ![userDict[@"first_name"] isEqual:[NSNull null]]){
            _first_name=userDict[@"first_name"];
        }
        if(userDict[@"email"]&& ![userDict[@"email"] isEqual:[NSNull null]]){
            _email=userDict[@"email"];
        }
        if(userDict[@"deleted"]&& ![userDict[@"deleted"] isEqual:[NSNull null]]){
            _deleted=[userDict[@"deleted"] boolValue];
        }
        if(userDict[@"created_at"]&& ![userDict[@"created_at"] isEqual:[NSNull null]]){
            _created_at=userDict[@"created_at"];
        }
        if(userDict[@"avatar_url"]&& ![userDict[@"avatar_url"] isEqual:[NSNull null]]){
            _avatar_url=userDict[@"avatar_url"];
        }
    }
    return self;
}

//Getters
-(NSString*)getId{
    return self.user_id;
}
-(NSString*)getName{
    return [NSString stringWithFormat:@"%@ %@",self.first_name,self.last_name];
}
-(NSString*)getImageURL{
    return self.micro_avatar_url;
}
@end
