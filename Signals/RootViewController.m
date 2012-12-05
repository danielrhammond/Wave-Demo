//
//  RootViewController.m
//  Signals
//
//  Created by Daniel Hammond on 12/5/12.
//  Copyright (c) 2012 Daniel Hammond. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@property (nonatomic, weak) IBOutlet UIView *signalView;
@property (nonatomic, weak) IBOutlet UIView *textView;

@end

@implementation RootViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
