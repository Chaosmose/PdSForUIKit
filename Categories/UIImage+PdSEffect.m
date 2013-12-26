// This file is part of "PdSForUIKit"
//
// "PdSForUIKit" is free software: you can redistribute it and/or modify
// it under the terms of the GNU LESSER GENERAL PUBLIC LICENSE as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// "PdSMatrix" is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU LESSER GENERAL PUBLIC LICENSE for more details.
//
// You should have received a copy of the GNU LESSER GENERAL PUBLIC LICENSE
// along with "PdSForUIKit"  If not, see <http://www.gnu.org/licenses/>
//
//
//  UIImage+PdSEffect.m
//  PdSForUIKit
//
//  Created by Benoit Pereira da Silva on 26/12/2013.
//  Copyright (c) 2013 http://pereira-da-silva.com All rights reserved.
//

#import "UIImage+PdSEffect.h"
#import <Accelerate/Accelerate.h>
#import <math.h>

// utility to find position for x/y values in a matrix
#define DSP_KERNEL_POSITION(x,y,size) (x * size + y)

@interface UIImage (DSP)
// return auto-released gaussian blurred image
-(UIImage*) imageByApplyingGaussianBlur3x3;
-(UIImage*) imageByApplyingGaussianBlur5x5;

// gaussian blur with arbitrary kernel size and sigma (controlling the std deviation => spread => blur amount)
// higher sigmaSq values result in more blur... experiment to find something appropriate for your application,
// for kernel size of 8 you might try 30 to start
-(UIImage*) imageByApplyingGaussianBlurOfSize:(int)kernelSize withSigmaSquared:(float)sigmaSq;

// methods are provided for both a two pass (default) and one pass gaussian blur but the two pass is STRONGLY
// recomended due to mathematical equivallence and greatly increased speed for large kernels
// as such I've left this commented out by default
// -(UIImage*) imageByApplyingOnePassGaussianBlurOfSize:(int)kernelSize withSigmaSquared:(float)sigmaSq;

// sharpening
-(UIImage*) imageByApplyingSharpen3x3;

// others
-(UIImage*) imageByApplyingBoxBlur3x3; // not generally as good as gaussian

-(UIImage*) imageByApplyingEmboss3x3;

-(UIImage*) imageByApplyingDiagonalMotionBlur5x5;
//-(UIImage*) imageByApplyingDiagonalMotionBlur7x7;

// utility for normalizing matrices
-(void) normaliseMatrix:(float*)kernel ofSize:(int)size;

// if you call these methods directly and do something interesting with them please consider
// sending me details on github so that I may incorporate your awesomeness into the library
-(UIImage*) imageByApplyingMatrix:(float*)matrix ofSize:(DSPMatrixSize)matrixSize;
-(UIImage*) imageByApplyingMatrix:(float*)matrix ofSize:(DSPMatrixSize)matrixSize;
-(UIImage*) imageByApplyingMatrix:(float*)matrix ofSize:(DSPMatrixSize)matrixSize clipValues:(bool)shouldClip;
@end

@interface UIImage (PdSRoundedCorner)
- (UIImage *)roundedCornerImage:(NSInteger)cornerSize borderSize:(NSInteger)borderSize;
@end

@implementation UIImage (PdSEffect)

#pragma mark - Resize

// Returns a copy of this image that is cropped to the given bounds.
// The bounds will be adjusted using CGRectIntegral.
// This method ignores the image's imageOrientation setting.
- (UIImage *)croppedImage:(CGRect)bounds {
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], bounds);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return croppedImage;
}

// Returns a copy of this image that is squared to the thumbnail size.
// If transparentBorder is non-zero, a transparent border of the given size will be added around the edges of the thumbnail.
// (Adding a transparent border of at least one pixel in size has the side-effect of antialiasing the edges of the image when rotating it using Core Animation.)

