/* user and group to drop privileges to */
static const char *user  = "nobody";
static const char *group = "nogroup";

static const char *colorname[NUMCOLS] = {
	[INIT] 			= "black",		/* after initialization */
	[BACKGROUND] 	= "#2d2d2d",	/* after initialization */
	[INPUT]			= "#005577",	/* during input */
	[INPUT_ALT]		= "#227799",	/* during input, second color */
	[FAILED]		= "#CC3333",	/* wrong password */
};

/* lock screen opacity */
static const float alpha = 0.4;

/* treat a cleared input like a wrong password (color) */
static const int failonclear = 1;

/* insert grid pattern with scale 1:1, the size can be changed with logosize */
static const int logosize = 65;
static const int logow = 27;	/* grid width and height for right center alignment*/
static const int logoh = 6;

static XRectangle rectangles[27] = {
	/* x	y	w	h */
	{ -1,	1,	1,	5 },//L
	{ 0,	5,	2,	1 },//L

	{ 3,	2,	1,	3 },//O
	{ 4,	1,	2,	1 },//O
	{ 4,	5,	2,	1 },//O
	{ 6,	2,	1,	3 },//O

	{ 8,	2,	1,	3 },//C
	{ 9,	1,	2,	1 },//C
	{ 9,	5,	2,	1 },//C
	{ 11,	2,	1,	1 },//C
	{ 11,	4,	1,	1 },//C

	{ 14,	1,	1,	5 },//K
	{ 15,	3,	1,	1 },//K
	{ 16,	2,	1,	1 },//K
	{ 16,	4,	1,	1 },//K
	{ 17,	1,	1,	1 },//K
	{ 17,	5,	1,	1 },//K

	{ 19,	1,	1,	5 },//E
	{ 20,	1,	2,	1 },//E
	{ 20,	3,	1,	1 },//E
	{ 20,	5,	2,	1 },//E

	{ 23,	1,	1,	5 },//D
	{ 24,	1,	2,	1 },//D
	{ 24,	5,	2,	1 },//D
	{ 26,	2,	1,	3 },//D

};
