//
//  RootViewController.m
//  Signals
//
//  Created by Daniel Hammond on 12/5/12.
//  Copyright (c) 2012 Daniel Hammond. All rights reserved.
//

#import "RootViewController.h"
#import "SignalView.h"

@interface RootViewController () <UITextViewDelegate>

@property (nonatomic, weak) IBOutlet SignalView *signalView;
@property (nonatomic, weak) IBOutlet UITextField *textView;

@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardUpdated) name:UIKeyboardDidChangeFrameNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldUpdated) name:UITextFieldTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.textView.delegate = (id)self;
}

- (void)viewDidAppear:(BOOL)animated
{
    self.textView.text = @"Change me to watch the waveform above regenerate";
    [self.textView becomeFirstResponder];
    [self textFieldUpdated];
}

- (void)textFieldUpdated
{
    [self.signalView setText:self.textView.text];
}

- (void)keyboardUpdated
{
    [self.view updateConstraintsIfNeeded];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    [self textFieldUpdated];
    return YES;
}

@end
