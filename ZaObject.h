//
//  ZaObject.h
//  ZaHunter
//
//  Created by Richard Fellure on 5/29/14.
//  Copyright (c) 2014 Rich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface ZaObject : NSObject
@property NSString *name;
@property double distance;
@property MKMapItem *mapItem;

-(ZaObject *) initWithName:(NSString *)name distance:(double)distance mapItem:(MKMapItem *)mapItem;
@end
