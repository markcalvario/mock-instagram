//
//  LoginViewController.m
//  Instagram
//
//  Created by mac2492 on 7/6/21.
//

#import "LoginViewController.h"
#import "Parse/Parse.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordLabel;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)didTapExitKeyboard:(id)sender {
    [self.view endEditing:true];
}
- (IBAction)didTapLogin:(id)sender {
    NSString *username = self.usernameLabel.text;
    NSString *password = self.passwordLabel.text;
        
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error){
        if (error!= nil){
            NSLog(@"User log in failed: %@", error.localizedDescription);
        }else{
            NSLog(@"User logged in successfully");
            // display view controller that needs to shown after successful login
            [self performSegueWithIdentifier:@"LoginToFeedSegue" sender:nil];
        }
    }];
}
- (IBAction)didTapSignUp:(id)sender {
    // initialize a user object
    PFUser *newUser = [PFUser user];
    
    // set user properties
    newUser.username = self.usernameLabel.text;
    newUser.password = self.passwordLabel.text;
    
    // call sign up function on the object
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            NSLog(@"User registered successfully");
            [self performSegueWithIdentifier:@"LoginToFeedSegue" sender:nil];
            
            // manually segue to logged in view
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
