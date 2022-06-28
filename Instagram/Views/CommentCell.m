//
//  CommentCell.m
//  Instagram
//
//  Created by Megan Miller on 6/28/22.
//

#import "CommentCell.h"
#import <Parse/Parse.h>

@implementation CommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)refreshData {
    [self.comment fetchIfNeeded];
    [self.commentLabel setText:self.comment.text];
}

@end
