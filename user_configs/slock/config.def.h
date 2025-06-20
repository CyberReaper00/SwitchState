/* user and group to drop privileges to */
static const char *user  = "nobody";
static const char *group = "nogroup";

static const char *colorname[NUMCOLS] = {
	[INIT]		= "#00000066",	/* after initialization */
	[INPUT]		= "#005577",	/* during input */
	[INPUT_ALT]	= "#227799",	/* during input, second color */
	[FAILED]	= "#CC3333",	/* wrong password */
};

/* treat a cleared input like a wrong password (color) */
static const int failonclear = 1;

/* defult message */
static const char *message = "LOCKED";

/* text color */
static const char *text_color = "#FFFFFF";

/* text size */
static const char *font_name = "-misc-fixed-bold-r-normal--13-100-100-100-c-70-iso8859-1";
