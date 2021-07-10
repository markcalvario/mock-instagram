//
//  PhotoMapViewController.m
//  Instagram
//
//  Created by mac2492 on 7/6/21.
//

#import "PhotoMapViewController.h"
#import "Post.h"
#import "SceneDelegate.h"

@interface PhotoMapViewController ()
@property (weak, nonatomic) IBOutlet UIButton *imagePostButton;
@property (weak, nonatomic) IBOutlet UITextField *captionField;
@property (strong, nonatomic) UIAlertController *alert;
@property (strong, nonatomic) UIImage *imagePlaceHolder;
@end

@implementation PhotoMapViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.imagePlaceHolder = self.imagePostView.image;
    [self showPhotoAlert];
}
- (IBAction)didTapGestureToCancel:(id)sender {
   
}
-(void) exitAlert{
    [self dismissViewControllerAnimated: YES
                                 completion: nil];
}
- (void)showPhotoAlert {
    // Add code to be run periodically
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
- (IBAction)didTapSelectPhoto:(id)sender {
    [self showPhotoAlert];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    //UIImage *editedImage = info[UIImagePickerControllerEditedImage];

    // Do something with the images (based on your use case)
    [self.imagePostButton setImage:originalImage forState:UIControlStateNormal];
    
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (IBAction)didTapCancel:(id)sender {
    [self backToHomeScreen];
}
- (IBAction)didTapShare:(id)sender {
    NSString *caption = self.captionField.text;
    UIImage *image = self.imagePostButton.currentImage;
    [Post postUserImage:image withCaption:caption withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (error == nil){
            [self backToHomeScreen];
        }
        else{
            NSLog(@"Error with posting");
        }
    }];
}

-(void) backToHomeScreen{
    SceneDelegate *myDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController *tabBarController = [storyboard instantiateViewControllerWithIdentifier:@"LoginToTabBar"];
    myDelegate.window.rootViewController = tabBarController;
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
