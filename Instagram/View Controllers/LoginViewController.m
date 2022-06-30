//
//  LoginViewController.m
//  Instagram
//
//  Created by Megan Miller on 6/27/22.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureLoginButton];
}

- (void)configureLoginButton {
    [self.loginButton setTitle:@"Log in" forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (IBAction)loginUser:(id)sender {
    if ([self isFieldEmpty]) {
        [self showAlert];
    } else {
        NSString *username = self.usernameField.text;
        NSString *password = self.passwordField.text;
        
        [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
            if (!error) {
                [self performSegueWithIdentifier:@"tabSegue" sender:self];
            }
        }];
    }
}

- (IBAction)registerUser:(id)sender {
    if ([self isFieldEmpty]) {
        [self showAlert];
    } else {
        PFUser *newUser = [PFUser user];
        newUser.username = self.usernameField.text;
        newUser.password = self.passwordField.text;
            
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
            if (!error) {
                [self performSegueWithIdentifier:@"tabSegue" sender:self];
            }
        }];
    }
}

- (IBAction)didTapScreen:(id)sender {
    [self.view endEditing:YES];
}

- (BOOL)isFieldEmpty {
    return [self.usernameField.text isEqual:@""] || [self.passwordField.text isEqual:@""];
}

- (void)showAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Missing Text Field(s)"
                                                                   message:@"Please fill in username and password."
                                                            preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok"
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:^{
        return;
    }];
}

@end
