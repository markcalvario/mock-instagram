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
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;


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
    self.usernameLabel.text = self.post.author.username;
    
    
    NSDate *date = self.post.createdAt;
    // Convert Date to String
    NSTimeInterval seconds = [[NSDate date] timeIntervalSinceDate:date];
    NSDate *timeAgoDate = [NSDate dateWithTimeIntervalSinceNow:seconds];
    self.timestampLabel.text = timeAgoDate.timeAgoSinceNow;
    
    
    
    
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
