formants_gath <- left_join(formants, select(meta, token_id, place, voice, tone, condition))

formants_gath <- formants_gath %<>%
  group_by(token_id) %>%
  mutate(time_pc = ((max(time) - time)/(max(time) - min(time))) * 100)

formants_gath %>%
    group_by(token_id) %>%
    mutate(f1_dabs = abs(c(NA, diff(f1)/diff(time))),
           f2_dabs = abs(c(NA, diff(f2)/diff(time))),
           f3_dabs = abs(c(NA, diff(f3)/diff(time)))) %>%
    group_by(token_id) %>%
    summarise(df1_max = max(f1_dabs, na.rm = TRUE),
              df2_max = max(f2_dabs, na.rm = TRUE),
              df3_max = max(f3_dabs, na.rm = TRUE),
              f1_max = max(f1),
              f2_max = max(f2),
              f3_max = max(f3),
              f1_min = min(f1),
              f2_min = min(f2),
              f3_min = min(f3)) %>%
    filter(df1_max < 15,
           df2_max < 30,
           df3_max < 45,
           f1_max < 400,
           f2_max < 2750,
           f3_max < 3600,
           f1_min > 200,
           f1_min > 200) -> formants_ok

formants_gath %>%
    semi_join(formants_ok) %>%
    gather("formant", "val", f1:f3) %>%
    ggplot(aes(x = time_pc, y = val, group = token_id)) +
    geom_line(alpha = 0.15) +
    facet_wrap(voice ~ formant, ncol = 3, scales = "free_y") +
    stat_smooth(aes(group = place, colour = place), size = 0.5) +
    xlab("Duration (%)") +
    ylab("Frequency (Hz)") +
    ggtitle("Formant trajectories of voiced and voiceless nasals") +
    theme_bw(base_size = 8)

formants_gath %>%
    semi_join(formants_ok) %>%
    filter(time_pc >= 25,
           time_pc <= 75) %>%
    group_by(place, voice, tone, condition, token_id) %>%
    summarise_each(funs(mean), f1:f3) %>%
    aov(f3 ~ voice + place + condition + tone, data = .) %>%
    summary


formants_gath %>%
    semi_join(formants_ok) %>%
    filter(time_pc >= 25,
           time_pc >= 75,
           voice == "-") %>%
    group_by(place, voice, tone, condition, token_id) %>%
    summarise(mean_f2 = mean(f2)) %>%
    group_by(place, voice,tone,condition) %>%
    mutate(rep = 1:n()) %>%
    lmer(mean_f2 ~ tone + condition + place + (1|rep), data = .) %>%
    summary