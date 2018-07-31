algorithm()
(
  echo $( echo -n $1 | sha1sum | awk '{print $1}' ) # use sha512sum for longer hash or any other
)