- (UIImage *)thumbnailImage:(NSInteger)thumbnailSize
          transparentBorder:(NSUInteger)borderSize
               cornerRadius:(NSUInteger)cornerRadius
       interpolationQuality:(CGInterpolationQuality)quality {
    UIImage *resizedImage = [self resizedImageWithContentMode:UIViewContentModeScaleAspectFill
                                                       bounds:CGSizeMake(thumbnailSize, thumbnailSize)
                                         interpolationQuality:quality];
    
    // Crop out any part of the image that's larger than the thumbnail size
    // The cropped rect must be centered on the resized image
    // Round the origin points so that the size isn't altered when CGRectIntegral is later invoked
    CGRect cropRect = CGRectMake(round((resizedImage.size.width - thumbnailSize) / 2),
                                 round((resizedImage.size.height - thumbnailSize) / 2),
                                 thumbnailSize,
                                 thumbnailSize);
    UIImage *croppedImage = [resizedImage croppedImage:cropRect];
    
    UIImage *transparentBorderImage = borderSize ? [croppedImage transparentBorderImage:borderSize] : croppedImage;
    
    return  [transparentBorderImage roundedCornerImage:cornerRadius borderSize:borderSize];
}



// Returns a rescaled copy of the image, taking into account its orientation
// The image will be scaled disproportionately if necessary to fit the bounds specified by the parameter
- (UIImage *)resizedImage:(CGSize)newSize interpolationQuality:(CGInterpolationQuality)quality {
    BOOL drawTransposed;
    
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            drawTransposed = YES;
            break;
            
        default:
            drawTransposed = NO;
    }
    
    return [self resizedImage:newSize
                    transform:[self transformForOrientation:newSize]
               drawTransposed:drawTransposed
         interpolationQuality:quality];
}






