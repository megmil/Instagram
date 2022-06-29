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

@end

@implementation CommentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.post.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
    cell.comment = self.post.comments[indexPath.row];
    [cell refreshData];
    return cell;
}

- (IBAction)postComment:(id)sender {
    [Comment postComment:[self.commentField text] forPost:self.post
          withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            self.commentField.text = @"";
            [self.tableView reloadData];
        }
    }];
}

@end
