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

int strncmp(const char *str1, const char *str2, size_t count) {
	int t = 0;
	for (size_t i = 0; i < count; i++) {
		t += str1[i] - str2[i];
	}
	return t;
}

void* memset(void *ptr, char value, size_t size) {
	for (size_t i = 0; i < size; ++i)
		((char*)ptr)[i] = value;

	return ptr;
}

int compare(const char *X, const char *Y) {
    while (*X && *Y)
    {
        if (*X != *Y)
            return 0;
        X++;
        Y++;
    }
    return (*Y == '\0');
}

const char* strstr(char *str1, const char *str2) {
	while (*str1 != '\0') {
        if ((*str1 == *str2) && compare(str1, str2))
            return str1;
        str1++;
    }
    return NULL;
}

void swap(char *c1, char *c2) {
	char t = *c1;
	*c1 = *c2;
	*c2 = t;
}

void reverse(char *str, int length) {
    int start = 0;
    int end = length -1;
    while (start < end)
    {
        swap(str+start, str+end);
        start++;
        end--;
    }
}

const char* itoa(int num, char* str, int base) {
	int i = 0;
    bool isNegative = false;
  
    if (num == 0) {
        str[i++] = '0';
        str[i] = '\0';
        return str;
    }
    if (num < 0 && base == 10) {
        isNegative = true;
        num = -num;
    }
  
    while (num != 0) {
        int rem = num % base;
        str[i++] = (rem > 9)? (rem-10) + 'a' : rem + '0';
        num = num/base;
    }
  
    if (isNegative)
        str[i++] = '-';
  
    str[i] = '\0';
    reverse(str, i);
    return str;
}