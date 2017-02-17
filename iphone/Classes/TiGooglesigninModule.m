/**
 * ti.googlesignin
 *
 * Created by Hans Knoechel
 * Copyright (c) 2017 Your Company. All rights reserved.
 */

#import "TiGooglesigninModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"
#import "TiApp.h"

@implementation TiGooglesigninModule

#pragma mark Internal

-(id)moduleGUID
{
	return @"7fa817c2-5c36-402b-a442-f2cafd41da64";
}

-(NSString*)moduleId
{
	return @"ti.googlesignin";
}

#pragma mark Lifecycle

-(void)startup
{
	[super startup];

	NSLog(@"[DEBUG] %@ loaded",self);
}

-(void)handleOpenURL:(NSNotification *)notification
{
    NSDictionary *launchOptions = [[TiApp app] launchOptions];
    NSString *urlString = [launchOptions objectForKey:@"url"];
    NSString *sourceApplication = [launchOptions objectForKey:@"source"];
    id annotation = nil;
    
    if ([TiUtils isIOS9OrGreater]) {
#ifdef __IPHONE_9_0
        annotation = [launchOptions objectForKey:UIApplicationOpenURLOptionsAnnotationKey];
#endif
    }
    
    if (urlString != nil) {
        [[GIDSignIn sharedInstance] handleURL:[NSURL URLWithString:urlString]
                            sourceApplication:sourceApplication
                                   annotation:annotation];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"TiApplicationLaunchedFromURL"
                                                  object:nil];
}

#pragma Public APIs

-(void)initialize:(id)args
{
    ENSURE_SINGLE_ARG(args, NSDictionary);
    
    id clientID = [args objectForKey:@"clientID"];
    id scopes = [args objectForKey:@"scopes"];
    id language = [args objectForKey:@"language"];
    id loginHint = [args objectForKey:@"loginHint"];
    id hostedDomain = [args objectForKey:@"hostedDomain"];
    
    ENSURE_TYPE(clientID, NSString);
    ENSURE_TYPE_OR_NIL(scopes, NSArray);
    ENSURE_TYPE_OR_NIL(language, NSString);
    ENSURE_TYPE_OR_NIL(loginHint, NSString);
    ENSURE_TYPE_OR_NIL(hostedDomain, NSString);
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleOpenURL:)
                                                 name:@"TiApplicationLaunchedFromURL" object:nil];

    
    [[GIDSignIn sharedInstance] setDelegate:self];

    [[GIDSignIn sharedInstance] setScopes:scopes];
    [[GIDSignIn sharedInstance] setClientID:clientID];
    [[GIDSignIn sharedInstance] setLanguage:language];
    [[GIDSignIn sharedInstance] setLoginHint:loginHint];
    [[GIDSignIn sharedInstance] setHostedDomain:hostedDomain];
}

-(void)signIn:(id)unused
{
    [[GIDSignIn sharedInstance] signIn];
}

-(void)signInSilently:(id)unused
{
    [[GIDSignIn sharedInstance] signInSilently];
}

-(void)signOut:(id)unused
{
    [[GIDSignIn sharedInstance] signOut];
}

-(void)disconnect:(id)unused
{
    [[GIDSignIn sharedInstance] disconnect];
}

#pragma mark Delegates

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error
{
    if ([self _hasListeners:@"login"]) {
        [self fireEvent:@"login" withObject:@{@"user": [TiGooglesigninModule dictionaryFromUser:user]}];
    }
}

- (void)signIn:(GIDSignIn *)signIn didDisconnectWithUser:(GIDGoogleUser *)user withError:(NSError *)error
{
    if ([self _hasListeners:@"logout"]) {
        [self fireEvent:@"logout" withObject:@{@"user": [TiGooglesigninModule dictionaryFromUser:user]}];
    }
}

- (void)signIn:(GIDSignIn *)signIn presentViewController:(UIViewController *)viewController
{
    if ([self _hasListeners:@"open"]) {
        [self fireEvent:@"open"];
    }
}

- (void)signIn:(GIDSignIn *)signIn dismissViewController:(UIViewController *)viewController
{
    if ([self _hasListeners:@"close"]) {
        [self fireEvent:@"close"];
    }
}


- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error
{
    if ([self _hasListeners:@"load"]) {
        [self fireEvent:@"load"];
    }
}

#pragma mark Utilities

+ (NSDictionary *)dictionaryFromUser:(GIDGoogleUser *)user
{
    return @{
        @"id": user.userID,
        @"scopes": user.accessibleScopes,
        @"serverAuthCode": user.serverAuthCode,
        @"hostedDomain": user.hostedDomain,
        @"profile": @{
            @"name": user.profile.name,
            @"givenName": user.profile.givenName,
            @"familyName": user.profile.familyName,
            @"email": user.profile.email,
            @"hasImage": NUMBOOL(user.profile.hasImage),
        },
        @"authentication": @{
            @"clientID": user.authentication.clientID,
            @"accessToken": user.authentication.accessToken,
            @"clientID": user.authentication.clientID,
            @"accessTokenExpirationDate": user.authentication.accessTokenExpirationDate,
            @"refreshToken": user.authentication.refreshToken,
            @"idToken": user.authentication.idToken,
            @"idTokenExpirationDate": user.authentication.idTokenExpirationDate,
        }
    };
}

@end