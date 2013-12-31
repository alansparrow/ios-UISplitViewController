//
//  WebViewController.h
//  Nerdfeed
//
//  Created by Alan Sparrow on 12/31/13.
//  Copyright (c) 2013 Alan Sparrow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController <UIWebViewDelegate>

{
    UIBarButtonItem *forwardBtn;
    UIBarButtonItem *backBtn;
}

@property (nonatomic, readonly) UIWebView *webView;

@end
