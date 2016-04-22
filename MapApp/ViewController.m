//
//  ViewController.m
//  MapApp
//
//  Created by Mac on 16/3/11.
//  Copyright © 2016年 zcf. All rights reserved.
//
#define is_ios_version  [[UIDevice currentDevice].systemVersion doubleValue]
#import "ViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController () <MKMapViewDelegate>
@property (nonatomic,strong) MKMapView *mapView;
@property (nonatomic,strong) CLLocationManager *manager;
@property (weak, nonatomic) IBOutlet UITextField *cityNameTF;

@end

static CGFloat   latitudeDetal = 0.1;
static CGFloat   longitudeDetal =0.1;
static int   count;
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self createView];
}
- (void)createView {
    self.manager  = [[CLLocationManager alloc]init];
    MKMapView *mapView = [[MKMapView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    mapView.delegate = self;
    [self.view addSubview:mapView];
    [self.view sendSubviewToBack:mapView];
    if (is_ios_version>=8.0) {
        [self.manager requestWhenInUseAuthorization];
        self.manager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    mapView.userTrackingMode = MKUserTrackingModeFollow;
    self.mapView = mapView;
}
#pragma  mark -------定位按钮
- (IBAction)getCurrentLocation:(UIButton *)sender {
    CLLocationCoordinate2D center = self.mapView.userLocation.location.coordinate;
    MKCoordinateSpan span = MKCoordinateSpanMake(latitudeDetal, longitudeDetal);
    MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
    [self.mapView setRegion:region animated:YES];
}
- (IBAction)nomalBtnClick:(UIButton *)sender {
    self.mapView.mapType = MKMapTypeStandard;
}
- (IBAction)hybridBtnClick:(UIButton *)sender {
    self.mapView.mapType = MKMapTypeHybrid;
}
- (IBAction)hybridFlyoverBtnClick:(UIButton *)sender {
    self.mapView.mapType = MKMapTypeHybridFlyover;
}
- (IBAction)searchBtnClick:(UIButton *)sender {
    if (![self.cityNameTF.text isEqualToString:@""]) {
        CLGeocoder *geo = [[CLGeocoder alloc] init];
        [geo geocodeAddressString:self.cityNameTF.text completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if (!error) {
                for (CLPlacemark *mark in placemarks) {
                    NSLog(@"%@",mark.name);
                }
                CLPlacemark *mark = placemarks[0];
                double longitude = mark.location.coordinate.longitude;
                double latitude = mark.location.coordinate.latitude;
                CLLocationCoordinate2D center = CLLocationCoordinate2DMake(latitude, longitude);
                MKCoordinateSpan span = MKCoordinateSpanMake(latitudeDetal, longitudeDetal);
                MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
                [self.mapView setRegion:region animated:YES];
            }else {
                NSLog(@"%@",error);
            }
        }];
    }else {
        NSLog(@"请输入地址");
    }
}
- (IBAction)bigBtnClick:(UIButton *)sender {
    count ++;
    if (count) {
        longitudeDetal = longitudeDetal+count;
        latitudeDetal = latitudeDetal+count;
    }
}
- (IBAction)smallBtnClick:(UIButton *)sender {
    
}
#pragma mark ------共享位置
- (IBAction)shareLocationBtnClick:(UIButton *)sender {
    UIImage *image = [self cutOffImageFrom:self.view];
    
}
- (UIImage *)cutOffImageFrom:(UIView *)view {
    UIGraphicsBeginImageContext(view.frame.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
