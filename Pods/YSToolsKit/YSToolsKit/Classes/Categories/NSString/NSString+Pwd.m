//
//  NSString+Pwd.m
//  YSKit
//
//  Created by Joseph Koh on 16/4/22.
//  Copyright © 2016年 Joseph. All rights reserved.
//

#import "NSString+Pwd.h"

@implementation NSString (Pwd)

- (NSString *)judgePasswordStrength {
    return [NSString judgePasswordStrength:self];
}

#pragma mark - 判断密码强度函数

/*
 声明：包含大写/小写/数字/特殊字符
 两种以下密码强度低
 两种密码强度中
 大于两种密码强度高
 密码强度标准根据需要随时调整
 */

//条件
+ (NSString*)judgePasswordStrength:(NSString*) _password
{
    NSMutableArray* resultArray = [[NSMutableArray alloc] init];
    
    NSArray* termArray1 = [[NSArray alloc] initWithObjects:@"a", @"b", @"c", @"d", @"e", @"f", @"g", @"h", @"i", @"j", @"k", @"l", @"m", @"n", @"o", @"p", @"q", @"r", @"s", @"t", @"u", @"v", @"w", @"x", @"y", @"z", nil];
    NSArray* termArray2 = [[NSArray alloc] initWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"0", nil];
    NSArray* termArray3 = [[NSArray alloc] initWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
    NSArray* termArray4 = [[NSArray alloc] initWithObjects:@"~",@"`",@"@",@"#",@"$",@"%",@"^",@"&",@"*",@"(",@")",@"-",@"_",@"+",@"=",@"{",@"}",@"[",@"]",@"|",@":",@";",@"“",@"'",@"‘",@"<",@",",@".",@">",@"?",@"/",@"、", nil];
    
    NSString* result1 = [NSString stringWithFormat:@"%d",[self judgeRange:termArray1 Password:_password]];
    NSString* result2 = [NSString stringWithFormat:@"%d",[self judgeRange:termArray2 Password:_password]];
    NSString* result3 = [NSString stringWithFormat:@"%d",[self judgeRange:termArray3 Password:_password]];
    NSString* result4 = [NSString stringWithFormat:@"%d",[self judgeRange:termArray4 Password:_password]];
    
    [resultArray addObject:[NSString stringWithFormat:@"%@",result1]];
    [resultArray addObject:[NSString stringWithFormat:@"%@",result2]];
    [resultArray addObject:[NSString stringWithFormat:@"%@",result3]];
    [resultArray addObject:[NSString stringWithFormat:@"%@",result4]];
    
    int intResult=0;
    for (int j = 0; j < [resultArray count]; j++)
    {
        if ([[resultArray objectAtIndex:j] isEqualToString:@"1"])
        {
            intResult++;
        }
    }
    
    NSString* resultString = [[NSString alloc] init];
    if (intResult > 2) {
        resultString = @"密码强度低，建议修改";
    }
    else if (intResult == 2 && [_password length] >= 6) {
        resultString = @"密码强度一般";
    }
    else if (intResult > 2 && [_password length] >= 6) {
        resultString = @"密码强度高";
    }
    
    return resultString;
}

//判断是否包含
+ (BOOL)judgeRange:(NSArray*) _termArray Password:(NSString*) _password
{
    NSRange range;
    BOOL result =NO;
    for(int i=0; i<[_termArray count]; i++)
    {
        range = [_password rangeOfString:[_termArray objectAtIndex:i]];
        if(range.location != NSNotFound)
        {
            result =YES;
        }
    }
    return result;
}

@end
