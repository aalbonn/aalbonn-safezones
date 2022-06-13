local Translations = {
  error = {
    left_zone = 'You left the Safe Zone!',
    cant_use = 'You Can\'t Use Weapons in the Safe Zone!',
    cant_do = 'You Can\'t Do This In The Safe Zone',
  },
  success = {
    enter_zone = 'You have entered the Safe Zone!',
  },
  info = {
    safezone_job = 'You have entered safezone but it doesn\'t effects you because you\'re %{isismi}',
  },
}

Lang = Locale:new({
  phrases = Translations,
  warnOnMissing = true,
})