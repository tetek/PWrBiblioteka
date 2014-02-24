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


@property (nonatomic, unsafe_unretained) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *books;

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

    [self.navigationController setNavigationBarHidden:NO];
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
    BookCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BookCellIdentifier" forIndexPath:indexPath];
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
    [self.HUD show:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        [self searchForLibraryWithNameNoThread:book];
    });

}
- (void) searchForLibraryWithNameNoThread:(Book *)book{
    
    LibraryCache * libraryCache = [[LibraryCache alloc] init];
    
    NSMutableArray *places = [NSMutableArray array];
    NSMutableDictionary * placesFetched = [[libraryCache getLibraries] mutableCopy];
    @try {
        for(NSArray * placeName in [book.availablePlaces allKeys])
        {
            NSString * uniq = [placeName objectAtIndex:0];
            Library *lib = [placesFetched objectForKey:uniq];
            if(!lib)
            {
                lib = [LibrariesFetcher fetchLibraryForName:uniq];
                lib.uniq = [placeName objectAtIndex:0];
                
                lib.shorttitle = [placeName objectAtIndex:1];
                [placesFetched setObject:lib forKey:uniq];
                NSLog(@"fetched new library %@", lib.uniq);
            }
            NSNumber *count = [book.availablePlaces objectForKey:placeName];
            lib.available = count;
            [places addObject:uniq];
        }
        [libraryCache saveLibraries:placesFetched];
    }
    @catch (NSException *exception) {
        [self.HUD hide:YES];
        [[[UIAlertView alloc] initWithTitle:exception.name message:exception.reason delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self.HUD hide:YES];
        if (places) {
            LocationsViewController *locations = [[LocationsViewController alloc] initWithPlaces:placesFetched AndTableData:places];
            [self.navigationController pushViewController:locations animated:YES];
        }
        else{
            [[[UIAlertView alloc] initWithTitle:@"Brak Wyników" message:@"Nie znaleziono pozycji w bibliotece" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    });
}
@end
