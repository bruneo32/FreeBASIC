// main.c: interpreter main
#include "auxfun.h"

// ==================================== MAIN ====================================

void sortProgram() {
	char *base = (char*)programstr;
	char *str = (char*)programstr;

	if (str[0] == '\0') return;
	size_t idx = 0;

	bool cont = true;
	while (cont) {
		cont = false;
		str = base;

		while (*str) {
			// Get 2 lines
			basicline_list_t t1;
			size_t lnumlen = strspn(str, "1234567890");
			t1.linen = atoin(str, lnumlen);

			size_t llen = strchr(str, '\r') - str;
			t1.lineoff = (const char*)str - (const char*)programstr;
			t1.linelen = llen;

			idx++;
			str += llen + 1;

			if (*str == '\0') break;

			basicline_list_t t2;
			lnumlen = strspn(str, "1234567890");
			t2.linen = atoin(str, lnumlen);

			llen = strchr(str, '\r') - str;
			t2.lineoff = (const char*)str - (const char*)programstr;
			t2.linelen = llen;

			// Compare 2 lines
			char temp1[300];
			char temp2[300];
			if (t1.linen > t2.linen) {
				// Swap
				memcpy(temp1, base + t1.lineoff, t1.linelen + 1);
				temp1[t1.linelen + 1] = '\0';
				memcpy(temp2, base + t2.lineoff, t2.linelen + 1);
				temp2[t2.linelen + 1] = '\0';
				memcpy(base + t1.lineoff + t2.linelen + 1, temp1, t1.linelen);
				memcpy(base + t1.lineoff, temp2, t2.linelen + 1);
				str = base + t2.lineoff + t2.linelen + 1;
				cont = true;
			}
		}
	}

	str = base;

	cont = true;
	while (cont) {
		cont = false;
		str = base;

		while (*str) {
			// Get 2 lines
			basicline_list_t t1;
			size_t lnumlen = strspn(str, "1234567890");
			t1.linen = atoin(str, lnumlen);

			size_t llen = strchr(str, '\r') - str;
			t1.lineoff = (const char*)str - (const char*)programstr;
			t1.linelen = llen;

			idx++;
			str += llen + 1;

			if (*str == '\0') break;

			basicline_list_t t2;
			lnumlen = strspn(str, "1234567890");
			t2.linen = atoin(str, lnumlen);

			llen = strchr(str, '\r') - str;
			t2.lineoff = (const char*)str - (const char*)programstr;
			t2.linelen = llen;

			// Compare 2 lines
			if (t1.linen == t2.linen) {
				// Delete first
				memcpy(base + t1.lineoff, base + t2.lineoff, strlen(base + t2.lineoff) + 1);
				cont = true;
			}
		}
	}

	str = base;

	while (*str) {
		// Get line
		basicline_list_t t;
		size_t lnumlen = strspn(str, "1234567890");
		t.linen = atoin(str, lnumlen);

		size_t llen = strchr(str, '\r') - str;
		t.lineoff = (const char*)str - (const char*)programstr;
		t.linelen = llen;

		//const char *lend = _strchr(base + t.lineoff + lnumlen, '\r');

		const char *k = strpbrk(base + t.lineoff + lnumlen, "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890\r");

		if (*k == '\r') {
			memcpy(base + t.lineoff, k + 1, strlen(k + 1) + 1);
		}
		else {
			str += llen + 1;
		}
	}

	str = base;
}

