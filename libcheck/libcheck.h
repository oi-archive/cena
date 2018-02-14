#ifndef _LIBCHECK_H
#define _LIBCHECK_H

FILE *std, *rep;
double fsco;

void Score(double score)
{
	FILE *f;
	f = fopen("score.log", "w");
	fprintf(f, "%lf\n", score);
	fclose(f);
}








#endif