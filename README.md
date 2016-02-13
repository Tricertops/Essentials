Essentials
==========

This is a collection of categories, functions, macros and classes that are _essential_ part of my projects.

> Prefix `ESS` is typically used, but we had no shame for using `NS`, `UI` or `CG` prefixes for relevant functions.


Highlights
----------

### ESSAssert
Assertion macro with optional message. It’ active also on Release and provides **fallback handling** using `else` clause. Works perfectly with compiler **static analysis**.

    ESSAssert(condition); // Prints default message.
    ESSDebugAssert(condition); // Active only on Debug.
    ESSAssert(condition, @"Must be %@", requirement); // Prints custom message.
    ESSAssert(condition) else return nil; // Fallback handler for Release.
    
    int* pointer = NULL;
    *pointer = 5; // Compiler warning for NULL dereference !!!
    ESSAssert(pointer) else return;
    *pointer = 5; // Compiler is ok, because we returned above.

### ESSLazyMake
Macro for convenient **lazy getters**.

    ESSLazyMake(NSData *, fileContents) {
        // Invoked only once, returned value is stored in _fileContents ivar.
        return [NSData stringWithContentsOfURL:self.fileURL];
    }

### NSEqual
Function for **nil-safe** object comparison. Calling `-isEqual:` on `nil` with `nil` argument returns wrong answer.

    NSEqual(nil, nil); // YES
    NSEqual(nil, @"A"); // NO
    NSEqual(@"A", nil); // NO
    NSEqual(@"A", @"A"); // YES

### ESSDebug / ESSNotice / ESSWarning / ESSError
Logging functions with **better format** than `NSLog()`. I don’t need to see year, process name or thread ID. Also allows **filtering** logs to arbitrary level (e.g. ignore `ESSDebug`).

      2016-02-13 10:16:17.838 ProcessName[76035:16575258] Using NSLog
      Feb 13 10:16:17: Using ESSDebug
      Feb 13 10:16:17: ╸Using ESSNotice╺
      Feb 13 10:16:17: ◆ Warning: Using ESSWarning ◆
      Feb 13 10:16:17: >> Error: Using ESSError <<
      
      Feb 13 10:20:28: BACKGROUND ╸Using ESSNotice from non-main thread╺

### +cast:
Type-checked method for **safe casting** of object pointers. Returns instance of the receiving class or `nil`.

      [NSString cast:@"A"]; // @"A"
      [NSString cast:@42]; // nil

### NSString
- Enumerating **occurences** of string.
- **Collecting** indexes of characters from set.
- Stripping diacritics and **normalizing** for search.
- Trimming **whitespace** and deleting HTML tags.
- **Splitting** to letters, words, sentences, and lines.

### NSOperationQueue
- Shared instances for all **Quality of Service** modes: `+interactiveQueue`, `+userQueue`, `+utilityQueue`, `+backgroundQueue`.
- Methods for **executing blocks** synchronously, asynchronously, after delay, in parallel.

### NSTimer
- **Block-based** constructor.
- Convenience **scheduling** in `UITrackingRunLoopMode`.
- Methods for **postpone** and hold.

### NSDate
- Convenient **comparison** methods (no more `-compare:` or `-earlierDate:`).
- **Rounding** dates to calendar components (to day, to hour, …).
- Checking whether two days are within the same calendar **component**.

### NSLocale
- **Accessors** for language, country, currency (no more `-objectForKey:`).
- Shared **POSIX** locale accessor.

### NSURLSession
Completely **custom interface** for making requests and handling responses.

- Accessor for shared session on **Main Queue**.
- Convenient **downloading** using `-download:completion:` and `-downloadFile:completion:`.
- Convenient **uploading** using `-uploadTo:payload:completion:`, where paylod may be `NSData`, `NSString` or `NSURL`.
- Easy to start request using **explicit HTTP** methods: GET, HEAD, DELETE, POST, PUT, PATCH.
- Unique **response** handling, see below.

### ESSURLResponse
Custom class that encapsulates interaction with HTTP responses, returned by `NSURLSession` category above.

