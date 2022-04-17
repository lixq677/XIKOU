//
//  UITextView+XKUnitls.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/6/25.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "UITextView+XKUnitls.h"
#import <objc/runtime.h>

@implementation UITextView (XKUnitls)
@dynamic xk_textMapBlock;

- (void)setXk_maximum:(NSUInteger)xk_maximum{
    objc_setAssociatedObject(self, @selector(xk_maximum), @(xk_maximum), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSUInteger)xk_maximum{
    NSNumber *maximum = objc_getAssociatedObject(self, @selector(xk_maximum));
    return [maximum unsignedIntegerValue];
}

- (void)setXk_calspace:(BOOL)xk_calspace{
    objc_setAssociatedObject(self, @selector(xk_calspace), @(xk_calspace), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)xk_calspace{
    NSNumber *calspace = objc_getAssociatedObject(self, @selector(xk_calspace));
    return [calspace boolValue];
}


- (void)setXk_disposable:(RACDisposable *)xk_disposable{
    objc_setAssociatedObject(self, @selector(xk_disposable), xk_disposable, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)xk_setText:(NSString *)text{
    self.text = text;
}

- (RACDisposable *)xk_disposable{
     RACDisposable *disposable = objc_getAssociatedObject(self, @selector(xk_disposable));
    return disposable;
}

- (void)setXk_monitor:(BOOL)xk_monitor{
    if (self.xk_monitor == xk_monitor) return;
    objc_setAssociatedObject(self, @selector(xk_monitor), @(xk_monitor), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (xk_monitor) {
        @weakify(self);
        RACSignal *signal0 = [self.rac_textSignal filter:^BOOL(NSString * _Nullable value) {
             @strongify(self);
            NSString  *lang = [self.textInputMode primaryLanguage];
            if ([lang isEqualToString:@"zh-Hans"]) {//简体中文输入
                UITextRange *selectedRange = [self markedTextRange];
                UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];//获取高亮部分
                if (position) return NO;//有高亮不进行数据统计
            }
            return YES;
        }];
        RACSignal *signal1 = [[RACObserve(self, text) distinctUntilChanged] merge:signal0];
        RACSignal *signal2 = [signal1 map:^id _Nullable(id  _Nullable value) {
            @strongify(self);
            NSString *text = value;
            if (self.xk_calspace == NO) {
                 text = [(NSString *)value deleteSpace];
            }
            if (self.xk_maximum == 0 || text.length <= self.xk_maximum){
                return value;
            }else{
                NSUInteger maximum = self.xk_maximum + self.text.length - text.length;
                if (maximum>0 && self.text.length > maximum) {//最大长度大于约定长度，禁止输入
                    NSUInteger cursorPostion = [self offsetFromPosition:self.beginningOfDocument
                                                             toPosition:self.selectedTextRange.start];
                    __block NSInteger targetCursorPosition = cursorPostion - (self.text.length - maximum);
                    [self.text enumerateSubstringsInRange:NSMakeRange(0, targetCursorPosition) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
                        NSUInteger index = substring.length;
                        targetCursorPosition = targetCursorPosition + 1 - index;
                    }];
                    NSMutableString *mString = [NSMutableString stringWithString:self.text];
                    [mString deleteCharactersInRange:NSMakeRange(targetCursorPosition, cursorPostion-targetCursorPosition)];
                    return mString;
                }else{
                    return value;
                }
            }
        }];
        
        RACSignal *signal3 = [signal2 map:^id _Nullable(id  _Nullable value) {
            @strongify(self);
            if ([NSString isNull:self.restrictString]) return value;
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",self.restrictString];
            if([pred evaluateWithObject:value])return value;
            /*对限制字符做输入处理*/
            NSMutableString *string = [NSMutableString string];
            NSRange range  = NSMakeRange(0, 0);
            NSString *stringValue = (NSString *)value;
            for(int i=0; i<stringValue.length; i+=range.length){
                range = [stringValue rangeOfComposedCharacterSequenceAtIndex:i];
                NSString *subStr = [stringValue substringWithRange:range];
                if ([pred evaluateWithObject:subStr] == NO) continue;
                [string appendString:subStr];
            }
            return string;
        }];
        
        RACSignal *signal4 = [signal3 map:^id _Nullable(id  _Nullable val) {
             @strongify(self);
            if (self.xk_textFormatter != XKTextFormatterNone) {
                NSString *value = (NSString *)val;
                NSMutableString *string = [NSMutableString string];
                NSRange range  = NSMakeRange(0, 0);
                for(int i=0; i<value.length; i+=range.length){
                    range = [value rangeOfComposedCharacterSequenceAtIndex:i];
                    NSString *subStr = [value substringWithRange:range];
                    if ([NSString isNull:subStr]) continue;
                    NSString *temp = [string deleteSpace];
                    if (self.xk_textFormatter == XKTextFormatterMobile) {
                        if (temp.length >=3 && (temp.length-3)%4 == 0) {
                            [string appendString:@" "];
                        }
                    }else if(self.xk_textFormatter == XKTextFormatterID){
                        if (temp.length >=6 && (temp.length-6)%4 == 0) {
                            [string appendString:@" "];
                        }
                    }else{
                        if (temp.length%4 == 0 && temp.length != 0) {
                            [string appendString:@" "];
                        }
                    }
                    [string appendString:subStr];
                }
                return string;
            }else{
                return  val;
            }
        }];
        RACSignal *signal5 = [signal4 map:^id _Nullable(id  _Nullable value) {
            if (self.xk_textMapBlock) {
                return self.xk_textMapBlock(value);
            }else{
                return value;
            }
        }];
        __block NSString *oldTxt = nil;
        self.xk_disposable = [signal5 subscribeNext:^(id  _Nullable x) {
             @strongify(self);
            NSUInteger cursorPostion = [self offsetFromPosition:self.beginningOfDocument
            toPosition:self.selectedTextRange.start];
            NSString *val = (NSString *)x;
            NSInteger targetCursorPosition = cursorPostion - (self.text.length - val.length);
            BOOL eql1 = NO,eql2 = NO;
            if (val == nil && self.text == nil) {
                eql1 = YES;
            }else if (val != nil && self.text != nil && [val isEqualToString:self.text]){
                eql1 = YES;
            }else{
                eql1 = NO;
            }
            if (eql1 == NO) {
                self.text = val;
                UITextPosition *targetPosition =
                       [self positionFromPosition:[self beginningOfDocument]
                                           offset:targetCursorPosition];
                self.selectedTextRange = [self textRangeFromPosition:targetPosition toPosition:targetPosition];
            }
            
            if (oldTxt == nil && self.text == nil) {
                eql2 = YES;
            }else if (oldTxt != nil && self.text != nil && [oldTxt isEqualToString:self.text]){
                eql2 = YES;
            }else{
                eql2 = NO;
            }
            if (eql2 == NO) {
                oldTxt = [self.text mutableCopy];
                if (self.xk_textDidChangeBlock) {
                    self.xk_textDidChangeBlock(self.text);
                }
            }
        }];
    }else{
        if (self.xk_disposable) {
            [self.xk_disposable dispose];
            self.xk_disposable = nil;
        }
    }
}

- (BOOL)xk_monitor{
    NSNumber *monitor = objc_getAssociatedObject(self, @selector(xk_monitor));
    return [monitor boolValue];
}

- (void)setXk_textFormatter:(XKTextFormatter)textFormatter{
    objc_setAssociatedObject(self, @selector(xk_textFormatter), @(textFormatter), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
     self.xk_supportContent = self.xk_supportContent;
}

- (XKTextFormatter)xk_textFormatter{
    NSNumber *textFormatter = objc_getAssociatedObject(self, @selector(xk_textFormatter));
    return [textFormatter intValue];
}

- (void)setXk_supportWords:(NSString *)supportWords{
    objc_setAssociatedObject(self, @selector(xk_supportWords), supportWords, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.xk_supportContent = self.xk_supportContent;
}

- (NSString *)xk_supportWords{
    NSString *text  = objc_getAssociatedObject(self, @selector(xk_supportWords));
    return text;
}

- (void)setXk_supportContent:(XKTextSupportContent)xk_supportContent{
    objc_setAssociatedObject(self, @selector(xk_supportContent), @(xk_supportContent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if(xk_supportContent == XKTextSupportContentAll){
        self.restrictString = nil;
    }else if (xk_supportContent == XKTextSupportContentCustom){
        self.restrictString = self.xk_supportWords;
    }else{
        NSMutableString *string = [NSMutableString string];
        if (xk_supportContent & XKTextSupportContentChinese){
            [string appendString:@"\u4e00-\u9fa5"];
        }
        if (xk_supportContent & XKTextSupportContentCharacter){
            [string appendString:@"A-Za-z"];
        }
        if (xk_supportContent& XKTextSupportContentNumber){
            [string appendString:@"0-9"];
        }
        if (xk_supportContent& XKTextSupportContentSymbol) {
            [string appendString:@"`~!@#$%^&*()+=|{}':;',\\[\\].<>/?~！@#￥%……&*（）——+|{}【】‘；：”“’。，、？[-]•－／｜＼／～＠《》〈〉〔〕［］<>-_ˇ｛｝ˉ¨＝＜％＄＃＋︿＿＆＊＂｀．〃‖々「」『』〖〗∶＇＂＊ ＆]+"];
        }
        if (xk_supportContent == XKTextSupportContentAll) {
            string = nil;
        }
        
        if (string != nil) {
            [string insertString:@"[" atIndex:0];
            if ((xk_supportContent & XKTextSupportContentSpace) || self.xk_textFormatter != XKTextFormatterNone) {
                [string appendString:@" "];
            }
            [string appendString:@"]*"];
        }
        self.restrictString = string;
    }
}

- (XKTextSupportContent)xk_supportContent{
    NSNumber *supportContent = objc_getAssociatedObject(self, @selector(xk_supportContent));
    return [supportContent integerValue];
}


- (void)setXk_textDidChangeBlock:(void (^)(NSString * _Nonnull))xk_textDidChangeBlock{
        objc_setAssociatedObject(self, @selector(xk_textDidChangeBlock), xk_textDidChangeBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(NSString * _Nonnull))xk_textDidChangeBlock{
    void (^block)(NSString * _Nonnull) = objc_getAssociatedObject(self, @selector(xk_textDidChangeBlock));
    return block;
}

- (void)setXk_textMapBlock:(NSString *(^)(NSString * _Nonnull))xk_textMapBlock{
        objc_setAssociatedObject(self, @selector(xk_textMapBlock), xk_textMapBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *(^)(NSString * _Nonnull))xk_textMapBlock{
    NSString *(^block)(NSString * _Nonnull) = objc_getAssociatedObject(self, @selector(xk_textMapBlock));
    return block;
}



- (NSString *)restrictString{
    NSString *restrictString = objc_getAssociatedObject(self, @selector(restrictString));
    return restrictString;
}

- (void)setRestrictString:(NSString *)restrictString{
    objc_setAssociatedObject(self, @selector(restrictString), restrictString, OBJC_ASSOCIATION_COPY_NONATOMIC);
}


@end
