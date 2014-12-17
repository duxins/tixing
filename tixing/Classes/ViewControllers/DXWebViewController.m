//
//  DXWebViewController.m
//  tixing
//
//  Created by Du Xin on 10/24/14.
//  Copyright (c) 2014 Xin Du. All rights reserved.
//

#import "DXWebViewController.h"
#import <NJKWebViewProgress/NJKWebViewProgress.h>
#import <NJKWebViewProgress/NJKWebViewProgressView.h>

@interface DXWebViewController () <NJKWebViewProgressDelegate>
@property (nonatomic, strong) NJKWebViewProgress *progress;
@property (nonatomic, weak) IBOutlet NJKWebViewProgressView *progressView;
@end

@implementation DXWebViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.buildBridge = NO;
  if (self.URL) {
    DDLogDebug(@"[WEBVIEW] Started load URL: %@", self.URL);
    [self LoadURL:self.URL];
  }
  
  if (self.showProgressBar) {
    self.progress = [[NJKWebViewProgress alloc] init];
    self.webView.delegate = self.progress;
    self.progress.webViewProxyDelegate = self;
    self.progress.progressDelegate = self;
    self.progressView.hidden = NO;
  }
}

-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
  [self.progressView setProgress:progress];
}

- (void)LoadURL:(NSURL *)URL
{
  NSURLRequest *request = [NSURLRequest requestWithURL:URL];
  [self.webView loadRequest:request];
}

- (void)loadLocalFile:(NSString *)fileName
{
  NSURL *URL = [[NSBundle mainBundle] URLForResource:fileName withExtension:@""];
  [self.webView loadRequest:[NSURLRequest requestWithURL:URL]];
}

- (void)insertBridgeJS
{
  NSURL *URL = [[NSBundle mainBundle] URLForResource:@"TixingBridge" withExtension:@"js"];
  NSString *JSString = [NSString stringWithContentsOfURL:URL encoding:NSUTF8StringEncoding error:nil];
  [self.webView stringByEvaluatingJavaScriptFromString:JSString];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
  if (self.buildBridge) { [self insertBridgeJS]; }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
  if ([request.URL.scheme isEqualToString:@"tixing-action"]) {
    [self parseActionURL:request.URL];
    return NO;
  }
  return YES;
}

#pragma mark -
#pragma mark - Private methods

- (void)parseActionURL:(NSURL *)URL
{
  NSString *query = [URL.query stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  
  NSData *data = [query dataUsingEncoding:NSUTF8StringEncoding];
  NSDictionary *params = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
  NSString *methodName = URL.host;
  methodName = [URL.host stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[methodName substringToIndex:1] uppercaseString]];
  NSString *action = [NSString stringWithFormat:@"js_action%@:", methodName];
  
  DDLogDebug(@"JS Action: %@ (%@)", action, params);
  
  SEL selector = NSSelectorFromString(action);
  
  if ([self respondsToSelector:selector]) {
    IMP imp = [self methodForSelector:selector];
    void (*func)(id, SEL, id) = (void *)imp;
    func(self, selector, params);
  }
}

- (void)callJSFunction:(NSString *)functionName parameters:(id)parameters
{
  parameters = [self formatParameters:parameters];
  NSString *JSString = [NSString stringWithFormat:@"%@(%@)", functionName, parameters];
  DDLogDebug(@"Call javascript function:%@", JSString);
  [self.webView stringByEvaluatingJavaScriptFromString:JSString];
}

- (NSString *)formatParameters:(id)parameters
{
  if (!parameters) { return @""; }
  
  if ([parameters isKindOfClass:[NSString class]]) {
    parameters = [parameters stringByReplacingOccurrencesOfString:@"'" withString:@"\\\'"];
    parameters = [NSString stringWithFormat:@"'%@'", parameters];
  }else{
    NSData *data = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    parameters = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
  }
  
  return parameters;
}

@end
