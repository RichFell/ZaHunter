//
//  ZaObject.m
//  ZaHunter
//
//  Created by Richard Fellure on 5/29/14.
//  Copyright (c) 2014 Rich. All rights reserved.
//

#import "ZaObject.h"

@implementation ZaObject

-(ZaObject *)initWithName:(NSString *)name distance:(double)distance mapItem:(MKMapItem *)mapItem
{
    self.name = name;
    self.distance = distance;
    self.mapItem = mapItem;
    return self;
}


@end
