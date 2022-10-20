//
//  AppDelegate.m
//  WaterMarkRemoverDemo
//
//  Created by juliano on 2022/3/19.
//

#import "AppDelegate.h"
#import "TreshholdViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
 

    TreshholdViewController *vc = [[TreshholdViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav;
    
    [self.window makeKeyAndVisible];
    return YES;
}


#pragma mark - UISceneSession lifecycle





@end
