#include "transpose.h"
#include <stdbool.h>

/* The naive transpose function as a reference. */
void transpose_naive(int n, int blocksize, int *dst, int *src) {
    for (int x = 0; x < n; x++) {
        for (int y = 0; y < n; y++) {
            dst[y + x * n] = src[x + y * n];
        }
    }
}

//function confirm domain
bool domain(int x,int y,int n,int x0,int y0){
	if (x+x0 >= n)
		return true;
	if (y+y0 >= n)
		return true;
	return false;
}

//function to translocally
void trans_block(int n,int blocksize, int *dst, int *src,int x0,int y0){
	dst = dst + y0 + x0 * n;
	src = src + x0 + y0 * n;
	for(int x=0;x < blocksize;x++){
		for(int y=0;y<blocksize;y++){
			if (domain(x,y,n,x0,y0))
				continue;
			dst[y + x * n] = src[x + y * n];
		}
	}	



}


/* Implement cache blocking below. You should NOT assume that n is a
 * multiple of the block size. */
void transpose_blocking(int n, int blocksize, int *dst, int *src) {
    // YOUR CODE HERE
	for(int x=0;x<n;x+=blocksize){
		for(int y=0;y<n;y+=blocksize){
			trans_block(n,blocksize,dst,src,x,y);
		}
	}
}
