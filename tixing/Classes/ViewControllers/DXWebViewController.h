//
//  DXWebViewController.h
//  tixing
//
//  Created by Du Xin on 10/24/14.
//  Copyright (c) 2014 Xin Du. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DXWebViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, assign) BOOL buildBridge;
@property (nonatomic, assign) BOOL showProgressBar;
@property (nonatomic, assign, getter=isAutomaticTitleDetectionEnabled) BOOL automaticTitleDetectionEnabled;
@property (nonatomic, strong) NSURL *URL;

@property (nonatomic, weak) IBOutlet UIWebView *webView;

- (void)loadLocalFile:(NSString *)fileName;

- (void)LoadURL:(NSURL *)URL;

- (void)insertBridgeJS;

- (void)callJSFunction:(NSString *)functionName parameters:(id)parameters;
@end
