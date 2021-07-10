//
//  PostCell.h
//  Instagram
//
//  Created by mac2492 on 7/6/21.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"

NS_ASSUME_NONNULL_BEGIN

@interface PostCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imagePost;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UIButton *userProfilePicButton;
@property (weak, nonatomic) IBOutlet UIButton *usernameButton;
@property (weak, nonatomic) IBOutlet UIButton *likedButton;

@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;
@property (nonatomic, strong) PFUser *user;
@property (weak, nonatomic) IBOutlet UILabel *likesCountLabel;

@end

NS_ASSUME_NONNULL_END
