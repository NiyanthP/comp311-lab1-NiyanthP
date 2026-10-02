int sum_indexed(const int *a, int n) {
    int sum = 0;

    for (int i = 0; i < n; i+=2) {
        sum += a[i];
        sum += a[i + 1];
    }

    return sum;
}
