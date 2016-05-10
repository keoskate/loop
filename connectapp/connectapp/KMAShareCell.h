//
//  KMAShareCell.h
//  Loop
//
//  Created by Keion Anvaripour on 11/20/14.
//  Copyright (c) 2014 Keion Anvaripour. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KMAShareCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *socialImage;
@property (weak, nonatomic) IBOutlet UILabel *socialName;
@property (weak, nonatomic) IBOutlet UILabel *socialData;
@property (strong, nonatomic) IBOutlet UIButton *socialCheckbox;
@property (weak, nonatomic) IBOutlet UIButton *addButton;


@end
