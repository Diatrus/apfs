#import <Foundation/Foundation.h>

typedef char io_string_t[512];
typedef mach_port_t io_object_t;
typedef io_object_t io_registry_entry_t;
io_registry_entry_t IORegistryEntryFromPath(mach_port_t master, const io_string_t path);
CFTypeRef IORegistryEntryCreateCFProperty(io_registry_entry_t entry, CFStringRef key, CFAllocatorRef allocator, uint32_t options);
kern_return_t IOObjectRelease(io_object_t object);

int
do_original_name()
{
	const io_registry_entry_t chosen = IORegistryEntryFromPath(0, "IODeviceTree:/chosen");
	const NSData *data = (__bridge const NSData *)IORegistryEntryCreateCFProperty(chosen, (__bridge CFStringRef)@"boot-manifest-hash", kCFAllocatorDefault, 0);
	IOObjectRelease(chosen);

	NSMutableString *manifestHash = [NSMutableString stringWithString:@""];
	NSUInteger len = [data length];
	Byte *buf = (Byte*)malloc(len);
	memcpy(buf, [data bytes], len);
	int buf2;
	for (buf2 = 0; buf2 <= 19; buf2++) {
		[manifestHash appendFormat:@"%02X", buf[buf2]];
	}

	// add com.apple.os.update-
	printf("com.apple.os.update-%s\n", [manifestHash UTF8String]);
	return (0);
}
