//
//  KMAShareCell.m
//  Loop
//
//  Created by Keion Anvaripour on 11/20/14.
//  Copyright (c) 2014 Keion Anvaripour. All rights reserved.
//

#import "KMAShareCell.h"

@implementation KMAShareCell

- (void)awakeFromNib {
    // Initialization code
    
    [_socialCheckbox addTarget:self action:@selector(checkboxSelected:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)checkboxSelected:(id)sender{
    
    if([sender isSelected]==YES) {
        [sender setSelected:NO];
        
    }else{
        [sender setSelected:YES];
        
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
