//
//  IDCardRectManager.h
//  JYBDAVCapture
//
//  Created by tianxiuping on 2018/6/27.

#import <UIKit/UIKit.h>

@interface IDCardRectManager : UIView

@property (nonatomic, assign)CGRect subRect;

+ (CGRect)getEffectImageRect:(CGSize)size;
+ (CGRect)getGuideFrame:(CGRect)rect;

+ (int)docode:(unsigned char *)pbBuf len:(int)tLen;
+ (CGRect)getCorpCardRect:(int)width  height:(int)height guideRect:(CGRect)guideRect charCount:(int) charCount;

+ (char *)getNumbers;

+ (NSBundle *)getImageBundle;
@end