// Resizes the image according to the given content mode, taking into account the image's orientation
- (UIImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode
                                  bounds:(CGSize)bounds
                    interpolationQuality:(CGInterpolationQuality)quality {
    CGFloat horizontalRatio = bounds.width / self.size.width;
    CGFloat verticalRatio = bounds.height / self.size.height;
    CGFloat ratio;
    
    switch (contentMode) {
        case UIViewContentModeScaleAspectFill:
            ratio = MAX(horizontalRatio, verticalRatio);
            break;
            
        case UIViewContentModeScaleAspectFit:
            ratio = MIN(horizontalRatio, verticalRatio);
            break;
            
        default:
            [NSException raise:NSInvalidArgumentException format:@"Unsupported content mode: %d", contentMode];
    }
    
    CGSize newSize = CGSizeMake(self.size.width * ratio, self.size.height * ratio);
    
    return [self resizedImage:newSize interpolationQuality:quality];
}

// Returns a copy of the image that has been transformed using the given affine transform and scaled to the new size
// The new image's orientation will be UIImageOrientationUp, regardless of the current image's orientation
// If the new size is not integral, it will be rounded up
- (UIImage *)resizedImage:(CGSize)newSize
                transform:(CGAffineTransform)transform
           drawTransposed:(BOOL)transpose
     interpolationQuality:(CGInterpolationQuality)quality {
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGRect transposedRect = CGRectMake(0, 0, newRect.size.height, newRect.size.width);
    CGImageRef imageRef = self.CGImage;
    
    // make the following changes.
    
    //** [PATCHED BY BPDS 2011] (bundled png support)
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef bitmap = CGBitmapContextCreate(NULL, newRect.size.width, newRect.size.height, 8, 4 * newRect.size.width, colorSpace, 2);// kCGImageAlphaPremultipliedFirst BPDS);
    CGColorSpaceRelease(colorSpace);
    
    /*
     // Build a context that's the same dimensions as the new size
     CGContextRef bitmap = CGBitmapContextCreate(NULL,
     newRect.size.width,
     newRect.size.height,
     CGImageGetBitsPerComponent(imageRef),
     0,
     CGImageGetColorSpace(imageRef),
     CGImageGetBitmapInfo(imageRef));
     */
    
    
    //** [END OF PATCH ]
    
    // Rotate and/or flip the image if required by its orientation
    CGContextConcatCTM(bitmap, transform);
    
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(bitmap, quality);
    
    // Draw into the context; this scales the image
    CGContextDrawImage(bitmap, transpose ? transposedRect : newRect, imageRef);
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(bitmap);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    // Clean up
    CGContextRelease(bitmap);
    CGImageRelease(newImageRef);
    
    return newImage;
}

// Returns an affine transform that takes into account the image orientation when drawing a scaled image
- (CGAffineTransform)transformForOrientation:(CGSize)newSize {
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:           // EXIF = 3
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, newSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:           // EXIF = 6
        case UIImageOrientationLeftMirrored:   // EXIF = 5
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:          // EXIF = 8
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, 0, newSize.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
            break;
            
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:     // EXIF = 2
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:   // EXIF = 5
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, newSize.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    return transform;
}



#pragma mark - Alpha

// Returns true if the image has an alpha layer
- (BOOL)hasAlpha {
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(self.CGImage);
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}

// Returns a copy of the given image, adding an alpha channel if it doesn't already have one
- (UIImage *)imageWithAlpha {
    if ([self hasAlpha]) {
        return self;
    }
    
    CGImageRef imageRef = self.CGImage;
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    
    // The bitsPerComponent and bitmapInfo values are hard-coded to prevent an "unsupported parameter combination" error
    CGContextRef offscreenContext = CGBitmapContextCreate(NULL,
                                                          width,
                                                          height,
                                                          8,
                                                          0,
                                                          CGImageGetColorSpace(imageRef),
                                                          kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
    
    // Draw the image into the context and retrieve the new image, which will now have an alpha layer
    CGContextDrawImage(offscreenContext, CGRectMake(0, 0, width, height), imageRef);
    CGImageRef imageRefWithAlpha = CGBitmapContextCreateImage(offscreenContext);
    UIImage *imageWithAlpha = [UIImage imageWithCGImage:imageRefWithAlpha];
    
    // Clean up
    CGContextRelease(offscreenContext);
    CGImageRelease(imageRefWithAlpha);
    
    return imageWithAlpha;
}

// Returns a copy of the image with a transparent border of the given size added around its edges.
// If the image has no alpha layer, one will be added to it.
- (UIImage *)transparentBorderImage:(NSUInteger)borderSize {
    // If the image does not have an alpha layer, add one
    UIImage *image = [self imageWithAlpha];
    
    CGRect newRect = CGRectMake(0, 0, image.size.width + borderSize * 2, image.size.height + borderSize * 2);
    
    // Build a context that's the same dimensions as the new size
    CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                                newRect.size.width,
                                                newRect.size.height,
                                                CGImageGetBitsPerComponent(self.CGImage),
                                                0,
                                                CGImageGetColorSpace(self.CGImage),
                                                CGImageGetBitmapInfo(self.CGImage));
    
    // Draw the image in the center of the context, leaving a gap around the edges
    CGRect imageLocation = CGRectMake(borderSize, borderSize, image.size.width, image.size.height);
    CGContextDrawImage(bitmap, imageLocation, self.CGImage);
    CGImageRef borderImageRef = CGBitmapContextCreateImage(bitmap);
    
    // Create a mask to make the border transparent, and combine it with the image
    CGImageRef maskImageRef = [self newBorderMask:borderSize size:newRect.size];
    CGImageRef transparentBorderImageRef = CGImageCreateWithMask(borderImageRef, maskImageRef);
    UIImage *transparentBorderImage = [UIImage imageWithCGImage:transparentBorderImageRef];
    
    // Clean up
    CGContextRelease(bitmap);
    CGImageRelease(borderImageRef);
    CGImageRelease(maskImageRef);
    CGImageRelease(transparentBorderImageRef);
    
    return transparentBorderImage;
}

// Creates a mask that makes the outer edges transparent and everything else opaque
// The size must include the entire mask (opaque part + transparent border)
// The caller is responsible for releasing the returned reference by calling CGImageRelease
- (CGImageRef)newBorderMask:(NSUInteger)borderSize size:(CGSize)size {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    // Build a context that's the same dimensions as the new size
    CGContextRef maskContext = CGBitmapContextCreate(NULL,
                                                     size.width,
                                                     size.height,
                                                     8, // 8-bit grayscale
                                                     0,
                                                     colorSpace,
                                                     kCGBitmapByteOrderDefault | kCGImageAlphaNone);
    
    // Start with a mask that's entirely transparent
    CGContextSetFillColorWithColor(maskContext, [UIColor blackColor].CGColor);
    CGContextFillRect(maskContext, CGRectMake(0, 0, size.width, size.height));
    
    // Make the inner part (within the border) opaque
    CGContextSetFillColorWithColor(maskContext, [UIColor whiteColor].CGColor);
    CGContextFillRect(maskContext, CGRectMake(borderSize, borderSize, size.width - borderSize * 2, size.height - borderSize * 2));
    
    // Get an image of the context
    CGImageRef maskImageRef = CGBitmapContextCreateImage(maskContext);
    
    // Clean up
    CGContextRelease(maskContext);
    CGColorSpaceRelease(colorSpace);
    
    return maskImageRef;
}


#pragma mark - Blur


+ (UIImage *)imageByApplyingGaussianBlur5x5:(UIImage*)image {
    return [image imageByApplyingGaussianBlur5x5];
}

+ (UIImage *)imageByApplyingGaussianBlur3x3:(UIImage*)image {
    return [image imageByApplyingGaussianBlur3x3];
}

+ (UIImage *)imageByApplyingDiagonalMotionBlur5x5:(UIImage*)image {
    return [image imageByApplyingDiagonalMotionBlur5x5];
}


+ (UIImage *)imageByApplyingBlurOn:(UIImage*)image size:(int)size sigma:(float)sigma{
    return [image imageByApplyingGaussianBlurOfSize:size withSigmaSquared:sigma];
}


#pragma mark - grayScale


// Transform the image in grayscale.
UIImage *grayishImage(UIImage *inputImage) {
    
    // Create a graphic context.
    UIGraphicsBeginImageContextWithOptions(inputImage.size, YES, 1.0);
    CGRect imageRect = CGRectMake(0, 0, inputImage.size.width, inputImage.size.height);
    
    // Draw the image with the luminosity blend mode.
    // On top of a white background, this will give a black and white image.
    [inputImage drawInRect:imageRect blendMode:kCGBlendModeLuminosity alpha:1.0];
    
    // Get the resulting image.
    UIImage *filteredImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return filteredImage;
}

+(UIImage*)grayScale:(UIImage*)original{
    return grayishImage(original);
}



#pragma mark mask

CGImageRef CopyImageAndAddAlphaChannel(CGImageRef sourceImage) {
	CGImageRef retVal = NULL;
	
	size_t width = CGImageGetWidth(sourceImage);
	size_t height = CGImageGetHeight(sourceImage);
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	
	CGContextRef offscreenContext = CGBitmapContextCreate(NULL, width, height,
                                                          8, 0, colorSpace, 2);// kCGImageAlphaPremultipliedFirst
	
	if (offscreenContext != NULL) {
		CGContextDrawImage(offscreenContext, CGRectMake(0, 0, width, height), sourceImage);
		
		retVal = CGBitmapContextCreateImage(offscreenContext);
		CGContextRelease(offscreenContext);
	}
	
	CGColorSpaceRelease(colorSpace);
	
	return retVal;
}



+ (UIImage*)maskImage:(UIImage *)image withMask:(UIImage *)maskImage{
    
	CGImageRef maskRef  = maskImage.CGImage;
	CGImageRef mask     = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                            CGImageGetHeight(maskRef),
                                            CGImageGetBitsPerComponent(maskRef),
                                            CGImageGetBitsPerPixel(maskRef),
                                            CGImageGetBytesPerRow(maskRef),
                                            CGImageGetDataProvider(maskRef), NULL, false);
	
	CGImageRef sourceImage      = [image CGImage];
    
	//add alpha channel for images that don't have one (ie GIF, JPEG, etc...)
	//this however has a computational cost
    
    NSInteger alphaInfo = CGImageGetAlphaInfo(sourceImage);
    if ( alphaInfo == kCGImageAlphaNone || alphaInfo == kCGImageAlphaNoneSkipLast || alphaInfo == kCGImageAlphaNoneSkipFirst ) {
		CGImageRef imageWithAlpha   = CopyImageAndAddAlphaChannel(sourceImage);
        CGImageRef masked           = CGImageCreateWithMask(imageWithAlpha, mask);
        CGImageRelease(mask);
        CGImageRelease(imageWithAlpha);
        UIImage* retImage = [UIImage imageWithCGImage:masked];
        CGImageRelease(masked);
        return  retImage;
	}else{
        CGImageRelease(mask);
        return image;
    }
}




