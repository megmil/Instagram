//
//  ProfileCell.m
//  Instagram
//
//  Created by Megan Miller on 6/28/22.
//

#import "ProfileCell.h"

@implementation ProfileCell

- (void)refreshData {
    PFFileObject *imageData = self.post.image;
    [imageData getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (data) {
            UIImage *postImage = [UIImage imageWithData:data];
            [self.userPostImageView setImage:postImage];
        }
        else {
            NSLog(@"Unable to load image.");
        }
    }];
}

@end
