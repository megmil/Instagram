//
//  CommentsViewController.m
//  Instagram
//
//  Created by Megan Miller on 6/28/22.
//

#import "CommentsViewController.h"
#import "CommentCell.h"

@interface CommentsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *commentField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *comments;

@end

@implementation CommentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self fetchComments];
}

- (void)fetchComments {
    self.comments = self.post.comments;
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
    cell.comment = self.comments[indexPath.row];
    [cell refreshData];
    return cell;
}

- (IBAction)postComment:(id)sender {
    [Comment postComment:[self.commentField text] forPost:self.post // TODO: change get text
          withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            self.commentField.text = @"";
            self.comments = self.post.comments;
            [self.tableView reloadData];
        } else {
            NSLog(@"Error posting comment");
        }
    }];
}

@end
