#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdarg.h>

typedef struct {
    int tag;
    char content[0];
} string_t;

typedef struct {
    int tag;
    int content[0];
} arr_t;

extern int read() {
    int d;
    printf("> ");
    scanf("%d", &d);
    return d;
}

extern int write(int x) {
    printf("%d\n", x);
    return 0;
}

extern string_t * str_make(int n, int c) {
    string_t *s = malloc(4 + n);
    s->tag = n;
    memset(s->content, c, n);
    return s;
}

extern string_t * str_set(string_t *s, int i, int c) {
    s->content[i] = c;
    return s;
}

extern int str_get(string_t *s, int i) {
    return s->content[i];
}

extern string_t * str_dup(string_t *s) {
    int size = s->tag + 4;
    string_t *copy = malloc(size);
    memcpy(copy, s, size);
    return copy;
}

extern string_t * str_cat(string_t *s1, string_t *s2) {
    int res_length = s1->tag + s2->tag;
    string_t *res = malloc(4 + res_length);
    
    res->tag = res_length;
    memcpy(res->content,           s1->content, s1->tag);
    memcpy(res->content + s1->tag, s2->content, s2->tag);

    return res;
}

extern int str_cmp(string_t *s1, string_t *s2) {
    int min_length = s1->tag <= s2->tag ? s1->tag : s2->tag;

    for (int i = 0; i < min_length; i++) {
        if (s1->content[i] < s2->content[i]) {
            return -1;
        }
        if (s1->content[i] > s2->content[i]) {
            return 1;
        }
    }

    if (s1->tag < s2->tag) {
        return -1;
    }
    if (s1->tag > s2->tag) {
        return 1;
    }
    return 0;
}

extern int str_len(string_t *s) {
    return s->tag;
}

extern string_t * str_sub(string_t *s, int i, int l) {
    string_t *res = malloc(4 + l);

    res->tag = l;
    memcpy(res->content, s->content + i, l);

    return res;
}

extern string_t * str_read() {
    char *buf = malloc(1 << 24);
    char c;
    int len = 0;

    printf("> ");
    while ((c = getchar()) != '\n') {
        buf[len++] = c;
    }

    string_t *res = malloc(4 + len);
    res->tag = len;
    memcpy(res->content, buf, len);

    free(buf);

    return res;
}

extern int str_write(string_t *s) {
    for (int i = 0; i < s->tag; i++) {
        putchar(s->content[i]);
    }
    putchar('\n');

    return 0;
}

extern arr_t * arrcreate(int n, ...) {
    arr_t *arr = malloc(4 + 4 * n);
    arr->tag = (1 << 24) + n;
    va_list elements;

    va_start(elements, n);

    for (int i = 0; i < n; i++) {
        arr->content[i] = va_arg(elements, int);
    }

    va_end(elements);

    return arr;
}

extern arr_t * Arrcreate(int n, ...) {
    arr_t *arr = malloc(4 + 4 * n);
    arr->tag = (2 << 24) + n;
    va_list elements;

    va_start(elements, n);

    for (int i = 0; i < n; i++) {
        arr->content[i] = va_arg(elements, int);
    }

    va_end(elements);

    return arr;
}

extern int arrget(arr_t *arr, int ind) {
    return arr->content[ind];
}

extern int arrset(int n, arr_t *arr, int value, ...) {
    va_list indices;
    va_start(indices, value);

    while (n-- > 1) {
        arr = (arr_t *)arrget(arr, va_arg(indices, int));
    }

    arr->content[va_arg(indices, int)] = value;
    return 0;
}

extern int arrlen(arr_t *a) {
    return a->tag & ((1 << 24) - 1);
}

extern arr_t * arrmake(int n, int v) {
    arr_t *a = malloc(4 + 4 * n);
    a->tag = (1 << 24) + n;
    
    for (int i = 0; i < n; i++) {
        a->content[i] = v;
    }

    return a;
}

extern arr_t * Arrmake(int n, int v) {
    arr_t *a = malloc(4 + 4 * n);
    a->tag = (2 << 24) + n;
    
    for (int i = 0; i < n; i++) {
        a->content[i] = v;
    }

    return a;
}
