//
//  Accounts.h
//  PhotoShareApp
//
//  Created by Harsh Shah on 10/23/14.
//  Copyright (c) 2014 Harsh Shah. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "Album.h"

@interface Account : NSObject
//TODO: figure out the login authentication part
@property NSString *email;
@property NSString *password;

-(BOOL) isLoggedIn;
-(void) uploadAlbum: (Album *) album;
-(void) login;
-(void) logout;

@end