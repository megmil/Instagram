//
//  ProfileViewController.m
//  Instagram
//
//  Created by Megan Miller on 6/27/22.
//

#import <Parse/Parse.h>
#import "ProfileViewController.h"
#import "ProfileCell.h"

@interface ProfileViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, PFSubclassing>

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
    
    // TODO: async?
    [self.user fetchIfNeeded];
    // TODO: if statement
    if (!(self.user) || [self.user isEqual:[PFUser currentUser]]) {
        self.user = [PFUser currentUser];
        [self.editProfileButton setHidden:NO];
        [self fetchUserPosts];
    } else {
        [self.editProfileButton setHidden:YES];
        [self fetchUserPosts];
    }
    
    PFFileObject *userImageData = [self.user valueForKey:@"profilePicture"];
    [userImageData getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (data) {
            UIImage *profileImage = [UIImage imageWithData:data];
            [self.profileImageView setImage:profileImage];
        }
        else {
            NSLog(@"Unable to load image.");
        }
    }];
    
    [self.usernameLabel setText:self.user.username];
}

- (void)fetchUserPosts {
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query whereKey:@"author" equalTo:self.user]; // TODO: compares pointers?
    [query orderByDescending:@"createdAt"];
    query.limit = 20;

    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage]; // TODO: remove?
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    PFFileObject *profilePictureFile = [self getPFFileFromImage:editedImage];
    [self.user setObject:profilePictureFile forKey:@"profilePicture"];
    [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        [self.profileImageView setImage:editedImage];
    }];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)editProfile:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;

    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }

    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (PFFileObject *)getPFFileFromImage:(UIImage * _Nullable)image {
 
    if (!image) {
        return nil;
    }
    
    NSData *imageData = UIImagePNGRepresentation(image);
    if (!imageData) {
        return nil;
    }
    
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}

@end
