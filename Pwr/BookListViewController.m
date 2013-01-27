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
#import "BookListFetcher.h"
#import "LibrariesFetcher.h"
#import "MBProgressHUD.h"
#import "LibraryCache.h"

@interface BookListViewController ()


@property (nonatomic, assign) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSArray *books;
@property (nonatomic, retain) MBProgressHUD *HUD;
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
    
    self.HUD = [[[MBProgressHUD alloc] initWithView:self.view] autorelease];
    [self.view addSubview:_HUD];
    
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
    [self searchForLibraryWithName:book];
}


- (void) searchForLibraryWithName:(Book*)book{
    [self.HUD showWhileExecuting:@selector(searchForLibraryWithNameNoThread:) onTarget:self withObject:book animated:YES];
}
- (void) searchForLibraryWithNameNoThread:(Book *)book{
    
    LibraryCache * libraryCache = [[LibraryCache alloc] init];
    
    NSMutableArray *places = [NSMutableArray array];
    NSMutableDictionary * placesFetched = [[[libraryCache getLibraries] mutableCopy] autorelease];
    @try {
        for(NSArray * placeName in [book.availablePlaces allKeys])
        {
            NSString * uniq = [placeName objectAtIndex:0];
            if([placesFetched objectForKey:uniq]==nil)
            {
                Library * lib = [LibrariesFetcher fetchLibraryForName:uniq];
                NSString * count = [book.availablePlaces objectForKey:placeName];
                lib.uniq = [placeName objectAtIndex:0];
                lib.available = [NSNumber numberWithInt:[count integerValue]];
                lib.shorttitle = [placeName objectAtIndex:1];
                [placesFetched setObject:lib forKey:uniq];
                NSLog(@"fetched new library (%@)", uniq);
            }
            [places addObject:uniq];
        }
        [libraryCache saveLibraries:placesFetched];
        [libraryCache release];
    }
    @catch (NSException *exception) {
        [_HUD hide:YES];
        [[[[UIAlertView alloc] initWithTitle:exception.name message:exception.reason delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
        return;
    }
    dispatch_sync(dispatch_get_main_queue(), ^{
        if (places) {
            LocationsViewController *locations = [[[LocationsViewController alloc] initWithPlaces:placesFetched AndTableData:places] autorelease];
            [self.navigationController pushViewController:locations animated:YES];
        }
        else{
            [[[[UIAlertView alloc] initWithTitle:@"Brak Wyników" message:@"Nie znaleziono pozycji w bibliotece" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
        }
    });
}
- (void)dealloc
{
    self.books = nil;
    self.HUD = nil;
    [super dealloc];
}
@end
