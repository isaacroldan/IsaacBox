//
//  TBUser.h
//  IsaacBox
//
//  Created by Pedro Piñera Buendía on 28/07/13.
//  Copyright (c) 2013 cowders. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBUser : NSObject

@property(nonatomic,readonly) NSString *username;
@property(nonatomic,readonly) NSDate *update_at;
@property(nonatomic,readonly) BOOL needs_profile;
@property(nonatomic,readonly) NSString *micro_avatar_url;
@property(nonatomic,readonly) NSDictionary *metadata;
@property(nonatomic,readonly) NSString *last_name;
@property(nonatomic,readonly) NSString *user_id;
@property(nonatomic,readonly) NSString *first_name;
@property (nonatomic,readonly) NSString *email;
@property (nonatomic,readonly) BOOL deleted;
@property (nonatomic,readonly) NSDate *created_at;
@property (nonatomic,readonly) NSString *avatar_url;

-(id)initWithDictionary:(NSDictionary*)userDict;

//Getters
-(NSString*)getId;
-(NSString*)getName;
-(NSString*)getImageURL;
@end
