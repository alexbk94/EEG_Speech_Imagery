function [nts,m,si,sint] = SubjectFind(subjID)
% Function for easy subject index by same reference as in article
    switch subjID
        case 'Subj1'
            cd ./recordings/FemaleSubjs/Subj1
        case 'Subj2'
            cd ./recordings/FemaleSubjs/Subj2
        case 'Subj3'
            cd ./recordings/FemaleSubjs/Subj3
        case 'Subj4'
            cd ./recordings/FemaleSubjs/Subj4
        case 'Subj5'
            cd ./recordings/FemaleSubjs/Subj5
        case 'Subj6'
            cd ./recordings/FemaleSubjs/Subj6
        case 'Subj7'
            cd ./recordings/MaleSubjs/Subj1
        case 'Subj8'
            cd ./recordings/MaleSubjs/Subj2
        case 'Subj9'
            cd ./recordings/MaleSubjs/Subj3
        case 'Subj10'
            cd ./recordings/MaleSubjs/Subj4
        case 'Subj11'
            cd ./recordings/MaleSubjs/Subj5
        case 'Subj12'
            cd ./recordings/MaleSubjs/Subj6
        case 'Subj13'
            cd ./recordings/MaleSubjs/Subj7
        case 'Subj14'
            cd ./recordings/MaleSubjs/Subj8
        case 'Subj15'
            cd ./recordings/MaleSubjs/Subj9
        case 'Subj16'
            cd ./recordings/MaleSubjs/Subj10
        case 'Subj17'
            cd ./recordings/MaleSubjs/Subj11
    end
    [nts,m,si,sint] = TrialsMerge;
    cd ../../..
end