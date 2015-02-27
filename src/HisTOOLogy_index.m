function varargout = HisTOOLogy_index(varargin)
% HISTOOLOGY_INDEX MATLAB code for HisTOOLogy_index.fig
%      HISTOOLOGY_INDEX, by itself, creates a new HISTOOLOGY_INDEX or raises the existing
%      singleton*.
%
%      H = HISTOOLOGY_INDEX returns the handle to a new HISTOOLOGY_INDEX or the handle to
%      the existing singleton*.
%
%      HISTOOLOGY_INDEX('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HISTOOLOGY_INDEX.M with the given input arguments.
%
%      HISTOOLOGY_INDEX('Property','Value',...) creates a new HISTOOLOGY_INDEX or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before HisTOOLogy_index_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to HisTOOLogy_index_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help HisTOOLogy_index

% Last Modified by GUIDE v2.5 18-Dec-2014 16:42:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @HisTOOLogy_index_OpeningFcn, ...
                   'gui_OutputFcn',  @HisTOOLogy_index_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before HisTOOLogy_index is made visible.
function HisTOOLogy_index_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to HisTOOLogy_index (see VARARGIN)
global olddir;

% Choose default command line output for HisTOOLogy_index
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes HisTOOLogy_index wait for user response (see UIRESUME)
% uiwait(handles.figure1);
olddir = pwd;    %directory di hisTOOLogy index


% --- Outputs from this function are returned to the command line.
function varargout = HisTOOLogy_index_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global work_image;
global orig_image;

global datamatrixglobale;
global pathname;
global filename;
global olddir;
global area_pixel;


cd(olddir)

[filename, pathname] = uigetfile({'*.jpg;*.tif;*.png;*.gif;*.bmp'}, 'Pick an image');
str_im = strcat(pathname, filename);    %complete directory    
orig_image = imread(str_im);

work_image = orig_image;

axes(handles.a_image)
imshow(orig_image)

area_pixel = 1;    %nel caso non si inseriscano dati sull'ingrandimento dell'immagine

%data storing
datamatrixglobale = cell(2, 5);

datamatrixglobale(1, :) = {'Filename ', 'Pathname ', 'Magnification ', 'Image Area ', 'ROI area '};
datamatrixglobale(2, :) = {filename,  pathname, '', (size(orig_image, 1)*size(orig_image, 2)), (size(orig_image, 1)*size(orig_image, 2))};

cd(pathname)
save(filename(1:end-4), 'datamatrixglobale');
cd(olddir)

set(handles.uitable1, 'Data', datamatrixglobale);


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global work_image;
global olddir;
global filename;
global pathname;
global datamatrixglobale;
global area_pixel;

cd(olddir)

figure, imshow(work_image)
[work_image] = imcrop(work_image);
close;

axes(handles.a_image)
imshow(work_image)

msgbox('crop done!')

new_size = size(work_image, 1)*size(work_image, 2);

%data storing
datamatrixglobale {2, 5} = new_size*area_pixel;

cd(pathname)
save(filename(1:end-4), 'datamatrixglobale')
cd(olddir)

set(handles.uitable1, 'Data', datamatrixglobale);


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global area_pixel;
global datamatrixglobale;
global pathname;
global filename;
global olddir;
global work_image;
global orig_image;

cd(olddir);

prompt = {'Input pixel size'};
answ = inputdlg (prompt);
area_pixel = str2num(cell2mat(answ))*str2num(cell2mat(answ));

prompt = {'Input magnification'};
m = inputdlg(prompt);

datamatrixglobale{2, 3} = num2str(cell2mat(m));
datamatrixglobale{2, 4} = size(orig_image, 1) * size(orig_image, 2) * area_pixel;
datamatrixglobale{2, 5} = size(work_image, 1) * size(work_image, 2) * area_pixel;

cd(pathname)
save(filename(1:end-4), 'datamatrixglobale')
cd(olddir)

set(handles.uitable1, 'Data', datamatrixglobale);


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global area_pixel;
global datamatrixglobale;
global pathname;
global filename;
global olddir;
global work_image;
global orig_image;

prompt = {'How many colours do you want to detect (remember the FSA!!)?'};
answ = inputdlg (prompt);
colors = str2num(cell2mat(answ));

w = imcrop(work_image);

w = imsharpen (w);
w = imsharpen (w);
w = imsharpen (w);
w = imsharpen (w);

w(:,:,1) = medfilt2(w(:,:,1), [3 3]);
w(:,:,2) = medfilt2(w(:,:,2), [3 3]);
w(:,:,3) = medfilt2(w(:,:,3), [3 3]);

r = size(w, 1);
c = size(w, 2);

%RGB
vett = zeros(1, r*c, 3);

 for i = 1:r
    for j = 1:c
    vett(1, (i-1)*c+j, :) = w(i, j, :);
    end;
end;

vettore = zeros(3, r*c);

for i = 1:size(vett,2)
    for j = 1:3
    vettore(j, i) = vett(1, i, j);
    end;
end;

meas = double(vettore');
[cidx,cmeans] = kmeans(meas, colors,'dist','sqeuclidean');    

%CMYK
a = makecform('srgb2cmyk');
b1 = applycform(w, a);

vett1 = zeros(1, r*c, 4);

 for i = 1:r
    for j = 1:c
    vett1(1, (i-1)*c+j, :) = b1(i, j, :);
    end;
end;

vettore1 = zeros(4, r*c);

for i = 1:size(vett1,2)
    for j = 1:4
    vettore1(j, i) = vett1(1, i, j);
    end;
end;

meas1 = double(vettore1');
[cidx1,cmeans1] = kmeans(meas1, colors,'dist','sqeuclidean');

%ottimizzazione colour space
sRGB = mean(silhouette(meas(1:uint64(end/16), :),cidx(1:uint64(end/16)),'sqeuclidean'));
sCMYK = mean(silhouette(meas1(1:uint64(end/16), :),cidx1(1:uint64(end/16)),'sqeuclidean'));

if sRGB>sCMYK    %prediligo RGB
    
    %ottimizzazione canale
    [idx_rg,cm_rg] = kmeans(meas(:, 1:2), colors,'dist','sqeuclidean');    
    [idx_gb,cm_gb] = kmeans(meas(:, 2:3), colors,'dist','sqeuclidean');    
    [idx_rb,cm_rb] = kmeans(meas(:, 1:2:3), colors,'dist','sqeuclidean');   

    opt_rg = mean(silhouette(meas(1:uint64(end/16), 1:2),idx_rg(1:uint64(end/16)),'sqeuclidean'));
    opt_gb = mean(silhouette(meas(1:uint64(end/16), 2:3),idx_gb(1:uint64(end/16)),'sqeuclidean'));
    opt_rb = mean(silhouette(meas(1:uint64(end/16), 1:2:3),idx_rb(1:uint64(end/16)),'sqeuclidean'));
    opt = [opt_rg; opt_gb; opt_rb];
    
    [ottmax, maxidx] = max(opt);

    if maxidx == 1
        h = msgbox('You should use Red and Green channels!');
    elseif maxidx == 2
        h = msgbox('You should use Green and Blue channels!');
    else
        h = msgbox('You should use Red and Blue channels!');
    end;
    uiwait(h)
    
    gRGB(work_image, datamatrixglobale, area_pixel, pathname, olddir, orig_image, colors);
    uiwait;

    %data storing
    cd(pathname)  
    load([filename(1:end-4) '.mat']);
    cd(olddir)

    set(handles.uitable1, 'Data', datamatrixglobale);
    
else    %prediligo CMYK
    
    %ottimizzazione canale
    [idx_cm,cm_cm] = kmeans(meas1(:, 1:2), colors,'dist','sqeuclidean');    
    [idx_my,cm_my] = kmeans(meas1(:, 2:3), colors,'dist','sqeuclidean');    
    [idx_yk,cm_yk] = kmeans(meas1(:, 3:4), colors,'dist','sqeuclidean');    
    [idx_cy,cm_cy] = kmeans(meas1(:, 1:2:3), colors,'dist','sqeuclidean');    
    [idx_mk,cm_mk] = kmeans(meas1(:, 2:2:4), colors,'dist','sqeuclidean');    
    [idx_ck,cm_ck] = kmeans(meas1(:, 1:3:4), colors,'dist','sqeuclidean');    

    opt_cm = mean(silhouette(meas1(1:uint64(end/16), 1:2),idx_cm(1:uint64(end/16)),'sqeuclidean'));
    opt_my = mean(silhouette(meas1(1:uint64(end/16), 2:3),idx_my(1:uint64(end/16)),'sqeuclidean'));
    opt_yk = mean(silhouette(meas1(1:uint64(end/16), 3:4),idx_yk(1:uint64(end/16)),'sqeuclidean'));
    opt_cy = mean(silhouette(meas1(1:uint64(end/16), 1:2:3),idx_cy(1:uint64(end/16)),'sqeuclidean'));
    opt_mk = mean(silhouette(meas1(1:uint64(end/16), 2:2:4),idx_mk(1:uint64(end/16)),'sqeuclidean'));
    opt_ck = mean(silhouette(meas1(1:uint64(end/16), 1:3:4),idx_ck(1:uint64(end/16)),'sqeuclidean'));
    opt1 = [opt_cm; opt_my; opt_yk; opt_cy; opt_mk; opt_ck];
    
    [ottmax, maxidx] = max(opt1);

    if maxidx == 1
        h = msgbox('You should use Cyan and Magenta channels!');
    elseif maxidx == 2
        h = msgbox('You should use Magenta and Yellow channels!');
    elseif maxidx == 3
        h = msgbox('You should use Yellow and Black channels!');
    elseif maxidx == 4
        h = msgbox('You should use Cyan and Yellow channels!');
    elseif maxidx == 5
        h = msgbox('You should use Magenta and Black channels!');
    else
        h = msgbox('You should use Cyan and Black channels!');
    end;
    uiwait(h)
   
    gCMYK(work_image, datamatrixglobale, area_pixel, pathname, olddir, orig_image, colors);
    uiwait;
    
    %data storing
    cd(pathname)  
    load([filename(1:end-4) '.mat']);
    cd(olddir)

    set(handles.uitable1, 'Data', datamatrixglobale);
end;
