//
//  KMAWebViewController.m
//  Loop
//
//  Created by Keion Anvaripour on 3/3/15.
//  Copyright (c) 2015 Keion Anvaripour. All rights reserved.
//

#import "KMAWebViewController.h"

@interface KMAWebViewController ()

@end

@implementation KMAWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    PFUser *currentUser = [PFUser currentUser];
    NSString *testURL = [NSString stringWithFormat:@"https://www.facebook.com/app_scoped_user_id/%@", [currentUser objectForKey:@"facebookURL"]];
    
        NSString *fbURL = [NSString stringWithFormat:@"fb://profile?app_scoped_user_id=%@", [currentUser objectForKey:@"facebookURL"]];

    [self loadRequestFromString:fbURL];
    
   // [self loadRequestFromString:_webUrl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadRequestFromString:(NSString*)urlString
{
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url
                                                cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                            timeoutInterval:10.0f];
    [self.webView loadRequest:urlRequest];
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [_activityIndicator startAnimating];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_activityIndicator stopAnimating];
    _activityIndicator.hidden = TRUE;
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
