//
//  WebViewController.m
//  Nerdfeed
//
//  Created by Alan Sparrow on 12/31/13.
//  Copyright (c) 2013 Alan Sparrow. All rights reserved.
//

#import "WebViewController.h"
#import "RSSItem.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    NSLog(@"%f %f", [[UIScreen mainScreen] applicationFrame].size.width,
          [[UIScreen mainScreen] applicationFrame].size.height);
    UIToolbar *webToolBar = [[UIToolbar alloc]
                             initWithFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.height - 44,
                                                      [[UIScreen mainScreen] bounds].size.width, 44)];
    backBtn = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain
                                                                  target:self action:@selector(back)];
    forwardBtn = [[UIBarButtonItem alloc] initWithTitle:@"Forward" style:UIBarButtonItemStylePlain
                                                                  target:self action:@selector(forward)];
    [webToolBar setItems:[NSArray arrayWithObjects:backBtn, forwardBtn, nil] animated:YES];
    [self updateBarButton];
    

    [[self webView] addSubview:webToolBar];

}

- (void)forward
{
    [[self webView] goForward];

}

- (void)back
{
    [[self webView] goBack];

}

- (void)updateBarButton
{
    [forwardBtn setEnabled:[[self webView] canGoForward]];
    NSLog(@"Forward ? %d", [[self webView] canGoForward]);
    [backBtn setEnabled:[[self webView] canGoBack]];
    NSLog(@"Back ? %d", [[self webView] canGoBack]);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self updateBarButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    // Create an instance of UIWebView as large as the screen
    CGRect screenFrame = [[UIScreen mainScreen] applicationFrame];
    UIWebView *wv = [[UIWebView alloc] initWithFrame:screenFrame];
    
    // Tell web view to scale web content to fit within bounds
    // of webview
    [wv setScalesPageToFit:YES];
    
    [wv setDelegate:self];
    
    [self setView:wv];
}


- (UIWebView *)webView
{
    return (UIWebView *)[self view];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] ==
        UIUserInterfaceIdiomPad) {
        return YES;
    }
    
    return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}

- (void)listViewController:(ListViewController *)lvc handleObject:(id)object
{
    // Cast the passed object to RSSItem
    RSSItem *entry = object;
    
    // Make sure that we are really getting a RSSItem
    if (![entry isKindOfClass:[RSSItem class]]) {
        return;
    }
    
    // Grab the info from the item and push it into the
    // appropriate views
    NSURL *url = [NSURL URLWithString:[entry link]];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [[self webView] loadRequest:req];
    
    [[self navigationItem] setTitle:[entry title]];
}

- (void)splitViewController:(UISplitViewController *)svc
     willHideViewController:(UIViewController *)aViewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem
       forPopoverController:(UIPopoverController *)pc
{
    // If this bar button item doesn't have a title, it won't appear at all
    [barButtonItem setTitle:@"List"];
    
    // Take this bar button item and put it on the left side of our
    // nav item
    [[self navigationItem] setLeftBarButtonItem:barButtonItem];
}

- (void)splitViewController:(UISplitViewController *)svc
     willShowViewController:(UIViewController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Remove the bar button item from our navigation item
    // We'll double check that its the correct button,
    // even though we know it is
    if (barButtonItem == [[self navigationItem] leftBarButtonItem]) {
        [[self navigationItem] setLeftBarButtonItem:nil];
    }
}

@end
