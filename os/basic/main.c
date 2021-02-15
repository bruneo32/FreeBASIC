// main.c: interpreter main

// Macros
#define PROGRAMSTRADDR 	0xaa00

typedef unsigned short size_t;
#define NULL 0
typedef enum { false, true } bool;

// ==================================== GENERAL ====================================

// Aux libc

void* memcpy(void *dest, const void *src, size_t n) {
	for (int i = 0; i < n; ++i) {
		((char*)dest)[i] = ((const char*)src)[i];
	}
	return dest;
}

void strncpy(char *s1, const char *s2, size_t len) {
	for (int i = 0; i < len; ++i) {
		s1[i] = s2[i];
	}
}

const char *strchr(const char *str, const char c) {
	size_t i = 0;
	while (str[i] != c) {
		if (str[i] == '\0') return NULL;
		i++;
	}
	return (char*)str + i;
}


size_t strspn(const char *str, const char *set) {
	size_t t = 0;
	size_t i = 0;
	bool c = false;
	while (str[i] != '\0') {
		size_t j = 0;
		c = false;
		while (set[j] != '\0') {
			if (str[i] == set[j]) { c = true; break; }
			j++;
		}
		if (c) { t++; }
		else return t;
		i++;
	}
	return t;
}

int atoin(const char *str, size_t len) {
	int t = 0;
	for (int i = 0; str[i] != '\0' && i < len; ++i)
        t = t * 10 + str[i] - '0';
	return t;
}

// KIT
extern void PrintString(char*);
extern void PrintLn();
extern void PrintStringLn(char*);
extern void GetPromptString();
extern void ClearInputBuffer();
extern void ExtendedStore(short, char);
extern char ExtendedRead();

// ==================================== SPECIFIC ====================================

// BASIC program pointer
volatile void *programstr = (volatile void*)PROGRAMSTRADDR;

// Element for listing
typedef struct basicline_list {
	int linen;
	const char *line;		// Including number
	size_t linelen;
} basicline_list_t;

// Aux extended memory

void extmemread(void *to, size_t size, size_t extoffset) {
	for (size_t i = 0; i < size; i++) {
		((char*)to)[i] = ExtendedRead(extoffset + i);
	}
}

void extmemwrite(const void *from, size_t size, size_t extoffset) {
	for (size_t i = 0; i < size; i++) {
		ExtendedStore(extoffset + i, ((const char*)from)[i]);
	}
}

// List helpers
basicline_list_t readelement_list(size_t idx) {
	basicline_list_t elem;
	extmemread((void*)&elem, sizeof(basicline_list_t), idx * sizeof(basicline_list_t));
	return elem;
}

void writeelement_list(basicline_list_t elem, size_t idx) {
	extmemwrite((const void*)&elem, sizeof(basicline_list_t), idx * sizeof(basicline_list_t));
}

// ==================================== MAIN ====================================

void list() {
	// Write array to extended memory
	char *str = (char*)programstr;
	size_t idx = 0;
	
	while (str[0] != '\0' && str[0] != '\r') {
		basicline_list_t line;

		// 10 PRINT "XD"  ; Line number "10"
		size_t lnumlen = strspn(str, "1234567890");
		line.linen = atoin(str, lnumlen);

		size_t llen = strchr(str, '\r') - str;
		line.line = (const char*)str;
		line.linelen = llen;

		writeelement_list(line, idx);
		idx++;
		str += llen + 1;
	}
	
	// Bubble sort
	for (int i = 0; i < idx - 1; i++) {
		basicline_list_t t1;
		t1 = readelement_list(i);
		basicline_list_t t2;
		t2 = readelement_list(i + 1);
		
		if (t1.linen > t2.linen) {
			writeelement_list(t2, i);
			writeelement_list(t1, i + 1);
		}
	}
	
	// Print listing
	for (int i = 0; i < idx; i++) {
		basicline_list_t t1;
		t1 = readelement_list(i);
		char linestr[300];
		memcpy(linestr, t1.line, t1.linelen);
		linestr[t1.linelen] = '\0';
		PrintStringLn(linestr);
	}
}

void interpret() {
	//PrintStringLn("interpretando :)");
	PrintLn();
}
