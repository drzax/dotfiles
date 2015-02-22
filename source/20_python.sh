# Provide access to sys pip
# See: http://hackercodex.com/guide/python-development-environment-on-mac-osx/
syspip(){
   PIP_REQUIRE_VIRTUALENV="" pip "$@"
}