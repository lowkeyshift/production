node default {
  include base
}

node "agent-01.hsd1.ma.comcast.net" {
  include base, website-02
}

#node "agent-02.hsd1.ma.comcast.net" {
#  include website-02
#}
