addpath('/Users/mq20147408/Downloads/NeareyEtAl_FormantMeasurer');
addpath('/Users/mq20147408/Desktop/tg_r_test/egg_dicanio_test');
addpath('/Users/mq20147408/Desktop/egg_voiceless_nasals/boersma_pitch');

base_dir = '/Users/mq20147408/Dropbox/MQ/MRes/SPHL702/Burmese project/data/raw/';

rconn = database('', '', '', 'org.sqlite.JDBC', 'jdbc:sqlite:/Users/mq20147408/Desktop/matlab.sqlite');
curs = exec(rconn, 'select source, token_id, matlab_start, matlab_end from matlab');
curs = fetch(curs);
res = curs.Data;
close(rconn);

error_tokens = {''};

for row = 1:length(res)
    wconn = database('', '', '', 'org.sqlite.JDBC', 'jdbc:sqlite:/Users/mq20147408/Desktop/matlab.sqlite');

    filename = res(row,1);
    token_id = res(row, 2);
    data_start = res(row, 3);
    data_end = res(row, 4);
    
    filepath = strcat(base_dir, filename, '.WAV');
    [y, Fs] = audioread(filepath{1});
    
    [audio_times, audio_data] = chunk_audio(y(:,1), Fs, data_start{1}, data_end{1});
    [egg_times, egg_data] = chunk_audio(y(:,2), Fs, data_start{1}, data_end{1});
    
    try
        formants = NeareyFormantMeasurer(audio_data, Fs, 1, length(audio_data));
    catch
        % if there's an error with the tracker, log the token and skip to
        % the next one
        error_tokens{end+1,:} = token;
        continue
    end
    
    formants(:,1) = formants(:,1) + round(data_start{1} * 1000);

    [time_axis, f0] = BoersmaPitch(audio_data, Fs);
    
    time_axis = time_axis + round(data_start{1} * 1000);
    
    egg_data = smooth(egg_data, 20);
    
    [q_times, cq_oq] = get_cqoq(egg_times * 1000, egg_data, 0);
    
    formant_data = {};
    
    for i = 1:length(formants)
        formant_data{i,1} = token_id{1};
        formant_data{i,2} = formants(i,1);
        formant_data{i,3} = formants(i,2);
        formant_data{i,4} = formants(i,3);
        formant_data{i,5} = formants(i,4);
    end
    
    pitch_data = {};
    
    for i = 1:length(f0)
        pitch_data{i, 1} = token_id{1};
        pitch_data{i, 2} = time_axis(i,1);
        pitch_data{i, 3} = f0(i, 1);
    end
    
    q_data = {};
    
    for i = 1:length(cq_oq)
        q_data{i, 1} = token_id{1};
        q_data{i, 2} = q_times(i, 1);
        q_data{i, 3} = cq_oq(i, 1);
    end
    
    fastinsert(wconn, 'formants', {'token_id', 'time', 'f1', 'f2', 'f3'}, formant_data);
    fastinsert(wconn, 'pitch', {'token_id', 'time', 'f0'}, pitch_data);
    fastinsert(wconn, 'egg', {'token_id', 'time', 'ratio'}, q_data);
    
    close(wconn);
    
    written = token_id
end