#pragma mark - DSP



// forward definitions of our utility methods so the important stuff's at the top
CGContextRef _dsp_utils_CreateARGBBitmapContext (CGImageRef inImage);
void _releaseDspData(void *info,const void *data,size_t size);


// the real "workhorse" matrix dsp method
-(UIImage*) imageByApplyingMatrix:(float*)matrix ofSize:(DSPMatrixSize)matrixSize matrixRows:(int)matrixRows matrixCols:(int)matrixCols clipValues:(bool)shouldClip {
    UIImage* destImg = nil;
    
    CGImageRef inImage = self.CGImage;
    CGContextRef context = _dsp_utils_CreateARGBBitmapContext(inImage);
    if (context == NULL) {
        return destImg; // nil
    }
    
    size_t width = CGBitmapContextGetWidth(context);
    size_t height = CGBitmapContextGetHeight(context);
    size_t bpr = CGBitmapContextGetBytesPerRow(context);
    
    CGRect rect = {{0,0},{width,height}};
    CGContextDrawImage(context, rect, inImage);
    
    // get image data (as char array)
    unsigned char *srcData, *finalData;
    srcData = (unsigned char *)CGBitmapContextGetData (context);
    
    finalData = malloc(bpr * height * sizeof(unsigned char));
    
    if (srcData != NULL && finalData != NULL)
    {
        size_t dataSize = bpr * height;
        
        // copy src to destination: technically this is a bit wasteful as we'll overwrite
        // all but the "alpha" portion of finalData during processing but I'm unaware of
        // a memcpy with stride function
        memcpy(finalData, srcData, dataSize);
        
        // alloc space for our dsp arrays
        float * srcAsFloat = malloc(width*height*sizeof(float));
        float* resultAsFloat = malloc(width*height*sizeof(float));
        
        // loop through each colour (color) chanel (skip the first chanel, it's alpha and is left alone)
        for (int i=1; i<4; i++) {
            // convert src pixels into float data type
            vDSP_vfltu8(srcData+i,4,srcAsFloat,1,width * height);
            
            // apply matrix using dsp
            switch (matrixSize) {
                case DSPMatrixSize3x3:
                    vDSP_f3x3(srcAsFloat, height, width, matrix, resultAsFloat);
                    break;
                    
                case DSPMatrixSize5x5:
                    vDSP_f5x5(srcAsFloat, height, width, matrix, resultAsFloat);
                    break;
                    
                case DSPMatrixSizeCustom:
                    NSAssert(matrixCols > 0 && matrixRows > 0,
                             @"invalid usage: please use full method definition and pass rows/cols for matrix");
                    vDSP_imgfir(srcAsFloat, height, width, matrix, resultAsFloat, matrixRows, matrixCols);
                    break;
                    
                default:
                    break;
            }
            
            // certain operations may result in values to large or too small in our output float array
            // so if necessary we clip the results here. This param is optional so that we don't need to take
            // the speed hit on blur operations or others which can't result in invalid float values.
            if (shouldClip) {
                float min = 0;
                float max = 255;
                vDSP_vclip(resultAsFloat, 1, &min, &max, resultAsFloat, 1, width * height);
            }
            
            // convert back into bytes and copy into finalData
            vDSP_vfixu8(resultAsFloat, 1, finalData+i, 4, width * height);
        }
        
        // clean up dsp space
        free(srcAsFloat);
        free(resultAsFloat);
        
        // create new image from out output data
        CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, finalData, dataSize, &_releaseDspData);
        CGImageRef cgImage = CGImageCreate(width, height, CGBitmapContextGetBitsPerComponent(context),
                                           CGBitmapContextGetBitsPerPixel(context), CGBitmapContextGetBytesPerRow(context), CGBitmapContextGetColorSpace(context), CGBitmapContextGetBitmapInfo(context),
                                           dataProvider, NULL, true, kCGRenderingIntentDefault);
        destImg = [UIImage imageWithCGImage:cgImage];
        
        CGImageRelease(cgImage);
        
        // clear all our cg stuff
        CGDataProviderRelease(dataProvider);
        free(srcData);
    }
    CGContextRelease(context);
    
    return destImg;
}

