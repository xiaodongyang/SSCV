%%% Illustration of SSCV on the YouTube dataset
close all; clear; clc;

% data information
info.type = 'STIP';
info.sufix = '.stip';
info.ncenter = 500;
info.nstcenter = 5;
info.cls = {'biking', 'diving', 'golf', 'juggle', 'jumping', 'riding', ...
            'shooting', 'spiking', 'swing', 'tennis', 'walk_dog'};
info.ngroup = 25;
info.rate = 20;
info.dirfeat = '..\Feats';
info.dirfrm = '..\Frames';
info.dirvec = '..\SSCV';

% add SPAMS library
addpath('..\SPAMS\build');

% compute visual descriptor words
compSDVBasis(info);

% compute super descriptor vector
compSDV(info);

% compute visual location words
compSLVBasis(info);

% compute super location vector
compSLV(info);
