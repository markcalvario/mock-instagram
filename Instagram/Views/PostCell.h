//
//  PostCell.h
//  Instagram
//
//  Created by mac2492 on 7/6/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PostCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imagePost;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;

@end

NS_ASSUME_NONNULL_END
