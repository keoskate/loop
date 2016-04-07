//
//  KMAViewController.m
//  connectapp
//
//  Created by Keion Anvaripour on 9/3/14.
//  Copyright (c) 2014 Keion Anvaripour. All rights reserved.
//

#import "KMAViewController.h"
#import "KMATutorialView.h"

@interface KMAViewController () <KMATutorialViewDelegate>
@property KMATutorialView *tutorialView;

@end

@implementation KMAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBarHidden = YES;
	// Do any additional setup after loading the view, typically from a nib.
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //if (![defaults objectForKey:@"intro_screen_viewed"]) {
        self.tutorialView = [[KMATutorialView alloc] initWithFrame:self.view.frame];
        
        self.tutorialView.delegate = self;
        self.tutorialView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:self.tutorialView];
    //}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - KMATutorialViewDelegate Methods

-(void)doneButtonPressed{
    
    //    Uncomment so that the IntroView does not show after the user clicks "DONE"
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@"YES"forKey:@"intro_screen_viewed"];
        [defaults synchronize];
    
    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.tutorialView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.tutorialView removeFromSuperview];
    }];
}
@end
