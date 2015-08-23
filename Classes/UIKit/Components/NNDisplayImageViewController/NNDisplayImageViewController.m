//
//  NNDisplayImageViewController.m
//  NNLibraries
//
//  Created by Natan Abramov on 3/30/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import "NNDisplayImageViewController.h"
#import "NNAsyncImageView.h"

@interface NNDisplayImageViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet NNAsyncImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@end

@implementation NNDisplayImageViewController

- (instancetype)init {
    if(self = [super initWithNibName: NSStringFromClass([self class]) bundle: nil]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    _imageView.image = _image;
    if(_closeBtnTitle) {
        [_closeBtn setTitle: _closeBtnTitle forState: UIControlStateNormal];
    } else {
        [_closeBtn setTitle: @"Close" forState: UIControlStateNormal];
    }
    
    self.view.backgroundColor = _backgroundColor ? _backgroundColor : [UIColor whiteColor];
}

- (IBAction)close:(id)sender {
    if(self.presentingViewController) {
        [self dismissViewControllerAnimated: YES completion: nil];
    } else if(self.navigationController){
        [self.navigationController popViewControllerAnimated: YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
}

@end