// convenience methods to make calling conventions easier with defaults
-(UIImage*) imageByApplyingMatrix:(float*)matrix ofSize:(DSPMatrixSize)matrixSize {
    return [self imageByApplyingMatrix:matrix ofSize:matrixSize matrixRows:-1 matrixCols:-1 clipValues:NO];
}
-(UIImage*) imageByApplyingMatrix:(float*)matrix ofSize:(DSPMatrixSize)matrixSize clipValues:(bool)shouldClip {
    return [self imageByApplyingMatrix:matrix ofSize:matrixSize matrixRows:-1 matrixCols:-1 clipValues:shouldClip];
}

// uses a pre-calculated kernel
-(UIImage*) imageByApplyingGaussianBlur3x3 {
    static const float kernel[] = { 1/16.0f, 2/16.0f, 1/16.0f, 2/16.0f, 4/16.0f, 2/16.0f, 1/16.0f, 2/16.0f, 1/16.0f };
    
    return [self imageByApplyingMatrix:(float*)kernel ofSize:DSPMatrixSize3x3];
}

// uses a pre-calculated kernel
-(UIImage*) imageByApplyingGaussianBlur5x5 {
    static float kernel[] =
    { 1/256.0f,  4/256.0f,  6/256.0f,  4/256.0f, 1/256.0f,
        4/256.0f, 16/256.0f, 24/256.0f, 16/256.0f, 4/256.0f,
        6/256.0f, 24/256.0f, 36/256.0f, 24/256.0f, 6/256.0f,
        4/256.0f, 16/256.0f, 24/256.0f, 16/256.0f, 4/256.0f,
        1/256.0f,  4/256.0f,  6/256.0f,  4/256.0f, 1/256.0f };
    
    return [self imageByApplyingMatrix:(float*)kernel ofSize:DSPMatrixSize5x5];
}

