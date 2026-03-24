#include "matrix.h"
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <omp.h>

// Include SSE intrinsics
#if defined(_MSC_VER)
#include <intrin.h>
#elif defined(__GNUC__) && (defined(__x86_64__) || defined(__i386__))
#include <immintrin.h>
#include <x86intrin.h>
#endif

/* Below are some intel intrinsics that might be useful
 * void _mm256_storeu_pd (double * mem_addr, __m256d a)
 * __m256d _mm256_set1_pd (double a)
 * __m256d _mm256_set_pd (double e3, double e2, double e1, double e0)
 * __m256d _mm256_loadu_pd (double const * mem_addr)
 * __m256d _mm256_add_pd (__m256d a, __m256d b)
 * __m256d _mm256_sub_pd (__m256d a, __m256d b)
 * __m256d _mm256_fmadd_pd (__m256d a, __m256d b, __m256d c)
 * __m256d _mm256_mul_pd (__m256d a, __m256d b)
 * __m256d _mm256_cmp_pd (__m256d a, __m256d b, const int imm8)
 * __m256d _mm256_and_pd (__m256d a, __m256d b)
 * __m256d _mm256_max_pd (__m256d a, __m256d b)
*/

/*
 * Generates a random double between `low` and `high`.
 */
double rand_double(double low, double high) {
    double range = (high - low);
    double div = RAND_MAX / range;
    return low + (rand() / div);
}

/*
 * Generates a random matrix with `seed`.
 */
void rand_matrix(matrix *result, unsigned int seed, double low, double high) {
    srand(seed);
    for (int i = 0; i < result->rows; i++) {
        for (int j = 0; j < result->cols; j++) {
            set(result, i, j, rand_double(low, high));
        }
    }
}

/*
 * Allocate space for a matrix struct pointed to by the double pointer mat with
 * `rows` rows and `cols` columns. You should also allocate memory for the data array
 * and initialize all entries to be zeros. Remember to set all fieds of the matrix struct.
 * `parent` should be set to NULL to indicate that this matrix is not a slice.
 * You should return -1 if either `rows` or `cols` or both have invalid values, or if any
 * call to allocate memory in this function fails. If you don't set python error messages here upon
 * failure, then remember to set it in numc.c.
 * Return 0 upon success and non-zero upon failure.
 */
int allocate_matrix(matrix **mat, int rows, int cols) {
    if (rows <=0 || cols <= 0)
		return -1;
	struct matrix *demat;
    demat = *mat;
    demat = (matrix *) calloc(1,sizeof(matrix));
	if (demat == NULL)
		return -1;
    demat->cols = cols;
    demat->rows = rows;
	demat->data = (double **) calloc(rows , sizeof(double *));
	if (demat->data == NULL)
		return -1;
	for(int i=0;i<rows;i++){
		*(demat->data+i) = (double *) calloc(cols , sizeof(double));
		if (*(demat->data+i) == NULL)
			return -1;
	}
	demat->is_1d = 0;
	if (cols == 1 || rows == 1)
		demat->is_1d = 1;
	demat->ref_cnt = 1;
	demat->parent = NULL;
	*(mat) = demat;
	return 0;
}

/*
 * Allocate space for a matrix struct pointed to by `mat` with `rows` rows and `cols` columns.
 * This is equivalent to setting the new matrix to be
 * from[row_offset:row_offset + rows, col_offset:col_offset + cols]
 * If you don't set python error messages here upon failure, then remember to set it in numc.c.
 * Return 0 upon success and non-zero upon failure.
 */
int allocate_matrix_ref(matrix **mat, matrix *from, int row_offset, int col_offset,
                        int rows, int cols) {
	int mcols,mrows;
	mcols = from->cols;
	mrows = from->rows;

	if (row_offset <0 || col_offset<0)
		return -1;
	if (rows <= 0 || cols <= 0)
		return -1;
	if (mrows-row_offset-rows<0 || mcols-col_offset-cols<0)
		return -1;
	struct matrix *demat;
    demat = *mat;
    demat = (matrix *) calloc(1,sizeof(matrix));
	if (demat == NULL)
		return -1;
    demat->cols = cols;
    demat->rows = rows;
	demat->data = (double **) calloc(rows , sizeof(double *));
	if (demat->data == NULL)
		return -1;
	for(int i=0;i<rows;i++){
		*(demat->data+i) = (double *) calloc(cols , sizeof(double));
		if (*(demat->data+i) == NULL)
			return -1;
	}
	demat->is_1d = 0;
	if (cols == 1 || rows == 1)
		demat->is_1d = 1;
	for(int i=0;i<rows;i++){
		int x=row_offset+i;
		*(demat->data+i) = *(from->data+x);
	}
	demat->parent = from;
	from->ref_cnt += 1;
	*mat = demat;
	return 0;
}
void deallocate_matrix_helper(matrix *mat){
	if (mat==NULL)
		return;
	
	if (mat->ref_cnt!=0)
		return;

	if (mat->ref_cnt==0 && mat->parent==NULL){
		for(int i=0;i<mat->rows;i++)
			free(*(mat->data+i));
		free(mat->data);
		free(mat);
		return;
	}
	((mat->parent)->ref_cnt)--;
	deallocate_matrix_helper(mat->parent);
	free(mat->data);
	free(mat);
}

