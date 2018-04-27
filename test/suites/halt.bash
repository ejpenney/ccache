SUITE_halt_SETUP() {
    generate_code 1 test.c
    generate_code 2 test1.c
}

SUITE_halt() {
    # -------------------------------------------------------------------------
    TEST "CCACHE_NOHALT_ON_FAILURE"

    # Cache a compilation.
    $CCACHE_COMPILE -c test.c
    expect_stat 'cache hit (preprocessed)' 0
    expect_stat 'cache miss' 1
    rm test.o

    # Easy failure: Make the cache read only...
    chmod -R a-w $CCACHE_DIR

    CCACHE_NOHALT_ON_FAILURE=1 $CCACHE_COMPILE -c test1.c
    status=$?

    # Leave test dir in a clean state after test
    chmod -R +w $CCACHE_DIR 

    if [ $[status] -ne 0 ]; then
	test_failed "Failure to ignore failure"
    fi

    expect_file_exists test1.o


}