// utility for calculating 2d gaussian distribution values for generating arrays
-(float) gausValueAt:(float)x andY:(float)y andSigmaSq:(float)sigmaSq {
    float powerResult =  pow(M_E, -( (x*x+y*y) / (2*sigmaSq) ));
    float result = ( 1/(sqrt(2*M_PI*sigmaSq)) ) * powerResult;
    return result;
}

// arbitrary sized gaussian blur
-(UIImage*) imageByApplyingOnePassGaussianBlurOfSize:(int)kernelSize withSigmaSquared:(float)sigmaSq {
    float kernel[kernelSize * kernelSize];
    int halfSize = (int)(0.5 * kernelSize);
    float sum = 0.0;
    
    // generate the gaussian distribution
    for (int i=0; i<kernelSize; i++) {
        for (int j=0; j<kernelSize; j++) {
            float xDistance = 1.0 * i - halfSize;
            float yDistance = 1.0 * j - halfSize;
            float gausValue = [self gausValueAt:xDistance andY:yDistance andSigmaSq:sigmaSq];
            
            kernel[DSP_KERNEL_POSITION(i, j, kernelSize)] = gausValue;
            
            sum += gausValue;
        }
    }
    
    // normalise to avoid distorting brightness
    for (int i=0; i<kernelSize; i++) {
        for (int j=0; j<kernelSize; j++) {
            float gausValue = kernel[DSP_KERNEL_POSITION(i, j, kernelSize)];
            float normal = gausValue / sum;
            
            kernel[DSP_KERNEL_POSITION(i, j, kernelSize)] = normal;
        }
    }
    
    // apply the generated kernel
    return [self imageByApplyingMatrix:kernel ofSize:DSPMatrixSizeCustom matrixRows:kernelSize matrixCols:kernelSize clipValues:NO];
}

