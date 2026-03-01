#include <stdio.h>
#include "bit_ops.h"

// Return the nth bit of x.
// Assume 0 <= n <= 31
unsigned get_bit(unsigned x,
                 unsigned n) {
    // YOUR CODE HERE
    // Returning -1 is a placeholder (it makes
    // no sense, because get_bit only returns 
    // 0 or 1)
	unsigned a = x;
	for(int i=0;i<n;i++)
		a = a >> 1;
	for(int i=0;i<31;i++)
		a = a << 1;
	for(int i=0;i<31;i++)
		a = a >> 1;
	return a;
}
// Set the nth bit of the value of x to v.
// Assume 0 <= n <= 31, and v is 0 or 1
void set_bit(unsigned * x,
             unsigned n,
             unsigned v) {
    // YOUR CODE HERE
	unsigned sum = 0;
	for(int i=31;i>=0;i--){
		unsigned bit;
		if(i==n)
			bit = v;
		else
			bit = get_bit(*x,i);
		sum = sum << 1;
		sum = sum | bit;
	}
	*x = sum;
}
// Flip the nth bit of the value of x.
// Assume 0 <= n <= 31
void flip_bit(unsigned * x,
              unsigned n) {
    // YOUR CODE HERE
	unsigned bit;
	bit = get_bit(*x,n);
	if(bit == 1)
		bit = 0;
	else
		bit = 1;
	set_bit(x,n,bit);
}

