int sum_pointer(const int *a, int n) {
    int sum = 0;
    const int *end = a + n;

    while (a < end) {
        sum += *a;
        a++;
    }

    return sum;
}
