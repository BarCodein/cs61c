#include <stddef.h>
#include <stdbool.h>
#include "ll_cycle.h"
#include <stdio.h>
bool next_isnot_null(node *this){
	if(this->next ==NULL)
		return false;
	else
		return true;
}
int ll_has_cycle(node *head) {
    /* your code here */
	if (head==NULL)
		return 0;
	node *turtose,*hare;
	turtose = head;
	hare = head;
    while (true){
		if(next_isnot_null(hare))
			hare = hare->next;
		else
			break;
		if(next_isnot_null(hare))
            hare = hare->next;
        else
            break;
		turtose = turtose->next;
		if(turtose == hare)
			return 1;
	}
    return 0;
}
