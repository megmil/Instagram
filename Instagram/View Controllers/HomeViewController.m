//
//  HomeViewController.m
//  Instagram
//
//  Created by Megan Miller on 6/27/22.
//

#import "HomeViewController.h"
#import "SceneDelegate.h"
#import "LoginViewController.h"
#import "DetailsViewController.h"
#import "ProfileViewController.h"
#import "PostCell.h"
#import <Parse/Parse.h>

@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource, PostCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSMutableArray *posts;
@property (nonatomic) BOOL isLoadingMoreData;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self fetchPosts];
    self.isLoadingMoreData = NO;
    
    [self configureRefreshControl];
}

- (void)configureRefreshControl {
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
        if (posts) {
            self.posts = (NSMutableArray *)posts;
            self.isLoadingMoreData = NO;
            [self.tableView reloadData];
        }
    }];
    
    [self.refreshControl endRefreshing];
}

- (void)fetchPostsSince:(NSDate *)date {
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query whereKey:@"createdAt" lessThan:date];
    [query orderByDescending:@"createdAt"];
    query.limit = 20;

    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts) {
            [self.posts addObjectsFromArray:posts];
            self.isLoadingMoreData = NO;
            [self.tableView reloadData];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PostCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"PostCell"];
    cell.delegate = self;
    cell.post = self.posts[indexPath.row];
    [cell refreshData];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(PostCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell.post isEqual:[self.posts lastObject]] && !self.isLoadingMoreData) {
        self.isLoadingMoreData = YES;
        [self fetchPostsSince:cell.post.createdAt];
    }
}

- (void)didTapUser:(PFUser *)user {
    [self performSegueWithIdentifier:@"profileSegue" sender:user];
}

- (IBAction)logout:(id)sender {
    SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    sceneDelegate.window.rootViewController = loginViewController;
    [PFUser logOutInBackground];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqual:@"detailsSegue"]) {
        NSIndexPath *myIndexPath = [self.tableView indexPathForCell:sender];
        UINavigationController *navigationController = [segue destinationViewController];
        DetailsViewController *detailsVC = (DetailsViewController*)navigationController.topViewController;
        detailsVC.post = self.posts[myIndexPath.row];
    } else if ([segue.identifier isEqual:@"profileSegue"]) {
        UINavigationController *navigationController = [segue destinationViewController];
        ProfileViewController *profileVC = (ProfileViewController*)navigationController.topViewController;
        if ([sender isKindOfClass:[PFUser class]]) {
            profileVC.user = sender;
        } else {
            profileVC.user = [PFUser currentUser];
        }
    }
}

@end
