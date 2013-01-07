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
@property (retain, nonatomic) IBOutlet UIImageView *circleImageView;
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
    
    self.mapImageView.frame = CGRectMake(0, 0, 780, 393);
    
    self.circleImageView.center = self.scrollView.center;
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
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;

    return cell;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *placeName = [_places allKeys][indexPath.row];
    int x = 0;
    int y = 0;
    NSLog(@"Clicked: %@ \n", placeName);
    if([placeName isEqualToString:@"BI-Fizyki"])
    {
        x = 500;
        y = 249;
    } else if([placeName isEqualToString:@"BG-Wypożyczalnia"])
    {
        x = 100;
        y = 249;
    } else if([placeName isEqualToString:@"BW-Informatyki i Zarz."])
    {
        x = 50;
        y = 149;
    } else if([placeName isEqualToString:@"BS-Kształcenia Podstawowego"])
    {
        x = 50;
        y = 149;
    } else if([placeName isEqualToString:@"BIWK-Inform.;Syst.;Elekt.Mikr."])
    {
        x = 50;
        y = 149;
    } else if([placeName isEqualToString:@"BMW-Elektroniki i Elektr.Mikr."])
    {
        x = 50;
        y = 149;
    } else {
        return;
    }
    /*
        TU TRZEBA UZUPEŁNIĆ TE BIBLIOTEKI I ICH POZYCJE NA MAPIE
     */
    
    
    [UIView animateWithDuration:2.0 animations:^{
        self.circleImageView.hidden = NO;
        self.circleImageView.frame = CGRectMake(x, y, self.circleImageView.frame.size.width, self.circleImageView.frame.size.height);
        [self scrollToShowView:self.circleImageView AtCenterInScrollView:self.scrollView];
        
    }];
}
- (void) scrollToShowView: (UIView *)view AtCenterInScrollView: (UIScrollView *)scrollView
{
    int centerScrollForIndocatorX = view.frame.origin.x - (scrollView.frame.size.width-view.frame.size.width)/2;
    int centerScrollForIndocatorY = view.frame.origin.y - (scrollView.frame.size.height-view.frame.size.height)/2;
    if(centerScrollForIndocatorX<0) { centerScrollForIndocatorX = 0; }
    if(centerScrollForIndocatorY<0) { centerScrollForIndocatorY = 0; }
    
    if(centerScrollForIndocatorX + scrollView.frame.size.width > scrollView.contentSize.width)
    {
        centerScrollForIndocatorX = scrollView.contentSize.width - scrollView.frame.size.width;
    }
    if(centerScrollForIndocatorY + scrollView.frame.size.height > scrollView.contentSize.height)
    {
        centerScrollForIndocatorY = scrollView.contentSize.height - scrollView.frame.size.height;
    }
    scrollView.contentOffset = CGPointMake(centerScrollForIndocatorX, centerScrollForIndocatorY);
    
}
- (void)dealloc
{
    self.places = nil;
    [_circleImageView release];
    [super dealloc];
}
@end
