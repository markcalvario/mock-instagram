//
//  PostCell.m
//  Instagram
//
//  Created by mac2492 on 7/6/21.
//

#import "PostCell.h"
#import "Parse.h"
#import "Post.h"
#import "HomeFeedViewController.h"

@implementation PostCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.user = [PFUser currentUser];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
/*- (IBAction)didTapLike:(id)sender {
    NSLog(@"%@", sender.tag);
    
    //self.user[@"arrayOfLikedPosts"] =
}*/

@end
