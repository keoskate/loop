//
//  KMAEditFieldTableViewCell.h
//  Loop
//
//  Created by Keion Anvaripour on 4/22/16.
//  Copyright © 2016 Keion Anvaripour. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KMAEditFieldTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *socialImage;
@property (weak, nonatomic) IBOutlet UILabel *socialName;
@property (weak, nonatomic) IBOutlet UITextField *inputField;
- (IBAction)joinWithAPI:(id)sender;

@end
