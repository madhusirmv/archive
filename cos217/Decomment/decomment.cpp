#include <stdio.h>
#include <ctype.h>

enum Statetype  {NORMAL,SLASH,COMMENT,STAR,SQUOTE,DQUOTE}
/* TO DO
implement line count -- is a new line character one character or two?
implement unterminated error message
add new lines in comment to preserve line numbering
new line characters in string and character constants

*/

/* some code taken from lecture slides*/

enum Statetype handleNormalState(int c) {
	enum Statetype state;

	if (c == '/') state = SLASH;

	else if (c == '\''){
		putchar(c);
		state = SQUOTE;
	}

	else if (c == '\"'){
		putchar(c);
		state = DQUOTE;
	}

	else {
		putchar(c);
		state = NORMAL;
	}

	return state;
}

enum Statetype handleSlashState(int c) {
	enum Statetype state;

	if (c == '/') {
		putchar(c);
		state = SLASH;
	}

	else if (c == '*') {
		state = COMMENT;
	}

	else {
		putchar('/');
		putchar(c);
		state = NORMAL;
	}
	return state;
}

enum Statetype handleCommentState(int c) {
	enum Statetype state;

	if (c == '*') {
		state = STAR;
	}

	else{
		state = COMMENT;
	}
	return state;
}

enum Statetype handleStarState(int c) {
	enum Statetype state;

	if (c == '*') {
		state = STAR;
	}

	else if (c == '/') {
		putchar(' ');
		state = NORMAL;
	}

	else {
		state = COMMENT;
	}

	return state;
}

enum Statetype handleSquoteState(int c) {
	enum Statetype state;

	if (c == '\'') {
		putchar(c);
		state = NORMAL;
	}

	else {
		putchar(c);
		state = SQUOTE;
	}
	return state;
}

enum Statetype handleDquoteState(int c) {
	enum Statetype state;

	if (c == '\"') {
		putchar(c);
		state = NORMAL;
	}

	else {
		putchar(c);
		state = DQUOTE;
	}
	return state;
}



int main(void) {
	int c;
	int count;
	count = 0;
	enum Statetype state;
		state = NORMAL;
	for ( ; ; ) {
		c = getchar();
		if (c == EOF) break;
		switch (state) {
		case NORMAL:
			state = handleNormalState(c);
			break;
		case SLASH:
			state = handleSlashState(c);
			break;
		case COMMENT:
			state = handleCommentState(c);
			break;
		case STAR:
			state = handleStarState(c);
			break;
		case SQUOTE:
			state = handleSquoteState(c);
			break;
		case DQUOTE:
			state = handleDquoteState(c);
			break;
		default:
			/* return error message*/
		}
	}
}

