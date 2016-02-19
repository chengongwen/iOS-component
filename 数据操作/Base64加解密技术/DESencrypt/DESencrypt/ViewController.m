//
//  ViewController.m
//  DESencrypt
//
//  Created by yuanshanit on 15/7/15.
//  Copyright (c) 2015年 guibi.td. All rights reserved.
//

#import "ViewController.h"

#import "DesEncrypt.h"
#import "GTMBase64.h"

#import "NSString+Base64.h"
#import "NSData+Base64.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *strLab;
@property (weak, nonatomic) IBOutlet UILabel *desLab;

@property (weak, nonatomic) IBOutlet UILabel *lbEnBase64;
@property (weak, nonatomic) IBOutlet UILabel *lbDeBase64;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Xcode快捷键" ofType:@"docx"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    
    NSString *documentPath =[[documentPaths objectAtIndex:0] stringByAppendingPathComponent:@"Documents"];
    [data writeToFile:documentPath atomically:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)tostr:(id)sender {
    if (![self.textField.text isEqualToString:@""]) {
        
        self.strLab.text = [DesEncrypt encryptWithText: self.textField.text];
    }
    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"Xcode快捷键" ofType:@"docx"];
//    NSData *data = [NSData dataWithContentsOfFile:path];
    
    NSArray *documentsPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask , YES);
    NSString *documentPath=[[documentsPaths objectAtIndex:0] stringByAppendingPathComponent:@"Documents"];
     NSData *data = [NSData dataWithContentsOfFile:documentPath];
    
    // Convert to Base64 data
    NSData *base64Data = [GTMBase64 encodeData:data];
    
    BOOL result = [base64Data writeToFile:documentPath atomically:YES];
    
    if (result) {
        
        NSLog(@"加密成功\n%@",documentPath);
    }
}

- (IBAction)todes:(id)sender {
    if (!([self.strLab.text isEqualToString:@""]||[self.textField.text isEqualToString:@""])) {
        
        self.desLab.text = [DesEncrypt decryptWithText:self.strLab.text];
    }
    
    NSArray *documentsPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask , YES);
    NSString *documentPath=[[documentsPaths objectAtIndex:0] stringByAppendingPathComponent:@"Documents"];
    
    NSData *base64EncodedData = [NSData dataWithContentsOfFile:documentPath];
    NSData *data = [GTMBase64 decodeData:base64EncodedData];
    
    BOOL result = [data writeToFile:documentPath atomically:YES];
    
    if (result) {
         NSLog(@"解密成功\n%@",documentPath);
    }
}

- (IBAction)EnBase64:(id)sender {
    
    if (![self.textField.text isEqualToString:@""]) {
        
        self.lbEnBase64.text = [self.textField.text base64EncodedString];
    }
}

- (IBAction)DeBase64:(id)sender {
    
    if (!([self.strLab.text isEqualToString:@""]||[self.textField.text isEqualToString:@""])) {
        
        self.lbDeBase64.text = [self.lbEnBase64.text base64DecodedString];
    }
}
@end
