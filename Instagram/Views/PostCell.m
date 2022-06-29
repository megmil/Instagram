//
//  PostCell.m
//  Instagram
//
//  Created by Megan Miller on 6/27/22.
//

#import "PostCell.h"

@interface PostCell () <UIGestureRecognizerDelegate>

@end

@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)refreshData {
    // TODO: move setup code into functions once complete
    
    [self.post.author fetchIfNeeded];
    
    UITapGestureRecognizer *tapUsername = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showProfile)];
    tapUsername.delegate = self;
    [self.usernameLabel addGestureRecognizer:tapUsername];
    
    UITapGestureRecognizer *tapUserProfile = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showProfile)];
    tapUserProfile.delegate = self;
    [self.userImageView addGestureRecognizer:tapUserProfile];
    
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
    
    PFFileObject *userImageData = [self.post.author valueForKey:@"profilePicture"];
    [userImageData getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (data) {
            UIImage *userImage = [UIImage imageWithData:data];
            [self.userImageView setImage:userImage];
        }
        else {
            NSLog(@"Unable to load image.");
        }
    }];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy HH:mm"];
    NSDate *date = self.post.createdAt;
    [self.timeLabel setText:[formatter stringFromDate:date]];
    
    [self.usernameLabel setText:self.post.author.username];
    [self.captionLabel setText:self.post.caption];
}

- (void)showProfile {
    NSLog(@"tap");
    [self.delegate didTapUser:self.post.author];
}

@end
