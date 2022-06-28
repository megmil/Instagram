//
//  HomeViewController.m
//  Instagram
//
//  Created by Megan Miller on 6/27/22.
//

#import "HomeViewController.h"
#import "AppDelegate.h"
#import "SceneDelegate.h"
#import "LoginViewController.h"
#import "DetailsViewController.h"
#import "PostCell.h"
#import <Parse/Parse.h>

@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSMutableArray *posts;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self fetchPosts];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchPosts) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    [self.tableView addSubview:self.refreshControl];
}

- (void)fetchPosts {
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    query.limit = 20;

    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            NSLog(@"Successfully fetched posts.");
            self.posts = (NSMutableArray *)posts;
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    [self.refreshControl endRefreshing];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PostCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"PostCell"];
    cell.post = self.posts[indexPath.row];
    [cell refreshData];
    return cell;
}

- (IBAction)logout:(id)sender {
    SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    sceneDelegate.window.rootViewController = loginViewController;
    [self dismissViewControllerAnimated:YES completion:nil];
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        NSLog(@"User logged out.");
    }];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqual:@"detailsSegue"]) {
        NSIndexPath *myIndexPath = [self.tableView indexPathForCell:sender];
        UINavigationController *navigationController = [segue destinationViewController];
        DetailsViewController *detailsVC = (DetailsViewController*)navigationController.topViewController;
        detailsVC.post = self.posts[myIndexPath.row];
    }
}

@end
