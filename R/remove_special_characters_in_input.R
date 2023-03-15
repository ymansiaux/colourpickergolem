remove_special_characters_in_input <- function(x) {
  x %>%
    gsub(x = .,
         pattern = " ",
         replacement = "_espacevide_") %>%
    gsub(x = .,
         pattern = "\\(",
         replacement = "_parentheseouverte_") %>%
    gsub(x = .,
         pattern = "\\)",
         replacement = "_parenthesefermee_")
  # peut etre d'autres cas de figure ...

}