/*
 * This function will be called automatically by Python when a numc matrix loses all of its
 * reference pointers.
 * You need to make sure that you only free `mat->data` if no other existing matrices are also
 * referring this data array.
 * See the spec for more information.
 */
void deallocate_matrix(matrix *mat) {
	
	if (mat==NULL)
		return;
	(mat->ref_cnt)--;
	if (mat->ref_cnt!=0)
		return;

	if (mat->ref_cnt==0 && mat->parent==NULL){
		for(int i=0;i<mat->rows;i++)
			free(*(mat->data+i));
		free(mat->data);
		free(mat);
		return;
	}
	((mat->parent)->ref_cnt)--;
	deallocate_matrix_helper(mat->parent);
	free(mat->data);
	free(mat);
}

/*
 * Return the double value of the matrix at the given row and column.
 * You may assume `row` and `col` are valid.
 */
double get(matrix *mat, int row, int col) {
	double result;
	result = *((*(mat->data+row))+col);
	return result;
}

/*
 * Set the value at the given row and column to val. You may assume `row` and
 * `col` are valid
 */
void set(matrix *mat, int row, int col, double val) {
	*(*(mat->data+row)+col) = val;
}

/*
 * Set all entries in mat to val
 */
void fill_matrix(matrix *mat, double val) {
	for(int i=0;i<mat->rows;i++)
		for(int j=0;j<mat->cols;j++)	
			*(*(mat->data+i)+j) = val;
			
}

/*
 * Store the result of adding mat1 and mat2 to `result`.
 * Return 0 upon success and a nonzero value upon failure.
 */
int add_matrix(matrix *result, matrix *mat1, matrix *mat2) {
	int rows = mat1->rows;
	int cols = mat1->cols;
	for(int i=0;i<rows;i++)
		for(int j=0;j<cols;j++){
			int a,b;
			a = get(mat1,i,j);
			b = get(mat2,i,j);
			set(result,i,j,a+b);
		}
	return 0;
}

/*
 * Store the result of subtracting mat2 from mat1 to `result`.
 * Return 0 upon success and a nonzero value upon failure.
 */
int sub_matrix(matrix *result, matrix *mat1, matrix *mat2) {
	int rows = mat1->rows;
	int cols = mat1->cols;
	for(int i=0;i<rows;i++)
		for(int j=0;j<cols;j++){
			int a,b;
			a = get(mat1,i,j);
			b = get(mat2,i,j);
			set(result,i,j,a-b);
		}
	return 0;

}

/*
 * Store the result of multiplying mat1 and mat2 to `result`.
 * Return 0 upon success and a nonzero value upon failure.
 * Remember that matrix multiplication is not the same as multiplying individual elements.
 */
int mul_matrix(matrix *result, matrix *mat1, matrix *mat2) {
	int rows = mat1->rows;
	int cols = mat2->cols;
	int num = mat1->cols;
	if (mat1->cols != mat2->rows)
		return -1;
	for(int i=0;i<rows;i++)
		for(int j=0;j<cols;j++){
			int sum=0;
			for(int k=0;k<num;k++){
				int a = get(mat1,i,k);
				int b = get(mat2,k,j);
				sum += a*b;
			}
			set(result,i,j,sum);
		}
	return 0;
}

/*
 * Store the result of raising mat to the (pow)th power to `result`.
 * Return 0 upon success and a nonzero value upon failure.
 * Remember that pow is defined with matrix multiplication, not element-wise multiplication.
 */
int pow_matrix(matrix *result, matrix *mat, int pow) {
	if (mat->rows != mat->cols)
		return -1;
	if (pow == 1){
		matrix *I;
		if (allocate_matrix(&I,mat->rows,mat->cols) == -1)
			return -1;
		for(int i=0;i<mat->rows;i++)
			set(I,i,i,1);
		if (mul_matrix(result,I,mat) == -1)
			return -1;
	}
	else{
		matrix *prere;
		if (allocate_matrix(&prere,mat->rows,mat->cols) == -1)
			return -1;
		
		if ((pow_matrix(prere,mat,pow-1) == -1))
			return -1;
		if ((mul_matrix(result,mat,prere) == -1))
			return -1;
		deallocate_matrix(prere);
	}

	return 0;
}

/*
 * Store the result of element-wise negating mat's entries to `result`.
 * Return 0 upon success and a nonzero value upon failure.
 */
int neg_matrix(matrix *result, matrix *mat) {
	int rows = mat->rows;
	int cols = mat->cols;
	for(int i=0;i<rows;i++)
		for(int j=0;j<cols;j++){
			int a;
			a = get(mat,i,j);
			set(result,i,j,-a);
		}
	return 0;

}

/*
 * Store the result of taking the absolute value element-wise to `result`.
 * Return 0 upon success and a nonzero value upon failure.
 */
int abs_matrix(matrix *result, matrix *mat) {
	int rows = mat->rows;
	int cols = mat->cols;
	for(int i=0;i<rows;i++)
		for(int j=0;j<cols;j++){
			int a;
			a = get(mat,i,j);
			set(result,i,j,abs(a));
		}
	return 0;
}

