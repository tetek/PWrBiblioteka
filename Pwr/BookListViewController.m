//
//  BookListViewController.m
//  Pwr
//
//  Created by Wojciech Mandrysz on 12/15/12.
//  Copyright (c) 2012 tetek. All rights reserved.
//

#import "BookListViewController.h"
#import "BookCell.h"
#import "GUIUtils.h"
#import "LocationsViewController.h"
@interface BookListViewController ()


@property (nonatomic, assign) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSArray *books;
@end

@implementation BookListViewController

- (id)initWithBooks:(NSArray*)books{
    self = [super initWithNibName:@"BookListViewController" bundle:nil];
    if (self) {
        self.books = books;
    }
    
    return self;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self.navigationController.navigationBar setBackgroundImage:[[[UIImage alloc] init] autorelease] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor colorWithRed:92./255 green:10./255 blue:13./255 alpha:1]];
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationItem.hidesBackButton = YES;
    [self.navigationItem setLeftBarButtonItem:[GUIUtils makeBackButtonforNavigationController:self.navigationController]];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Wyniki wyszukiwania";
    [_tableView registerNib:[UINib nibWithNibName:@"BookCell" bundle:nil] forCellReuseIdentifier:@"BookCellIdentifier"];
//    _tableView.backgroundColor = [UIColor clearColor];
    
}
- (int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _books.count;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BookCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BookCellIdentifier"];
    if (!cell) {
        //we are fucked
    }
    Book *book = _books[indexPath.row];
    cell.author.text = book.author;
    cell.title.text = book.title;
    cell.availability.text = [NSString stringWithFormat:@"%d",book.countAvailability];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Book *book = _books[indexPath.row];
    LocationsViewController *locations = [[[LocationsViewController alloc] initWithPlaces:book.availablePlaces] autorelease];
    [self.navigationController pushViewController:locations animated:YES];
}
- (void)dealloc
{
    self.books = nil;
    [super dealloc];
}
@end
