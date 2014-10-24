//
//  Profile.h
//  PhotoShareApp
//
//  Created by Harsh Shah on 10/24/14.
//  Copyright (c) 2014 Harsh Shah. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Accounts.h"
#import "Album.h"

@interface Profile : NSObject
//TODO: figure out how to create have multiple profiles (ie profile array) maybe different class
@property NSArray *accounts;
@property NSString *name;

-(void) addAccounts: (Accounts *) accounts;
-(void) uploadAlbum: (Album *) album;

@end
