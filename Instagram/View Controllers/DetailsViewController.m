//
//  DetailsViewController.m
//  Instagram
//
//  Created by Megan Miller on 6/27/22.
//

#import "DetailsViewController.h"

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
    
    PFFileObject *imageData = self.post.image;
    [imageData getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (data) {
            UIImage *postImage = [UIImage imageWithData:data];
            [self.postImageView setImage:postImage];
        }
        else {
            NSLog(@"Unable to load image.");
        }
    }];

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy HH:mm"];
    NSDate *date = self.post.createdAt;
    [self.timeLabel setText:[formatter stringFromDate:date]];
    
    [self.post.author fetchIfNeeded];
    [self.usernameLabel setText:self.post.author.username];
    
    [self.captionLabel setText:self.post.caption];
}

@end