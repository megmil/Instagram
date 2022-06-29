//
//  ProfileViewController.m
//  Instagram
//
//  Created by Megan Miller on 6/27/22.
//

#import <Parse/Parse.h>
#import "ProfileViewController.h"
#import "ProfileCell.h"
#import "Post.h"

@interface ProfileViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIButton *editProfileButton;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (nonatomic, strong) NSMutableArray *userPosts;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    if (!self.user) {
        self.user = [PFUser currentUser];
    }
    
    [self loadUserData];
}

- (void)loadUserData {
    BOOL isCurrentUserProfile = [self.user isEqual:[PFUser currentUser]];
    [self.editProfileButton setHidden:!isCurrentUserProfile];
    
    PFFileObject *userImageData = [self.user valueForKey:@"profilePicture"];
    [userImageData getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (data) {
            UIImage *profileImage = [UIImage imageWithData:data];
            [self.profileImageView setImage:profileImage];
        }
    }];
    
    [self.usernameLabel setText:self.user.username];
    
    [self fetchUserPosts];
}

- (void)fetchUserPosts {
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query whereKey:@"author" equalTo:self.user];
    [query orderByDescending:@"createdAt"];
    query.limit = 20;

    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts) {
            self.userPosts = (NSMutableArray *)posts;
            [self.collectionView reloadData];
        }
    }];
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.userPosts.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ProfileCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProfileCell" forIndexPath:indexPath];
    cell.post = self.userPosts[indexPath.item];
    [cell refreshData];
    return cell;
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    PFFileObject *imageFile = [Post getPFFileFromImage:editedImage];
    [self.user setObject:imageFile forKey:@"profilePicture"];
    [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            [self.profileImageView setImage:editedImage];
        }
    }];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)editProfile:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;

    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }

    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

@end
