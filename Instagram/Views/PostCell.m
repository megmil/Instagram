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
    [self configureTapRecognizers];
    [self loadImages];
    [self loadLabels];
}

- (void)configureTapRecognizers {
    UITapGestureRecognizer *tapUsername = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(showProfile)];
    UITapGestureRecognizer *tapUserProfile = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(showProfile)];
    
    tapUsername.delegate = self;
    tapUserProfile.delegate = self;
    
    [self.usernameLabel addGestureRecognizer:tapUsername];
    [self.userImageView addGestureRecognizer:tapUserProfile];
}

- (void)loadImages {
    PFFileObject *imageData = self.post.image;
    [imageData getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (data) {
            UIImage *postImage = [UIImage imageWithData:data];
            [self.postImageView setImage:postImage];
        }
    }];
    
    PFFileObject *userImageData = [self.post.author valueForKey:@"profilePicture"];
    [userImageData getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (data) {
            UIImage *userImage = [UIImage imageWithData:data];
            [self.userImageView setImage:userImage];
        }
    }];
}

- (void)loadLabels {
    [self.usernameLabel setText:self.post.author.username];
    [self.captionLabel setText:self.post.caption];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy HH:mm"];
    NSDate *date = self.post.createdAt;
    [self.timeLabel setText:[formatter stringFromDate:date]];
}

- (void)showProfile {
    [self.delegate didTapUser:self.post.author];
}

@end
