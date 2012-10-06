#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int match(char *re, char *s, int *start, int *end);
static int grep2(char *regexp, FILE *f, char *name);


/* grep main: search for regexp in files */
int main(int argc, char *argv[])
{
	int i, nmatch;
	FILE *f;

	if (argc < 2)
		printf("usage: grep regexp [file ...]");
	nmatch = 0;
	if (argc == 2) {
		if (grep2(argv[1], stdin, NULL))
			nmatch++;
	} else {
		for (i = 2; i < argc; i++) {
			f = fopen(argv[i], "r");
			if (f == NULL) {
				printf("can't open %s:", argv[i]);
				continue;
			}
			if (grep2(argv[1], f, argc > 3 ? argv[i] : NULL) > 0)
				nmatch++;
			fclose(f);
		}
	}
	return nmatch == 0;
}

/* grep: search for regexp in file */
static int grep2(char *regexp, FILE *f, char *name)
{
	int n, nmatch;
	int * start, *end;
	char buf[BUFSIZ];
	/*char * regexp1 = "?*?*";*/
	start = (int *) malloc(sizeof(*start));
	end = (int *) malloc(sizeof(*end));
	nmatch = 0;
	while (fgets(buf, sizeof buf, f) != NULL) {
		n = strlen(buf);
		if (n > 0 && buf[n - 1] == '\n')
			buf[n - 1] = '\0';
		if (match(regexp, buf, start, end)) {
			nmatch++;
			if (name != NULL)
				printf("%s:", name);
			printf("%s\n", buf);

		}
		printf("%d %d\n", *start, *end);
		fflush(NULL);
	}
	return nmatch;
}
