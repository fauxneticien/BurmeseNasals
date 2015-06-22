durations_gath <-
    left_join(select(matlab, token_id, total_dur, vl_dur),
              select(meta, token_id, place, voice, tone, condition))

durations_gath %>%
    t.test(total_dur ~ voice, data = .)

durations_gath %>%
    filter(voice == "-",
           vl_dur > 0) %>%
    mutate(total_dur = total_dur - vl_dur) %>%
    rbind(filter(durations_gath, voice == "+")) %>%
    t.test(total_dur ~ voice, data = .)

durations_gath %>%
    filter(voice == "-") %>%
    aov(total_dur ~ condition + tone + place, data = .) %>%
    TukeyHSD

# Means and SDs for Tukey's HSD

durations_gath %>%
    filter(voice == "-") %>%
    group_by(place) %>%
    summarise(durs = mean(total_dur),
              sd = sd(total_dur))

durations_gath %>%
    filter(voice == "-") %>%
    group_by(place) %>%
    summarise(durs = mean(total_dur),
              sd = sd(total_dur))

durations_gath %>%
    filter(voice == "-") %>%
    mutate(vl_present = ifelse(vl_dur == 0, FALSE, TRUE)) %>%
    group_by(condition, vl_present) %>%
    tally %>%
    rbind(data.frame(condition = "-focus", vl_present = TRUE, n = 0)) %>%
    spread(vl_present, n) %>%
    .[,2:3] %>%
    as.matrix %>%
    chisq.test