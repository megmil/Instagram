//
//  Post.h
//  Instagram
//
//  Created by Megan Miller on 6/27/22.
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"

@interface Post : PFObject<PFSubclassing>

@property (nonatomic, strong) PFUser *author;
@property (nonatomic, strong) NSString *caption;
@property (nonatomic, strong) PFFileObject *image;
@property (nonatomic, strong) NSNumber *likeCount;
@property (nonatomic, strong) NSNumber *commentCount;
@property (nonatomic, strong) NSMutableArray *comments;

+ (void) postUserImage:( UIImage * _Nullable )image withCaption:( NSString * _Nullable )caption
        withCompletion:(PFBooleanResultBlock  _Nullable)completion;

+ (PFFileObject * _Nullable)getPFFileFromImage:(UIImage * _Nullable)image;

@end
