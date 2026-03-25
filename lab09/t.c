#include <stdio.h>
#include <emmintrin.h>
#include <immintrin.h>

void add_epi32_sse(int32_t *a,int32_t *b,size_t n){
	size_t i=0;
	for(;i+4<=n;i+=4){
		__m128i vec_a = _mm_load_si128((__m128i*)&a[i]);
		__m128i vec_b = _mm_load_si128((__m128i*)&b[i]);
		vec_a = _mm_add_epi32(vec_a,vec_b);
		_mm_store_si128((__m128i*)&a[i],vec_a);
	}
	for(int j=0;j<i;j++)
		printf("%d ",a[j]);
}
int main(){
	int a[8] = {0,-1,-2,3,4,5,6,7};
	int b[8] = {0,1,2,3,4,5,6,7};
	add_epi32_sse(a,b,8);
	return 0;
}
