//
//  ProfileViewController.m
//  Instagram
//
//  Created by mac2492 on 7/7/21.
//

#import "ProfileViewController.h"
#import "Parse/Parse.h"
#import "PostCollectionCell.h"
#import "Post.h"
#import "PostDetailViewController.h"

@interface ProfileViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) PFUser *user;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImage;
@property (weak, nonatomic) IBOutlet UICollectionView *postsCollectionView;
@property (strong, nonatomic) NSArray *arrayOfPosts;
@property (strong, nonatomic) UIAlertController *alert;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.postsCollectionView.delegate = self;
    self.postsCollectionView.dataSource = self;
    
    /// Getting current user & setting the profile details based on the user's attributes
    self.user = [PFUser currentUser];
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
    
    self.usernameLabel.text = self.user.username;
    
    
    
    
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
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PostCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PostCollectionCell" forIndexPath:indexPath];
    
    Post *post = self.arrayOfPosts[indexPath.row];
    
    PFFileObject *userImageFile = post.image;
    [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:imageData];
            [cell.postImage setImage:image];
            
        }
    }];
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.arrayOfPosts.count;
}


//Getting User's posts
- (void) getUsersPosts{
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query includeKey:@"author"];
    [query orderByDescending:@"createdAt"];
    [query whereKey:@"author" equalTo:[PFUser currentUser]];

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
- (IBAction)didTapEditProfilePicture:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;

    self.alert = [UIAlertController alertControllerWithTitle:@"Select a photo" message:@""
                               preferredStyle:UIAlertControllerStyleActionSheet];

    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertAction *didSelectCamera = [UIAlertAction actionWithTitle:@"Camera"
                                                      style:UIAlertActionStyleDefault
                                          
                                    handler:^(UIAlertAction * _Nonnull action) {
                                           // handle cancel response here. Doing nothing will dismiss the view.
                                        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePickerVC animated:YES completion:nil];
                                        
                            }];
        [self.alert addAction:didSelectCamera];
    }
    
    
    UIAlertAction *didSelectCameraRoll = [UIAlertAction actionWithTitle:@"Camera Roll"
                                                  style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * _Nonnull action) {
                                       // handle cancel response here. Doing nothing will dismiss the view.
                                    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                    [self presentViewController:imagePickerVC animated:YES completion:nil];
        
                                }];
    [self.alert addAction:didSelectCameraRoll];
 
    [self presentViewController:self.alert animated:YES completion:^{
        // optional code for what happens after the alert controller has finished presenting
    }];
    
    
}
/// method that saves profile picture to the user
- (void) saveProfilePicture{
    UIImage *image = self.userProfileImage.image;
    self.user[@"profilePicture"] = [Post getPFFileFromImage: [self resizeImage: image withSize: CGSizeMake(300, 300)]];
    
    [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (error){
            NSLog(@"could not save image");
        }
        else{
            NSLog(@"Image saved");
        }
    }];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    //UIImage *editedImage = info[UIImagePickerControllerEditedImage];

    // Do something with the images (based on your use case)
    [self.userProfileImage setImage:originalImage];
    [self saveProfilePicture];
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if (([segue.identifier isEqualToString:@"OwnProfileToPostDetail"])) {
        
        PostCollectionCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.postsCollectionView indexPathForCell:tappedCell];
        Post *post = self.arrayOfPosts[indexPath.row];
        
        PostDetailViewController *postDetailViewController = [segue destinationViewController];
        postDetailViewController.post = post;
    }
}

@end
