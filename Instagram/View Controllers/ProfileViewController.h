//
//  ProfileViewController.h
//  Instagram
//
//  Created by Megan Miller on 6/27/22.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProfileViewController : UIViewController

@property (nonatomic, strong) PFUser *user;

@end

NS_ASSUME_NONNULL_END