- Access to **metadata**, like status code, headers, content length, MIME type, last modified date.
- Automatic status code propagation as `NSError` (e.g. 408 Request Timeout → `NSURLErrorTimedOut`).
- Access to **data** as `NSData` or `NSString` (of any encoding) and automatic **JSON** decoding.
- Access to URL of downloaded **file** and manipulation with it.
- Single **error** covering all domains (URL loading, status code errors, file error, JSON error).
- Convenient retry mechanism using `-shouldRetry` and `-retryAfter:`.

      [[NSURLSession mainQueueSession] download:URL
                                     completion:^(ESSURLResponse *response) {
          if (response.shouldRetry) {
              [response retryIfNeededAfter:5 count:3]; // Limit number of retries.
          }
          else {
              NSString *title = response.JSON[@"title"];
              // ...
          }
      }];

### ESSEncode / ESSDecode
Single pair of macros to encode and decode values of **any type** using `NSCoder`. It uses KVC and requires the coder to be stored in `decoder` and `encoder` variables.

    @property NSString *title;
    @property NSUInteger count;
    @property (weak) id owner;
    
    - (void)encodeWithCoder:(NSCoder *)encoder {
        ESSEncode(title);
        ESSEncode(count);
        ESSEncodeConditional(owner);
    }
    
    - (instancetype)initWithCoder:(NSCoder *)decoder {
        self = [self init];
        if (self) {
            ESSDecode(title);
            ESSDecode(count);
            ESSDecode(owner);
        }
        return self;
    }

### CGGeometry
- **Rounding** numbers, points, sizes and rects to **screen scale**.
- Fitting rects, getting rect center, and point arithmetics.

### UIColor
- Creating **random** colors and rendomizing shades of existing colors.
- Access to **components** and blending colors
- Access to **luminance** and deriving color with desired luminance.
- Getting **natural names** of colors (e.g. _red_, _light blue_, _teal_, _dark purple_).
- Creating autoreleased `CGGradients` (no more `CGGradientRef` functions).

### UIDevice Hardware
- Access to hardware identifier: _iPhone8,2_, _iPad5,2_
- Getting hardware name: _iPhone 6S Plus_, _iPad Mini 4_
- Getting hardware line: _iPhone Plus_, _iPad Mini_
- Getting hardware family: _iPhone_, _iPad_

### UIImage
- Creating images of **solid color**.
- Creating from **drawing code**.
- Getting photo **orientation** and equivalent `CFAffineTransform`.
- **Cropping** and **resizing**.
- Creating color **histograms**.
- Bitmap and per-pixel **processing**.

      UIImage *inverted = [image imageByEnumeratingPixels:^GLKVector4(GLKVector4 color) {
          return GLKVector4Make(1 - color.r,
                                1 - color.g,
                                1 - color.b,
                                color.a);
      }];

### UIView
- **Snapshotting**.
- Corner radius, rasterization, anchor point, border (no more `.layer`).
- Shadow using `NSShadow` and shadow path as `UIBezierPath`.
- Access to transform components: scale, rotation, translation.

### UIScrollView
- Getting and setting **page** for paged scroll views.
- Access to content scroll **progress**, a value in 0…1 range.
- **Stop** scrolling programatically.
- Enabling **Natural Touch Handling™** so `UIButton` is not delayed, just like `UITableViewCell`. Uses swizzling.

      [UIScrollView enableNaturalButtonHandling]; // Done!

### Attributed String
Category for setting **attributes as properties**.

    NSMutableAttribtedString *string = [NSMutableAttribtedString new];
    [string append:@"ABCD"];
    string.font = [UIFont boldSystemFontOfSize: 20];
    string.color = [UIColor redColor];
    string.alignment = NSTextAlignmentCenter;
    string.kerning = 10;
    string.hasUnderline = YES;
    
    // Set attributes on subrange:
    [string subrange:NSRangeMake(1, 2)].color = [UIColor blackColor];

### CoreImage
- Convenient `UIImage` **processing**.
- Filter **constructors** for every `CIFilter` type (e.g. blur, hue, saturation, contrast, invert, grayscale, …).

      UIImage *processed = [CIContext imageFromImage:image filters:@[
          [CIFilter blurWithRadius:7],
          [CIFilter adjustSaturation:1.3],
          [CIFilter invertColors],
          [CIFilter photoEffectTonal],
      ]];

##### And many more…