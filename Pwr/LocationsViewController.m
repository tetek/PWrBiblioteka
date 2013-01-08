//
//  LocationsViewController.m
//  Pwr
//
//  Created by Wojciech Mandrysz on 12/15/12.
//  Copyright (c) 2012 tetek. All rights reserved.
//

#import "LocationsViewController.h"
#import "LocationCell.h"
#import "GUIUtils.h"
@interface LocationsViewController ()

@property (nonatomic, assign) IBOutlet UIScrollView *scrollView;
@property (nonatomic, assign) IBOutlet UIImageView *mapImageView;
@property (nonatomic, assign) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSDictionary *places;
@end

@implementation LocationsViewController

- (id) initWithPlaces:(NSDictionary*)dict{
    self = [super initWithNibName:@"LocationsViewController" bundle:nil];
    if (self) {
        self.places = dict;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_tableView registerNib:[UINib nibWithNibName:@"LocationCell" bundle:nil] forCellReuseIdentifier:@"LocationCell"];
    self.title = @"Znaleziono w";
    
//    UIPanGestureRecognizer *recognizer = [[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(showMap:)] autorelease];
//    [_mapImageView addGestureRecognizer:recognizer];
//    _mapImageView.userInteractionEnabled = YES;

    _scrollView.contentSize = CGSizeMake(_mapImageView.image.size.width *0.5, _mapImageView.image.size.height *0.5);
    _scrollView.contentOffset = CGPointMake(150, 100);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.hidesBackButton = YES;
    [self.navigationItem setLeftBarButtonItem:[GUIUtils makeBackButtonforNavigationController:self.navigationController]];
}
- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_places allKeys].count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 71;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LocationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LocationCell"];
    if (!cell) {
        //we are fucked
    }
    NSString *placeName = [_places allKeys][indexPath.row];
    cell.placeName.text = [NSString stringWithFormat:@"w %@",placeName];
    cell.placeName.textColor = [UIColor blackColor];
    NSNumber *number = [_places objectForKey:placeName];
    cell.availability.text = [NSString stringWithFormat:@"%d",number.intValue];
    cell.ending.text = number.intValue > 1 ? @"sztuki" : number.intValue == 1 ? @"sztuka" : @"sztuk";
    cell.accessoryType = UITableViewCellAccessoryNone;

    return cell;
}
- (void)dealloc
{
    self.places = nil;
    [super dealloc];
}
@end
