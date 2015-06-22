egg_vtimes <- dbReadTable(conn, "egg_vtimes")

egg_gathered <- left_join(egg_vtimes, select(meta, token_id, place, voice, tone, condition)) %>%
    mutate(contq = (maxcont - clstart)/(opend - clstart))

egg_gathered %>%
  group_by(voice, place, tone, condition, token_id) %>% 
  summarise(mean_contq = mean(contq)) %>%
  aov(mean_contq ~ voice + place + tone + condition, data = .) %>% 
  TukeyHSD

egg_gathered %>%
  group_by(voice, place, tone, condition, token_id) %>% 
  summarise(mean_contq = mean(contq)) %>%
  group_by(voice, condition) %>%
  summarise(gmean_contq = mean(mean_contq),
            sd_contq = sd(mean_contq)) %>% 
  qplot(data = ., x = condition, y = gmean_contq, ymax = gmean_contq + sd_contq, ymin = gmean_contq - sd_contq,
        geom = c("bar", "errorbar"), fill = voice, stat = "identity", position = "dodge", width = 0.5, xlab = "Condtion", ylab = "Contact Quotient (CQ)") +
  theme_bw(base_size = 9) +
  ggtitle("A comparison of an EGG measure in Burmese nasals")

egg_gathered %>%
  group_by(voice, place, tone, condition, token_id) %>% 
  summarise(mean_contq = mean(contq)) %>%
  group_by(voice) %>%
  summarise(gmean_contq = mean(mean_contq),
            sd_contq = sd(mean_contq))

egg_gathered %>%
  group_by(voice, place, tone, condition, token_id) %>% 
  summarise(mean_contq = mean(contq)) %>%
  group_by(condition) %>%
  summarise(gmean_contq = mean(mean_contq),
            sd_contq = sd(mean_contq))