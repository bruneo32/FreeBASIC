// aux.c: Definition of auxiliary funcions
#include "auxfun.h"

// Globals
const volatile void *programstr = (const volatile void *)PROGRAMSTRADDR;

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

size_t strlen(const char *str) {
    size_t i = 0; 
    while (str[i]) { i++; }
    return i;
}

int atoin(const char *str, size_t len) {
	int t = 0;
	for (int i = 0; str[i] != '\0' && i < len; ++i)
        t = t * 10 + str[i] - '0';
	return t;
}

const char *strpbrk(const char *str, const char *set) {
	size_t i = 0;
	while (str[i]) {
		size_t j = 0;
		while (set[j]) {
			if (str[i] == set[j]) return str + i;
			++j;
		}
		++i;
	}
	return NULL;
}