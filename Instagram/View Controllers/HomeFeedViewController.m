//
//  HomeFeedViewController.m
//  Instagram
//
//  Created by mac2492 on 7/6/21.
//

#import "HomeFeedViewController.h"
#import "Parse/Parse.h"
#import "SceneDelegate.h"
#import "PostCell.h"
#import "Post.h"
#import "PostDetailViewController.h"
#import "OtherUserProfileViewController.h"
#import <DateTools.h>


@interface HomeFeedViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray *arrayOfPosts;
@property (weak, nonatomic) IBOutlet UITableView *postsTableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;



@end

@implementation HomeFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.postsTableView.dataSource = self;
    self.postsTableView.delegate = self;
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(getPosts) forControlEvents:UIControlEventValueChanged];
    [self.postsTableView insertSubview:self.refreshControl atIndex:0];


    [self getPosts];
}

- (void) viewWillAppear:(BOOL)animated{
    [self getPosts];
}


/// Gets latest 20 posts sent to Instagram
- (void) getPosts{
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    query.limit = 20;

    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            // do something with the array of object returned by the call
            self.arrayOfPosts = posts;
            [self.postsTableView reloadData];
            [self.refreshControl endRefreshing];
            
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    
}
- (IBAction)didTapLogOut:(id)sender {
    SceneDelegate *myDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    myDelegate.window.rootViewController = loginViewController;
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayOfPosts.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell"];
    
    Post *post = self.arrayOfPosts[indexPath.row];
    
    //cell.author.usernameLabel = post.author.username;
    PFFileObject *userImageFile = post.image;
    [cell.usernameButton setTitle: post.author.username forState:UIControlStateNormal];
    if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark){
        [cell.usernameButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    else{
        [cell.usernameButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    }
    cell.usernameButton.tag = indexPath.row;
    [cell.usernameButton addTarget: self action:@selector(goToProfile:) forControlEvents:UIControlEventTouchUpInside];
    
    [post.author fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        post.author = (PFUser *) object;
        PFFileObject *userImageFile = post.author[@"profilePicture"];
        [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            if (!error) {
                UIImage *image = [UIImage imageWithData:imageData];
                [cell.userProfilePicButton setImage:image forState:UIControlStateNormal];
                cell.userProfilePicButton.layer.cornerRadius = cell.userProfilePicButton.frame.size.width / 2;
                cell.userProfilePicButton.clipsToBounds = YES;
                
            }
        }];
    }];
    cell.userProfilePicButton.tag = indexPath.row;
    [cell.userProfilePicButton addTarget:self action:@selector(goToProfile:) forControlEvents:UIControlEventTouchUpInside];
    
    
    cell.likedButton.tag = indexPath.row;
    [cell.likedButton addTarget:self action:@selector(didTapLikeIcon:) forControlEvents:UIControlEventTouchUpInside];

    
    
    [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:imageData];
            [cell.imagePost setImage:image];
        }
    }];
    cell.captionLabel.text = post.caption;
    
    NSDate *date = post.createdAt;
    // Convert Date to String
    NSTimeInterval seconds = [[NSDate date] timeIntervalSinceDate:date];
    NSDate *timeAgoDate = [NSDate dateWithTimeIntervalSinceNow:seconds];
    cell.createdAtLabel.text = timeAgoDate.timeAgoSinceNow;
    
    
    NSString *likesCountString = [post.likeCount stringValue];
    NSString *likesLabelText = [likesCountString stringByAppendingString:@" likes"];
    cell.likesCountLabel.text = likesLabelText;
    
    //if ([cell.likedButton currentImage])
    UIImage *currentLikeIcon = [cell.likedButton currentImage];
    
    //NSLog(@"%@", [currentLikeIcon imageWithData]);
    return cell;
    
}


-(void) goToProfile:(UIButton*)sender {
    Post *post = self.arrayOfPosts[sender.tag];
    [self performSegueWithIdentifier:@"HomeToOtherUser" sender:post];
}
///When user hits like
-(void) didTapLikeIcon:(UIButton*)sender {
    Post *post = self.arrayOfPosts[sender.tag];
    PFUser *currentUser = [PFUser currentUser];
    
    NSSet *setOfLikedPosts =  currentUser[@"setOfLikedPosts"];
    
    if (![setOfLikedPosts containsObject:post]){
        [self updateLikesAmount:TRUE postToUpdate:post];
        [currentUser addUniqueObject:post forKey:@"setOfLikedPosts"];
    }
    else{
        [self updateLikesAmount:FALSE postToUpdate:post];
        [currentUser removeObject:post forKey:@"setOfLikedPosts"];
    }
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (error){
            NSLog(@"could not save image");
        }
        else{
            NSLog(@"Image saved");
        }
    }];
    
}


-(void) updateLikesAmount: (BOOL) isCountIncreasing postToUpdate: (Post *)post{
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    NSString *id = post.objectId;
    [query getObjectInBackgroundWithId: id
                                 block:^(PFObject *postObject, NSError *error) {
        if (isCountIncreasing){
            [postObject incrementKey:@"likeCount" byAmount:@(1)];
        }
        else{
            [postObject incrementKey:@"likeCount" byAmount:@-1];
        }
        [postObject saveInBackground];
    }];

}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

    
    if (([segue.identifier isEqualToString:@"HomeToDetailPage"])) {
        PostCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.postsTableView indexPathForCell:tappedCell];
        Post *post = self.arrayOfPosts[indexPath.row];
        PostDetailViewController *postDetailViewController = [segue destinationViewController];
        postDetailViewController.post = post;
    }
    else if([segue.identifier isEqualToString:@"HomeToOtherUser"]){
        OtherUserProfileViewController *otherUserProfileViewController = [segue destinationViewController];
        otherUserProfileViewController.post = sender;
    }
    
    
}


@end