// ----------- Fast 2 pass Gaussian blur
-(float) gaussianValueFor:(float)i withSigmaSq:(float)sigmaSq {
    float powerResult =  pow(M_E, -( (i*i) / (2*sigmaSq) ));
    float result = ( 1/(sqrt(2*M_PI*sigmaSq)) ) * powerResult;
    return result;
}
-(UIImage*) imageByApplyingGaussianBlurOfSize:(int)kernelSize withSigmaSquared:(float)sigmaSq {
    float kernel[kernelSize];
    int halfSize = (int)(0.5 * kernelSize);
    
    for (int i=0; i<kernelSize; i++) {
        float distance = 1.0 * i - halfSize;
        float gausValue = [self gaussianValueFor:distance withSigmaSq:sigmaSq];
        
        kernel[i] = gausValue;
    }
    
    [self normaliseMatrix:kernel ofSize:kernelSize];
    
    UIImage* result = self;
    
    // apply this kernel horizontally
    result = [result imageByApplyingMatrix:kernel ofSize:DSPMatrixSizeCustom matrixRows:1 matrixCols:kernelSize clipValues:NO];
    
    // then vertically
    result = [result imageByApplyingMatrix:kernel ofSize:DSPMatrixSizeCustom matrixRows:kernelSize matrixCols:1 clipValues:NO];
    
    return result;
}


-(UIImage*) imageByApplyingBoxBlur3x3 {
    static const float kernel[] = { 1/9.0f, 1/9.0f, 1/9.0f, 1/9.0f, 1/9.0f, 1/9.0f, 1/9.0f, 1/9.0f, 1/9.0f };
    
    return [self imageByApplyingMatrix:(float*)kernel ofSize:DSPMatrixSize3x3];
}


-(UIImage*) imageByApplyingSharpen3x3 {
    static const float kernel[] = { 0.0f, -1/4.0f, 0.0f, -1/4.0f, 8/4.0f, -1/4.0f, 0.0f, -1/4.0f, 0.0f };
    
    return [self imageByApplyingMatrix:(float*)kernel ofSize:DSPMatrixSize3x3 clipValues:YES];
}

-(UIImage*) imageByApplyingEmboss3x3 {
    static const float kernel[] = { -2.0f, -1.0f, 0.0f, -1.0f, 1.0f, 1.0f, 0.0f, 1.0f, 2.0f };
    
    return [self imageByApplyingMatrix:(float*)kernel ofSize:DSPMatrixSize3x3 clipValues:YES];
}

-(UIImage*) imageByApplyingDiagonalMotionBlur5x5 {
    float kernel[] = {
        0.22222, 0.27778, 0.22222, 0.05556, 0.00000,
        0.27778, 0.44444, 0.44444, 0.22222, 0.05556,
        0.22222, 0.44444, 0.55556, 0.44444, 0.22222,
        0.05556, 0.22222, 0.44444, 0.44444, 0.27778,
        0.00000, 0.05556, 0.22222, 0.27778, 0.22222
    };
    
    [self normaliseMatrix:kernel ofSize:5*5];
    
    return [self imageByApplyingMatrix:(float*)kernel ofSize:DSPMatrixSize5x5 clipValues:YES];
}

-(void) normaliseMatrix:(float*)kernel ofSize:(int)size {
    int entries = size;
    
    // calculate the sum
    float sum = 0.0;
    for (int i=0; i<entries; i++) {
        sum += kernel[i];
    }
    
    // normalise values and store back in array
    for (int i=0; i<entries; i++) {
        float value = kernel[i];
        float normal = value / sum;
        
        kernel[i] = normal;
    }
}


