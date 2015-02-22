# From http://stackoverflow.com/questions/370047/#370255
function path_remove() {
  IFS=:
  # convert it to an array
  t=($PATH)
  unset IFS
  # perform any array operations to remove elements from the array
  t=(${t[@]%%$1})
  IFS=:
  # output the new array
  echo "${t[*]}"
}

# Provide access to sys pip
# See: http://hackercodex.com/guide/python-development-environment-on-mac-osx/
syspip(){
   PIP_REQUIRE_VIRTUALENV="" pip "$@"
}