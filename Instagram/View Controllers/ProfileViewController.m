//
//  ProfileViewController.m
//  Instagram
//
//  Created by mac2492 on 7/7/21.
//

#import "ProfileViewController.h"
#import "Parse/Parse.h"

@interface ProfileViewController ()
@property (nonatomic, strong) PFUser *user;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImage;
@property (weak, nonatomic) IBOutlet UICollectionView *postsCollectionView;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.user = [PFUser currentUser];
    self.usernameLabel.text = self.user.username;
    // Do any additional setup after loading the view.
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
