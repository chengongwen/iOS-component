//
//  KxMenu.h
//  kxmenu project
//  https://github.com/kolyvan/kxmenu/
//
//  Created by Kolyvan on 17.05.13.
//

/*
 Copyright (c) 2013 Konstantin Bukreev. All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 - Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 - Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

// ARC  (-fobjc-arc / -fno-objc-arc)
#if __has_feature(objc_arc) // -fobjc-arc 使用ARC模式

    #define OBJC_RETAIN(__v)
    #define OBJC_AUTORELEASE(__v)
    #define OBJC_RELEASE(__v)
    #define OBJC_SAFERELEASE(__v) (__v = nil);
    #define OBJC_SUPERDEALLOC

#else  // -fno-objc-arc 使用非ARC模式

    #define OBJC_RETAIN(__v) ([__v retain]);
    #define OBJC_AUTORELEASE(__v) ([__v autorelease]);
    #define OBJC_RELEASE(__v) ([__v release]);
    #define OBJC_SAFERELEASE(__v) ([__v release], __v = nil);
    #define OBJC_SUPERDEALLOC [super dealloc];

#endif
//#endif

// OBJC_STRONG
#if __has_feature(objc_arc)

    #define OBJC_STRONG strong

#else

    #define OBJC_STRONG retain
#endif
//#endif

// OBJC_WEAK
#if __has_feature(objc_arc_weak)

    #define OBJC_WEAK weak

#elif __has_feature(objc_arc)

    #define OBJC_WEAK unsafe_unretained
#else

    #define OBJC_WEAK assign
#endif
//#endif

@interface KxMenuItem : NSObject

@property (readwrite, nonatomic, OBJC_STRONG) UIImage *image;
@property (readwrite, nonatomic, OBJC_STRONG) NSString *title;
@property (readwrite, nonatomic, OBJC_WEAK) id target;
@property (readwrite, nonatomic) SEL action;
@property (readwrite, nonatomic, OBJC_STRONG) UIColor *foreColor;
@property (readwrite, nonatomic) NSTextAlignment alignment;

+ (instancetype) menuItem:(NSString *) title
                    image:(UIImage *) image
                   target:(id)target
                   action:(SEL) action;

@end

@interface KxMenu : NSObject

+ (void) showMenuInView:(UIView *)view
               fromRect:(CGRect)rect
              menuItems:(NSArray *)menuItems;

+ (void) dismissMenu;

+ (UIColor *) tintColor;
+ (void) setTintColor: (UIColor *) tintColor;

+ (UIFont *) titleFont;
+ (void) setTitleFont: (UIFont *) titleFont;

@end
