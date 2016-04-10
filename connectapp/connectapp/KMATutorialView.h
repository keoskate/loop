//
//  KMATutorialView.h
//  Loop
//
//  Created by Carolyn Lee on 4/5/16.
//  Copyright (c) 2016 Keion Anvaripour. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KMATutorialViewDelegate <NSObject>

-(void)doneButtonPressed;

@end

@interface KMATutorialView : UIView
@property id<KMATutorialViewDelegate> delegate;

@end
