load 'test-lib'

teardown() {
    assert_test_home
}

# This is a spike just to test the integration of the passes.
#
@test "All together now!" {
    create_test_home <<.
        .home/AAA/bin/prog                  # directly linked
        .home/AAA/dot/config.inb4           # source file
        .home/BBB/dot/config.inb1           # source file
        .home/BBB/share/data.inb4           # data file not linked into $HOME
.
    run_setup_on_test_home
    diff_test_home_with <<.
        bin/prog -> ../.home/AAA/bin/prog   # direct link
        .home/,inb4/dot/config              # built files
        .home/,inb4/share/data
        .home/_inb4/dot/config              # installed file (directly linked)
        .home/_inb4/share/data              # installed data file
        .config -> .home/_inb4/dot/config   # link to installed file
.
    diff -u - "$test_home/.config" <<. 
Content of .home/BBB/dot/config.inb1
Content of .home/AAA/dot/config.inb4
.
    assert_output ''
}
