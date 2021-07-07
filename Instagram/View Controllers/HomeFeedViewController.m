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

@interface HomeFeedViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray *arrayOfPosts;
@property (weak, nonatomic) IBOutlet UITableView *postsTableView;

@end

@implementation HomeFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.postsTableView.dataSource = self;
    self.postsTableView.delegate = self;
    [self getPosts];
}
- (void) getPosts{
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];

    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            // do something with the array of object returned by the call
            self.arrayOfPosts = posts;
            NSLog(@"%@", posts);
            [self.postsTableView reloadData];
            
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
    
    PFFileObject *userImageFile = post.image;
    [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:imageData];
            [cell.imagePost setImage:image];
        }
    }];
    cell.captionLabel.text = post.caption;
    
    return cell;
    
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
