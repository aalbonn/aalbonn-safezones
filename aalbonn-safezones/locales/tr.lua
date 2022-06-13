local Translations = {
  error = {
    left_zone = 'Güvenli Bölgeden çıktın!',
    cant_use = 'Güvenli Bölgede Silah Kullanamazsın!',
    cant_do = 'Güvenli Bölgede Bunu Yapamazsın',
  },
  success = {
    enter_zone = 'Güvenli Bölgeye girdin!',
  },
  info = {
    safezone_job = 'Güvenli Bölgeye Girdin Fakat %{isismi} Olduğun İçin Seni Etkilemiyor',
  },
}

Lang = Locale:new({
  phrases = Translations,
  warnOnMissing = true,
})