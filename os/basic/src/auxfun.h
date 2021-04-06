// aux.h: Declaration of macros, external function, auxiliary functions, variables (real pointers) and structs
// Macros
#define PROGRAMSTRADDR 	0x7e00

typedef unsigned short size_t;
#define NULL 0
typedef enum { false, true } bool;

// libc
void* memcpy(void *dest, const void *src, size_t n);
void strncpy(char *s1, const char *s2, size_t len);
const char *strchr(const char *str, const char c);
size_t strspn(const char *str, const char *set);
size_t strlen(const char *str);
int atoin(const char *str, size_t len);
const char *strpbrk(const char *str, const char *set);
int strncmp(const char *str1, const char *str2, size_t count);
void* memset(void *ptr, char value, size_t size);
const char* strstr(char *str1, const char *str2);
const char* itoa(int num, char* str, int base);

// KIT
extern void PrintString(char*);
extern void PrintLn();
extern void PrintStringLn(char*);
extern void GetPromptString();
extern void ClearInputBuffer();
extern void ExtendedStore(size_t, unsigned char);
extern unsigned char ExtendedLoad(size_t);
extern void _End();
extern bool CheckEndKey();

extern unsigned short *BasicProgramCounter;

// BASIC program pointer
extern const volatile void *programstr;
extern const volatile void *kernarg;

// Element for listing
typedef struct basicline_list {
	int linen;
	size_t lineoff;		// Including number
	size_t linelen;
} basicline_list_t;