// -------------------------------------------------------------------
// utility methods
// taken from http://iphonedevelopment.blogspot.com/2010/03/irregularly-shaped-uibuttons.html
// and renamed to avoid conflicts for anyone who also includes the original source
CGContextRef _dsp_utils_CreateARGBBitmapContext (CGImageRef inImage)
{
    CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace;
    void *          bitmapData;
    int             bitmapByteCount;
    int             bitmapBytesPerRow;
    
    
    size_t pixelsWide = CGImageGetWidth(inImage);
    size_t pixelsHigh = CGImageGetHeight(inImage);
    bitmapBytesPerRow   = (pixelsWide * 4);
    bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
    
    colorSpace = CGColorSpaceCreateDeviceRGB();
    if (colorSpace == NULL)
        return nil;
    
    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL)
    {
        CGColorSpaceRelease( colorSpace );
        return nil;
    }
    context = CGBitmapContextCreate (bitmapData,
                                     pixelsWide,
                                     pixelsHigh,
                                     8,
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     2);// kCGImageAlphaPremultipliedFirst BPDS
    if (context == NULL)
    {
        free (bitmapData);
        fprintf (stderr, "Context not created!");
    }
    CGColorSpaceRelease( colorSpace );
    
    return context;
}

// utility method to free any blocks of char data we sent to any data
// providers
void _releaseDspData(void *info,const void *data,size_t size) {
    free((unsigned char*)data);
}

#pragma mark - Round corner 

// Creates a copy of this image with rounded corners
// If borderSize is non-zero, a transparent border of the given size will also be added
// Original author: Björn Sållarp. Used with permission. See: http://blog.sallarp.com/iphone-uiimage-round-corners/
- (UIImage *)roundedCornerImage:(NSInteger)cornerSize borderSize:(NSInteger)borderSize {
    // If the image does not have an alpha layer, add one
    UIImage *image = [self imageWithAlpha];
    
    // Build a context that's the same dimensions as the new size
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 image.size.width,
                                                 image.size.height,
                                                 CGImageGetBitsPerComponent(image.CGImage),
                                                 0,
                                                 CGImageGetColorSpace(image.CGImage),
                                                 CGImageGetBitmapInfo(image.CGImage));
    
    // Create a clipping path with rounded corners
    CGContextBeginPath(context);
    [self addRoundedRectToPath:CGRectMake(borderSize, borderSize, image.size.width - borderSize * 2, image.size.height - borderSize * 2)
                       context:context
                     ovalWidth:cornerSize
                    ovalHeight:cornerSize];
    CGContextClosePath(context);
    CGContextClip(context);
    
    // Draw the image to the context; the clipping path will make anything outside the rounded rect transparent
    CGContextDrawImage(context, CGRectMake(0, 0, image.size.width, image.size.height), image.CGImage);
    
    // Create a CGImage from the context
    CGImageRef clippedImage = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    
    // Create a UIImage from the CGImage
    UIImage *roundedImage = [UIImage imageWithCGImage:clippedImage];
    CGImageRelease(clippedImage);
    
    return roundedImage;
}

#pragma mark -
#pragma mark Private helper methods

// Adds a rectangular path to the given context and rounds its corners by the given extents
// Original author: Björn Sållarp. Used with permission. See: http://blog.sallarp.com/iphone-uiimage-round-corners/
- (void)addRoundedRectToPath:(CGRect)rect context:(CGContextRef)context ovalWidth:(CGFloat)ovalWidth ovalHeight:(CGFloat)ovalHeight {
    if (ovalWidth == 0 || ovalHeight == 0) {
        CGContextAddRect(context, rect);
        return;
    }
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, ovalWidth, ovalHeight);
    CGFloat fw = CGRectGetWidth(rect) / ovalWidth;
    CGFloat fh = CGRectGetHeight(rect) / ovalHeight;
    CGContextMoveToPoint(context, fw, fh/2);
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}



@end
