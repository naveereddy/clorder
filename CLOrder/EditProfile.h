//
//  EditProfile.h
//  CLOrder
//
//  Created by Naveen Thukkani on 25/06/18.
//  Copyright © 2018 Vegunta's. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditProfile : UIViewController<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>{
    IBOutlet UITextField *emailtext;
    IBOutlet UITextField *usernametext;
    IBOutlet UIButton *saveButton;
    IBOutlet UIImageView *profileImage;
}
-(IBAction)saveAction: (id)sender;

@end