void list() {
	// Sort
	sortProgram();

	char *base = (char*)programstr;
	char *str = (char*)programstr;
	const char *arg = (const char*)kernarg;

	if (str[0] == '\0') return;

	// Print
	while (*str) {
		// Get line
		basicline_list_t t;
		size_t lnumlen = strspn(str, "1234567890");
		t.linen = atoin(str, lnumlen);

		size_t llen = strchr(str, '\r') - str;
		t.lineoff = (const char*)str - (const char*)programstr;
		t.linelen = llen;

		str += llen + 1;

		char temp[300];
		memcpy(temp, base + t.lineoff, t.linelen);
		temp[t.linelen] = '\0';

		if (*arg) {															// "*"
			size_t leftnumlen = strspn(arg, "1234567890");

			if (leftnumlen) {												//		starting with num, "x" "x-" "x-x"
				size_t leftnum = atoin(arg, leftnumlen);

				if (*(arg + leftnumlen) == '-') {							//			'-' follows, "x-" "x-x"
					size_t rightnumlen = strspn(arg + leftnumlen + 1, "1234567890");

					if (rightnumlen) {										//				ending with num, "x-x"
						size_t rightnum = atoin(arg + leftnumlen + 1, rightnumlen);

						if (t.linen >= leftnum && t.linen <= rightnum) PrintStringLn(temp);
					}
					else {													//				"x-"
						if (t.linen >= leftnum) PrintStringLn(temp);
					}
				}
				else {														//			"x"
					if (t.linen == leftnum) PrintStringLn(temp);
				}
			}
			else {															//		"-x"
				size_t rightnumlen = strspn(arg + 1, "1234567890");
				size_t rightnum = atoin(arg + 1, rightnumlen);

				if (t.linen <= rightnum) PrintStringLn(temp);
			}
		}
		else {																//	""
			PrintStringLn(temp);
		}
	}

	*BasicProgramCounter = (unsigned short)(base + strlen(base));
}

void toUppercase() {
	char *str = (char*)programstr;
	while (*str) {
		if (*str == 'a') *str = 'A';
		if (*str == 'b') *str = 'B';
		if (*str == 'c') *str = 'C';
		if (*str == 'd') *str = 'D';
		if (*str == 'e') *str = 'E';
		if (*str == 'f') *str = 'F';
		if (*str == 'g') *str = 'G';
		if (*str == 'h') *str = 'H';
		if (*str == 'i') *str = 'I';
		if (*str == 'j') *str = 'J';
		if (*str == 'k') *str = 'K';
		if (*str == 'l') *str = 'L';
		if (*str == 'm') *str = 'M';
		if (*str == 'n') *str = 'N';
		if (*str == 'o') *str = 'O';
		if (*str == 'p') *str = 'P';
		if (*str == 'q') *str = 'Q';
		if (*str == 'r') *str = 'R';
		if (*str == 's') *str = 'S';
		if (*str == 't') *str = 'T';
		if (*str == 'u') *str = 'U';
		if (*str == 'v') *str = 'V';
		if (*str == 'w') *str = 'W';
		if (*str == 'x') *str = 'X';
		if (*str == 'y') *str = 'Y';
		if (*str == 'z') *str = 'Z';
		++str;
	}
}

void interpret() {
	sortProgram();
	toUppercase();

	char *str = (char*)programstr;

	while (*str) {		
		size_t numlen = strspn(str, "1234567890");
		//size_t linen = atoin(str, numlen);
		
		if (CheckEndKey()) {
			char msg[100] = "BREAK AT LINE ";	// next 21
			strncpy(msg + 21, str, numlen);
			msg[21 + numlen] = '\0';
			PrintStringLn(msg);
			_End();
		}

		char *inst = str + numlen + 1;
		if (strncmp(inst, "PRINT", 5) == 0) {
			char toprint[300];
			const char *start = strchr(inst, '\"');
			size_t size = strchr(start + 1, '\"') - start - 1;
			memcpy(toprint, start + 1, size);
			//toprint[size + 1] = '\r';
			toprint[size] = '\0';
			PrintStringLn(toprint);
			memset(toprint, 0, 300);

			str = (char*)strchr(str, '\r') + 1;
		} else if (strncmp(inst, "INPUT", 5) == 0) {
			GetPromptString();
			str = (char*)strchr(str, '\r') + 1;
		} else if (strncmp(inst, "GOTO", 4) == 0) {
			char num[16];
			char *arg = (char*)strpbrk(inst, "1234567890");
			size_t arglen = strspn(arg, "1234567890");
			strncpy(num, arg, arglen);
			num[arglen] = '\0';
			str = (char*)strstr((char*)programstr, num);
		} else if (strncmp(inst, "END", 3) == 0) {
			_End();
		} else {
			char msg[100] = "SYNTAX ERROR AT LINE ";	// next 21
			strncpy(msg + 21, str, numlen);
			msg[21 + numlen] = '\0';
			PrintStringLn(msg);
			_End();
		}
	}

	_End();
}
