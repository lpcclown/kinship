//
//  AppDelegate.h
//  kinship
//
//  Created by PINCHAO LIU on 4/9/17.
//  Copyright © 2017 PINCHAO LIU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

