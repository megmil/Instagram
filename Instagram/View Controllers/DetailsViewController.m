//
//  DetailsViewController.m
//  Instagram
//
//  Created by Megan Miller on 6/27/22.
//

#import "DetailsViewController.h"
#import "CommentsViewController.h"

@interface DetailsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *postImageView;
@property (weak, nonatomic) IBOutlet UILabel *likeLabel;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadLabels];
    [self loadImage];
}

- (void)loadLabels {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy HH:mm"];
    NSDate *date = self.post.createdAt;
    [self.timeLabel setText:[formatter stringFromDate:date]];
    
    [self.captionLabel setText:self.post.caption];

    [self refreshLikesLabel];
    [self refreshCommentsLabel];
}

- (void)loadImage {
    PFFileObject *imageData = self.post.image;
    [imageData getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (data) {
            UIImage *postImage = [UIImage imageWithData:data];
            [self.postImageView setImage:postImage];
        }
    }];
}

- (void)refreshLikesLabel {
    NSString *likeCountString = [NSString stringWithFormat:@"Liked by %@ people", self.post.likeCount];
    [self.likeLabel setText:likeCountString];
}

- (void)refreshCommentsLabel {
    NSString *commentCountString = [NSString stringWithFormat:@"View all %@ comments", self.post.commentCount];
    [self.commentLabel setText:commentCountString];
}

- (IBAction)likePost:(id)sender {
    [self.post incrementKey:@"likeCount"];
    [self.post saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            [self refreshLikesLabel];
        }
    }];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqual:@"commentsSegue"]) {
        UINavigationController *navigationController = [segue destinationViewController];
        CommentsViewController *commentsVC = (CommentsViewController*)navigationController.topViewController;
        commentsVC.post = self.post;
    }
}

@end
