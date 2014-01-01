//
//  WebViewController.h
//  Nerdfeed
//
//  Created by Alan Sparrow on 12/31/13.
//  Copyright (c) 2013 Alan Sparrow. All rights reserved.
//

#import <UIKit/UIKit.h>
// Must import this file as it is where ListViewControllerDelegate is declared
#import "ListViewController.h"

@interface WebViewController : UIViewController <UIWebViewDelegate, UISplitViewControllerDelegate,
ListViewControllerDelegate>

{
    UIBarButtonItem *forwardBtn;
    UIBarButtonItem *backBtn;
}

@property (nonatomic, readonly) UIWebView *webView;

@end
