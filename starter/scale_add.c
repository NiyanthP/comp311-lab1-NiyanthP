int scale_add(int x) {
    int result = 0;

    for (int i = 0; i < 8; i++) {
        result += x;
    }

    return result;
}
