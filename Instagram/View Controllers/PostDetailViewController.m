//
//  PostDetailViewController.m
//  Instagram
//
//  Created by mac2492 on 7/7/21.
//

#import "PostDetailViewController.h"
#import "Post.h"
#import <DateTools.h>

@interface PostDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *postImageView;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UIButton *userProfilePicButton;

@property (weak, nonatomic) IBOutlet UIButton *usernameButton;


@end

@implementation PostDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    PFFileObject *userImageFile = self.post.image;
    [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:imageData];
            [self.postImageView setImage:image];
        }
    }];
    self.captionLabel.text = self.post.caption;
    [self.usernameButton setTitle:self.post.author.username forState:UIControlStateNormal];
    
    
    
    NSDate *date = self.post.createdAt;
    // Convert Date to String
    NSTimeInterval seconds = [[NSDate date] timeIntervalSinceDate:date];
    NSDate *timeAgoDate = [NSDate dateWithTimeIntervalSinceNow:seconds];
    self.timestampLabel.text = timeAgoDate.timeAgoSinceNow;
    
    if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark){
        [self.usernameButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    else{
        [self.usernameButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    }
    
    [self.post.author fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        self.post.author = (PFUser *) object;
        PFFileObject *userImageFile = self.post.author[@"profilePicture"];
        [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            if (!error) {
                UIImage *image = [UIImage imageWithData:imageData];
                NSLog(@"%@", image);
                [self.userProfilePicButton setImage:image forState:UIControlStateNormal];
                self.userProfilePicButton.layer.cornerRadius = self.userProfilePicButton.frame.size.width / 2;
                self.userProfilePicButton.clipsToBounds = YES;
                
            }
        }];
    }];
    
    
    
    
}
- (IBAction)didTapUserProfilePic:(id)sender {
    NSLog(@"%@", @"hello");
    
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
