//
//  ViewController.m
//  ZaHunter
//
//  Created by Richard Fellure on 5/29/14.
//  Copyright (c) 2014 Rich. All rights reserved.
//

#import "ViewController.h"
#import "ZaObject.h"
#import <MapKit/MapKit.h>

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *zaArray;
@property CLLocation *myLocation;
@property NSArray *sortedArray;
@property double time;
@property MKMapItem *mapItemCurrentLocation;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    self.zaArray = [[NSMutableArray alloc]init];

}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    for (CLLocation *location in locations)
    {
        if (location.verticalAccuracy < 1000 && location.horizontalAccuracy < 1000)
        {
            self.myLocation = location;
            [self findZa:location];
            [self.locationManager stopUpdatingLocation];
            break;
        }
    }

}

-(void)findZa:(CLLocation *)location
{
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc]init];
    request.naturalLanguageQuery = @"pizza";
    request.region = MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(0.4,0.4));

    MKLocalSearch *search = [[MKLocalSearch alloc]initWithRequest:request];
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error)
    {

        for (MKMapItem *mapItem in response.mapItems)
        {
            double distance = [mapItem.placemark.location distanceFromLocation:location];
            ZaObject *zaObject = [[ZaObject alloc]initWithName:mapItem.name distance:distance mapItem:mapItem];

            [self.zaArray addObject:zaObject];

        }

        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"distance" ascending:YES];
        self.sortedArray = [self.zaArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];

        ZaObject *stop1 = [self.sortedArray objectAtIndex:0];
        ZaObject *stop2 = [self.sortedArray objectAtIndex:1];
        ZaObject *stop3 = [self.sortedArray objectAtIndex:2];
        ZaObject *stop4 = [self.sortedArray objectAtIndex:3];

        [self routeHelper:[MKMapItem mapItemForCurrentLocation] to:stop1.mapItem];
        [self routeHelper:stop1.mapItem to:stop2.mapItem];
        [self routeHelper:stop2.mapItem to:stop3.mapItem];
        [self routeHelper:stop3.mapItem to:stop4.mapItem];

        NSLog(@"%f", self.time);
    }];
    

}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    ZaObject *zaItem = [self.sortedArray objectAtIndex:indexPath.row];

    cell.textLabel.text = zaItem.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Time: %f", zaItem.distance];


    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UILabel *myFooterView = [[UILabel alloc]init];
    self.tableView.tableFooterView = myFooterView;
    myFooterView.text = [NSString stringWithFormat:@"%f", self.time];
    return myFooterView;

}
-(void)routeHelper:(MKMapItem *)mapItem to: (MKMapItem *) mapItem2
{
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc]init];
    request.source = mapItem;
    request.destination = mapItem2;
    request.transportType = MKDirectionsTransportTypeWalking;
    MKDirections *directions = [[MKDirections alloc]initWithRequest:request];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error)
    {
        NSArray *routes = response.routes;
        MKRoute *route = routes.firstObject;
        self.time = (route.expectedTravelTime / 60) + 50;
        [self.tableView reloadData];





    }];



}




@end
