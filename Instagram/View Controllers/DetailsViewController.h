//
//  DetailsViewController.h
//  Instagram
//
//  Created by Megan Miller on 6/27/22.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : UIViewController

@property (nonatomic, strong) Post *post;

@end

NS_ASSUME_NONNULL_END
