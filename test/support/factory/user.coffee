idx = 0

module.exports = (user={}) ->
  idx++
  defaults =
    name:       "Princess Buttercup #{idx}"
    email:      "buttercup#{idx}@zaozao.com"
    username:   "princess#{idx}"
    password:   'hasbrains'
  return _(user).defaults(defaults)
