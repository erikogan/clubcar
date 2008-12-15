function finish_save(basename) {
  saved = basename + "_saved"
  $(basename + "_spinner").hide()
  Nifty("#" + saved, "small transparent")
  new Effect.Appear(saved, {duration: 0.3});
  new Effect.Fade(saved, {duration: 0.3, delay: 5.3});
  new Effect.Highlight(saved)
}