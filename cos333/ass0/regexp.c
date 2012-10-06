/* Copyright (C) 1999 Lucent Technologies */
/* Excerpted from 'The Practice of Programming' */
/* by Brian W. Kernighan and Rob Pike */

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
/*
 static int grep(char*, FILE*, char*);*/
int match(char *re, char *s, int *start, int *end);
static int matchhere(int, char*, char*, char*, int*, int*);
static int matchstar(int, int, char*, char*, char*, int*, int*);
static int matchqmark(int, int c, char * regexp, char* text, char* starttext,
                int*, int*);
static int matchplus(int, int c, char * regexp, char * text, char * starttext,
                int*, int*);

/* matchhere: search for regexp at beginning of text */
static int matchhere(int aftermeta, char *regexp, char *text, char * starttext,
                int* start, int * end)
{
	int notmeta;
	notmeta = -1;
	/*
	 if ((strcmp(starttext, text) == 0) && ((regexp[0] == '+') || (regexp[0]
	 == '?') || (regexp[0] == '+') || (regexp[0] == '*')))
	 notmeta = 0;
	 */
	if (regexp[0] == '\0') {
		if (*starttext == '\0') {
			*start = 0;
			*end = 0;
			return 1;
		}
		*end = text - starttext;
		return 1;
	}
	if (regexp[1] == '*' && (aftermeta == 0) && notmeta) {
		aftermeta = 1;
		return matchstar(aftermeta, regexp[0], regexp + 2, text,
		                starttext, start, end);
	}
	if (regexp[1] == '?' && (aftermeta == 0) && notmeta) {
		/*if (*text == '\0') {
		 *end = text - starttext;
		 return 1;
		 }*/
		aftermeta = 1;
		return matchqmark(aftermeta, regexp[0], regexp + 2, text,
		                starttext, start, end);
	}
	if (regexp[1] == '+' && (aftermeta == 0) && notmeta) {
		aftermeta = 1;
		return matchplus(aftermeta, regexp[0], regexp + 2, text,
		                starttext, start, end);
	}
	if (regexp[0] == '$' && regexp[1] == '\0') {
		if (*text == '\0') {
			*end = text - starttext;
		}
		return *text == '\0';
	}
	if (*text != '\0' && (regexp[0] == '.' || regexp[0] == *text)) {
		aftermeta = 0;
		return matchhere(aftermeta, regexp + 1, text + 1, starttext,
		                start, end);
	}
	return 0;
}

/* match: search for regexp anywhere in text */
int match(char *regexp, char *text, int *start, int *end)
{

	char * starttext;
	int * index;
	int ret;
	int aftermeta;

	aftermeta = 0;
	if ((regexp == NULL) || (text == NULL) || (start == NULL) || (end
	                == NULL)) {
		return 0;
	}
	index = malloc(sizeof(*index));
	*index = 0;
	starttext = text;
	if (regexp[0] == '^') {
		aftermeta = 0;
		ret = matchhere(aftermeta, regexp + 1, text, starttext, start,
		                end);
		if (ret) {
			*start = 0;
		} else {
			*start = -1;
			*end = -1;
		}
		return ret;
	}
	do { /* must look even if string is empty */
		if (matchhere(aftermeta, regexp, text, starttext, index, end)) {
			*start = *index;
			return 1;
		} else
			(*index)++;
	} while (*text++ != '\0');
	*start = -1;
	*end = -1;
	return 0;
}

/* matchstar: leftmost longest search for c*regexp */
static int matchstar(int aftermeta, int c, char *regexp, char *text,
                char * starttext, int * start, int * end)
{
	char *t;

	for (t = text; *t != '\0' && (*t == c || c == '.'); t++)
		aftermeta = 0;


	do { /* matches zero or more */
		if (matchhere(aftermeta, regexp, t, starttext, start, end)){
			return 1;
		}
	} while (t-- > text);
	return 0;
}

static int matchqmark(int aftermeta, int c, char * regexp, char* text,
                char * starttext, int * start, int * end)
{

	char *t;
	int ret;

	t = text;
/*added*/
	if (*t == '\0') {
		return matchhere(aftermeta, regexp, text, starttext, start, end);
	}
	/*match*/
	if ((*t == c) || (c == '.')) {
		ret = matchhere(aftermeta, regexp, text + 1, starttext, start,
		                end);
		if (ret == 1) {
			/*(*start)++;*/
			return ret;
		} else
			return matchhere(aftermeta, regexp, text, starttext,
			                start, end);
	}
	/* no match*/
	if ((*t != c) && (c != '.')) {

		ret = matchhere(aftermeta, regexp, text + 1, starttext, start,
		                end);
		if (ret == 1) {
			(*start)++;
			return ret;
		} else {
			return matchhere(aftermeta, regexp, text, starttext,
			                start, end);
		}
	}
	return 0;
}

static int matchplus(int aftermeta, int c, char * regexp, char * text,
                char * starttext, int * start, int * end)
{

	char *t;

	t = text;
	if (*t == '\0')
		return 0;
	if ((*t != c) && (c != '.')) {
		return 0; /*failure*/
	}

	t++;

	for (; *t != '\0' && (*t == c || c == '.'); t++)
		;
	do { /* * matches zero or more */
		if (matchhere(aftermeta, regexp, t, starttext, start, end))
			return 1;
	} while (t-- > (c == '.' ? text + 1 : text));
	return 0;

}
