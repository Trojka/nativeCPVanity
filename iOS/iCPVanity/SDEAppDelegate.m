//
//  SDEAppDelegate.m
//  iCPVanity
//
//  Created by serge desmedt on 25/01/14.
//  Copyright (c) 2014 serge desmedt. All rights reserved.
//

#import "SDEAppDelegate.h"
#import "SDECodeProjectWeb.h"

@implementation SDEAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    
    // use Bob as header for the Navigationbar
    
    SDECodeProjectWeb* cpWeb = [[SDECodeProjectWeb alloc]init];
    UIImage* bob = NULL;
    [cpWeb fillLogo:&bob delegate:NULL];
    
    if(bob != NULL)
    {
        static int deviceWidth = 320;
        static int navigationHeight = 44;
        static int statusHeight = 20;
        static int headerHeight= 64;
        
        float scale = bob.size.height / navigationHeight;
        int scaledDeviceWidth = deviceWidth * scale;
        int scaledNavigationHeight = navigationHeight * scale;
        int scaledStatusHeight = statusHeight * scale;
        UIGraphicsBeginImageContext(CGSizeMake(scaledDeviceWidth, scaledStatusHeight+scaledNavigationHeight));
        
        UIColor* color = NULL;
        UIColor* fillColor = NULL;
        CGFloat red, green, blue, alpha;
        // find upper border
        int upperBorderHeight = 0;
        color = [SDEAppDelegate getRGBAsFromImage:bob atX:0 andY:upperBorderHeight];
        [color getRed:&red green:&green blue:&blue alpha:&alpha];
        while ((red == 1.0 && green == 1.0 && blue == 1.0)
               && (upperBorderHeight < bob.size.height))
        {
            upperBorderHeight++;
            color = [SDEAppDelegate getRGBAsFromImage:bob atX:0 andY:upperBorderHeight];
            [color getRed:&red green:&green blue:&blue alpha:&alpha];
        }
        fillColor = color;
        
        // find lower border
        int lowerBorderHeight = bob.size.height - 1;
        color = [SDEAppDelegate getRGBAsFromImage:bob atX:0 andY:lowerBorderHeight];
        [color getRed:&red green:&green blue:&blue alpha:&alpha];
        while ((red == 1.0 && green == 1.0 && blue == 1.0)
               && (lowerBorderHeight >= 0))
        {
            lowerBorderHeight--;
            color = [SDEAppDelegate getRGBAsFromImage:bob atX:0 andY:lowerBorderHeight];
            [color getRed:&red green:&green blue:&blue alpha:&alpha];
        }
        
        [fillColor set];
        CGRect rectBackground = CGRectMake(0,
                                           scaledStatusHeight + upperBorderHeight,
                                           scaledDeviceWidth,
                                           lowerBorderHeight - upperBorderHeight);
        UIRectFill(rectBackground);

        int offsetBob = (scaledDeviceWidth - bob.size.width)/2;
        CGRect rectBob = CGRectMake(offsetBob, scaledStatusHeight, bob.size.width, bob.size.height);
    
        [bob drawInRect:rectBob];
        UIImage *modifiedBob = UIGraphicsGetImageFromCurrentImageContext();
        
        if(modifiedBob != NULL)
        {
            bob = modifiedBob;
        }
    
        UIGraphicsEndImageContext();
        
        UIGraphicsBeginImageContext(CGSizeMake(deviceWidth, headerHeight));
        
        [bob drawInRect:CGRectMake(0, 0, deviceWidth, headerHeight)];
        UIImage *headerBob = UIGraphicsGetImageFromCurrentImageContext();
        
        if(headerBob != NULL)
        {
            bob = headerBob;
        }
        
        UIGraphicsEndImageContext();

    }
    else
    {
        bob = [UIImage imageNamed:@"cplogo.png"];
    }
    
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];    
    [[UINavigationBar appearance] setBackgroundImage:bob
                                       forBarMetrics:UIBarMetricsDefault];
    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                                           [UIFont fontWithName:@"System" size:21.0], NSFontAttributeName, nil]];
    
    return YES;
}

// http://stackoverflow.com/questions/448125/how-to-get-pixel-data-from-a-uiimage-cocoa-touch-or-cgimage-core-graphics
+ (UIColor*)getRGBAsFromImage:(UIImage*)image atX:(int)x andY:(int)y //count:(int)count
{
    //NSMutableArray *result = [NSMutableArray arrayWithCapacity:count];
    
    // First get the image into your data buffer
    CGImageRef imageRef = [image CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = (unsigned char*) calloc(height * width * 4, sizeof(unsigned char));
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    // Now your rawData contains the image data in the RGBA8888 pixel format.
    NSUInteger byteIndex = (bytesPerRow * y) + x * bytesPerPixel;
//    for (int i = 0 ; i < count ; ++i)
//    {
        CGFloat red   = (rawData[byteIndex]     * 1.0) / 255.0;
        CGFloat green = (rawData[byteIndex + 1] * 1.0) / 255.0;
        CGFloat blue  = (rawData[byteIndex + 2] * 1.0) / 255.0;
        CGFloat alpha = (rawData[byteIndex + 3] * 1.0) / 255.0;
//        byteIndex += bytesPerPixel;
        
        UIColor *acolor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    
        //NSLog(@"getRGBAsFromImage[x:%d][y:%d] Red:%1.2f, Green:%1.2f, Blue:%1.2f", x, y, red, green, blue);
    
        //[result addObject:acolor];
//    }
    
    free(rawData);
    
    return acolor;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self saveContext];
}


- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"SDECodeProjectMemberStore" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"SDECodeProjectMemberStore.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
