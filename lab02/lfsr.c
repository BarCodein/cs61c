#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include "lfsr.h"
uint16_t get_bit(uint16_t x,int n){
	uint16_t a = x;
	for(int i=0;i<n;i++)
		a = a >> 1;
	for(int i=0;i<15;i++)
		a = a << 1;
	for(int i=0;i<15;i++)
		a = a >> 1;
	return a;
}
void set_bit(uint16_t * x,int n,uint16_t v){
	uint16_t sum =0;
	for(int i=15;i>=0;i--){
		uint16_t bit;
		if(n ==i)
			bit = v;
		else
			bit = get_bit(*x,i);
		sum = sum << 1;
		sum = sum | bit;
	}
	*x = sum;
}
void lfsr_calculate(uint16_t *reg) {
    /* YOUR CODE HERE */
	uint16_t a0,a2,a3,a5;
	a0 = get_bit(*reg,0);
	a2 = get_bit(*reg,2);
	a3 = get_bit(*reg,3);
	a5 = get_bit(*reg,5);
	uint16_t bit;
	bit = a0 ^ a2 ^ a3 ^a5;
	*reg = *reg >> 1;
	set_bit(reg,15,bit);
}
