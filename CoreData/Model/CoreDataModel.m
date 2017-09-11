//
//  CoreDataModel.m
//  CoreData
//
//  Created by Blaze Automation on 24/08/17.
//  Copyright © 2017 Blaze Automation. All rights reserved.
//

#import "CoreDataModel.h"

@implementation CoreDataModel

+ (void)insertLocationDataWithInfo:(id)info {
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
//    NSManagedObjectContext *deviceManageObject = [appDelegate managedObjectContext];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:kLocationDataTable inManagedObjectContext:context]];
    NSError *error1 = nil;
//    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"SELF.%@ == %@", kDeviceBOneIDKey, deviceBOneIDString];
//    [request setPredicate:predicate1];
    NSArray *results = [context executeFetchRequest:request error:&error1];
    
    if (results.count>0) {
        NSManagedObject *favoritsGrabbed = [results objectAtIndex:0];
        NSLog(@"results.count: %lu", (unsigned long)results.count);
        for (NSString *key in info) {
            
            if ([[favoritsGrabbed.entity propertiesByName] objectForKey:key]) {
                [favoritsGrabbed setValue:[info valueForKey:key] forKey:key];
            }
            else
                NSLog(@"key doesn't exists: %@", key);
        }
    }
//    else {
//        NSManagedObject *deviceSubTableManageObject = [NSEntityDescription insertNewObjectForEntityForName:kLocationDataTable inManagedObjectContext:context];
////        [deviceSubTableManageObject setValue:deviceBOneIDString forKey:kDeviceBOneIDKey];
//        for (NSString *key in subTableInfo) {
//            
//            if ([[deviceSubTableManageObject.entity propertiesByName] objectForKey:key]) {
//                [deviceSubTableManageObject setValue:[subTableInfo valueForKey:key] forKey:key];
//            }
//            else
//                NSLog(@"key doesn't exists: %@", key);
//        }
//        [deviceManageObject setValue:deviceSubTableManageObject forKey:subTableRelationship];
//    }
    
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    else {
        NSLog(@"Saved Data");
    }
}
+ (void)addItemWithItem:(NSString *)itemString
        itemDescription:(NSString *)itemDescriptionString
          purchasedDate:(NSString *)deviceNameString
               quantity:(NSString *)quantityString
                   cost:(NSString *)costString {
    
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Items" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.item == %@", itemString];
    if (predicate) {
        [fetchRequest setPredicate:predicate];
    }
    NSManagedObject *deviceManageObject = [[context executeFetchRequest:fetchRequest error:nil] lastObject];
    if (!deviceManageObject) {
        deviceManageObject = [NSEntityDescription insertNewObjectForEntityForName:@"Items" inManagedObjectContext:context];
    }
    NSNumber *number = [NSNumber numberWithFloat:[costString floatValue]];
    [deviceManageObject setValue:number forKey:kCostKey];
    [deviceManageObject setValue:itemString forKey:kItemKey];
    [deviceManageObject setValue:itemDescriptionString forKey:kItemDescriptionKey];
    [deviceManageObject setValue:[NSDate date] forKey:kPurchasedDateKey];
    NSNumber *quantityNumber = [NSNumber numberWithInt:[quantityString intValue]];
    [deviceManageObject setValue:quantityNumber forKey:kQuantityKey];
    
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    else {
        NSLog(@"Saved Data");
    }
    
}
+ (NSArray *)getAllItems {
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.%@ == %@ AND (NOT (SELF.%@ == %@)) AND (NOT (SELF.%@ IN %@)) AND (SELF.%@ IN %@)",
//                              kHubIDKey, hubIDString, kDeviceBOneIDKey, kSecurityDeviceBOneID, kCategoryIDKey, excludeCategoryIDList, kParentCategoryNameKey, includeParentCategoryNamesList];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Items" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
//    if (predicate) {
//        [fetchRequest setPredicate:predicate];
//    }
    NSArray *deviceList = [context executeFetchRequest:fetchRequest error:nil];
    
//    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:kPurchasedDateKey ascending:YES selector:@selector(caseInsensitiveCompare:)];
//    NSArray *deviceListAscendingOrder = [[deviceList filteredArrayUsingPredicate:predicate]
//                                         sortedArrayUsingDescriptors:[NSArray arrayWithObject:descriptor]];
    
    return deviceList;
}

@end
