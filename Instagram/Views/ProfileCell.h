//
//  ProfileCell.h
//  Instagram
//
//  Created by Megan Miller on 6/28/22.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProfileCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userPostImageView;

@property (nonatomic, strong) Post *post;

- (void)refreshData;

@end

NS_ASSUME_NONNULL_END
