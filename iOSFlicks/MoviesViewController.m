//
//  ViewController.m
//  iOSFlicks
//
//  Created by Santosh Ankola on 9/13/16.
//  Copyright © 2016 Santosh Ankola. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"
#import "MovieDetailViewController.h"

@interface MoviesViewController () <UITableViewDelegate, UITableViewDataSource>

@property (atomic, strong) NSArray* movies;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MoviesViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    NSString *baseMovieUrl = @"https://api.themoviedb.org/3/movie/";
    NSString *apiKey = @"?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed";
//    NSString *urlString =
  //  [@"https://api.themoviedb.org/3/movie/now_playing?api_key=" stringByAppendingString:apiKey];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@",baseMovieUrl, self.endPoint, apiKey];

    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLSession *session =
    [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                  delegate:nil
                             delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData * _Nullable data,
                                                                NSURLResponse * _Nullable response,
                                                                NSError * _Nullable error) {
                                                if (!error) {
                                                    NSError *jsonError = nil;
                                                    NSDictionary *responseDictionary =
                                                    [NSJSONSerialization JSONObjectWithData:data
                                                                                    options:kNilOptions
                                                                                      error:&jsonError];
                                                    NSLog(@"Response: %@", responseDictionary);
                                                    self.movies = responseDictionary[@"results"];
                                                } else {
                                                    NSLog(@"An error occurred: %@", error.description);
                                                }
                                                
                                                [self.tableView reloadData];
                                            }];
    [task resume];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.movies.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    NSDictionary *movie = self.movies[indexPath.row];
    
    cell.titleLabel.text = movie[@"title"];
    cell.synopsisLabel.text = movie[@"overview"];
    NSString * baseURL = @"https://image.tmdb.org/t/p/w92/";
    if(movie[@"poster_path"]){
        NSString *imageURL = [NSString stringWithFormat:@"%@%@",baseURL, movie[@"poster_path"]];
    
        [cell.posterView setImageWithURL: [NSURL URLWithString:imageURL]];
    }
    
    return cell;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSLog(@"hello");
    if([segue.identifier isEqualToString: @"detailSegue"]){
    UITableViewCell *cell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    MovieDetailViewController *vc = segue.destinationViewController;
    vc.movie = self.movies[indexPath.row];
    }
}

@end
