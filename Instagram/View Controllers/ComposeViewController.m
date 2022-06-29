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
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self hideProgress];
}

- (void)clear {
    UIImage *placeholderImage = [UIImage imageNamed:@"image_placeholder"];
    [self.imageView setImage:placeholderImage];
    [self.captionField setText:@""];
    [self hideProgress];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTapImageView:(id)sender {
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

- (IBAction)cancel:(id)sender {
    [self clear];
}

- (IBAction)share:(id)sender {
    [self startProgress];
    
    [Post postUserImage:[self.imageView image] withCaption:[self.captionField text] withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            [self endProgress];
        } else {
            [self clear];
        }
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    [self.imageView setImage:editedImage];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)hideProgress {
    [self.progressView setHidden:YES];
    [self.progressLabel setHidden:YES];
}

- (void)startProgress {
    [self.progressView setHidden:NO];
    [self.progressLabel setHidden:NO];
    [self animateProgressBarWithDuration:1.7];
}

- (void)endProgress {
    [self.progressView setProgress:1 animated:YES];
    [self.progressLabel setHidden:YES];
    [self performSelector:@selector(clear) withObject:self afterDelay:0.7];
}

- (void)animateProgressBarWithDuration:(CGFloat)duration {
    [self.progressView setProgress:0.0];
    [UIView animateWithDuration:duration animations:^{
        [self.progressView setProgress:0.7 animated:YES];
    }];
}

@end
