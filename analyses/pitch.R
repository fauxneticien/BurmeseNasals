source("helpers.R")

pitch <- dbReadTable(conn, "pitch")
pitch_gathered <- left_join(pitch, select(meta, token_id, place, voice, tone, condition))

pitch_gathered %<>%
    group_by(token_id) %>%
    mutate(time_pc = ((max(time) - time)/(max(time) - min(time))) * 100,
           f0_norm = f0 - f0[n()])

pitch_gathered %>%
    group_by(token_id) %>%
    mutate(f0_dabs = abs(c(NA, diff(f0)/diff(time)))) %>%
    group_by(token_id) %>%
    summarise(df0_max = max(f0_dabs, na.rm = TRUE),
              f0_max = max(f0),
              f0_min = min(f0)) %>%
    filter(df0_max < 1,
           f0_max < 300,
           f0_min > 150) -> pitch_ok

pitch_gathered %>%
    semi_join(pitch_ok) %>%
    ggplot(aes(x = time_pc, y = f0, group = token_id)) +
    geom_line(alpha = 0.15, size = 0.5) +
    facet_wrap(tone ~ voice, ncol = 2) +
    stat_smooth(aes(group = voice, colour = tone), size = 0.5) +
    xlab("Duration (%)") +
    ylab("F0 Frequency (Hz)") +
    ggtitle("F0 trajectories of voiced and voiceless nasals") +
    theme_bw(base_size = 9)

pitch_gathered %>%
    semi_join(pitch_ok) %>%
    filter(time_pc >= 75) %>%
    group_by(place, voice, tone, condition, token_id) %>%
    summarise(mean_f0 = mean(f0)) %>%
    group_by(place, voice,tone,condition) %>%
    mutate(rep = 1:n()) %>%
    aov(mean_f0 ~ voice + tone + condition + place, data = .) %>%
    summary

pitch_gathered %>%
  semi_join(pitch_ok) %>%
  filter(time_pc >= 75) %>%
  group_by(voice) %>%
  summarise(mean_f0 = mean(f0), sd_f0 = sd(f0))