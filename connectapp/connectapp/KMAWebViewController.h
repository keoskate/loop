//
//  KMAWebViewController.h
//  Loop
//
//  Created by Keion Anvaripour on 3/3/15.
//  Copyright (c) 2015 Keion Anvaripour. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KMAWebViewController : UIViewController <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic)   IBOutlet UIBarButtonItem *back;
@property (weak, nonatomic)   IBOutlet UIBarButtonItem *forward;
@property (weak, nonatomic)   IBOutlet UIBarButtonItem *refresh;
@property (weak, nonatomic)   NSString *webUrl;

- (void)loadRequestFromString:(NSString*)urlString;

@end
