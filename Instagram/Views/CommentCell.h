//
//  CommentCell.h
//  Instagram
//
//  Created by Megan Miller on 6/28/22.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Comment.h"

NS_ASSUME_NONNULL_BEGIN

@interface CommentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (nonatomic, strong) Comment *comment;

- (void)refreshData;

@end

NS_ASSUME_NONNULL_END
