//
//  OtherUserProfileViewController.m
//  Instagram
//
//  Created by mac2492 on 7/8/21.
//

#import "OtherUserProfileViewController.h"
#import "PostCollectionCell.h"

@interface OtherUserProfileViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *postsCollectionView;
@property (strong, nonatomic) PFUser *user;
@property (strong, nonatomic) NSArray *arrayOfPosts;


@end

@implementation OtherUserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.postsCollectionView.delegate = self;
    self.postsCollectionView.dataSource = self;
   
    self.user = self.post.author;
    self.usernameLabel.text = self.user.username;
    [self.user fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        self.user = (PFUser *) object;
        PFFileObject *userImageFile = self.user[@"profilePicture"];
        [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            if (!error) {
                UIImage *image = [UIImage imageWithData:imageData];
                [self.userProfileImage setImage:image];
                
            }
        }];
    }];
    
    // Do any additional setup after loading the view.
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.postsCollectionView.collectionViewLayout;
    layout.minimumLineSpacing = 3;
    layout.minimumInteritemSpacing = 3;
    
    CGFloat postsPerRow = 3;
    CGFloat itemWidth = (self.postsCollectionView.frame.size.width - layout.minimumInteritemSpacing * (postsPerRow) )/ postsPerRow;
    CGFloat itemHeight = itemWidth * 1;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    
    [self getUsersPosts];
}

//Getting User's posts
- (void) getUsersPosts{
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query includeKey:@"author"];
    [query orderByDescending:@"createdAt"];
    [query whereKey:@"author" equalTo: self.user];

    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            // do something with the array of object returned by the call
            self.arrayOfPosts = posts;
            [self.postsCollectionView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PostCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"OtherUserPostCell" forIndexPath:indexPath];
    Post *post = self.arrayOfPosts[indexPath.row];
    
    PFFileObject *userImageFile = post.image;
    [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:imageData];
            [cell.otherUserPostImage setImage:image];
        }
    }];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.arrayOfPosts.count;
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
