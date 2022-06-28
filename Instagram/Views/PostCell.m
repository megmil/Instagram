//
//  PostCell.m
//  Instagram
//
//  Created by Megan Miller on 6/27/22.
//

#import "PostCell.h"

@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)refreshData {
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
    [formatter setDateFormat:@"MM/dd/yyyy HH:mm"];
    NSDate *date = self.post.createdAt;
    [self.timeLabel setText:[formatter stringFromDate:date]];
    
    [self.captionLabel setText:self.post.caption];
}

@end
