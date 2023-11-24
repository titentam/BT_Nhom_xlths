function [outputSignal, Fs] =  removeSilence(file)
    % ??c file �m thanh ??u v�o
    outputSignal = [];
    [inputSignal, Fs] = audioread(file);
    frameSize = floor(Fs*(20*0.001)); 
    frames = buffer(inputSignal, frameSize); 
    averageEnergy = mean(sum(frames.^2, 1));
    threshold = averageEnergy;
    
    
    for i=1:size(frames,2)
        if sum(frames(:,i).^2) > threshold
            outputSignal = [outputSignal; frames(:,i)];
        end
    end  
end