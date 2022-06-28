//
//  ComposeViewController.m
//  Instagram
//
//  Created by Megan Miller on 6/27/22.
//

#import "ComposeViewController.h"
#import "Post.h"

@interface ComposeViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *captionField;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)clear {
    UIImage *placeholderImage = [UIImage imageNamed:@"image_placeholder"];
    [self.imageView setImage:placeholderImage];
    [self.captionField setText:@""];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage]; // TODO: remove?
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    [self.imageView setImage:editedImage];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTapImageView:(id)sender {
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

- (IBAction)cancel:(id)sender {
    [self clear];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)share:(id)sender {
    [Post postUserImage:[self.imageView image] withCaption:[self.captionField text] withCompletion:nil];
    [self clear];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
