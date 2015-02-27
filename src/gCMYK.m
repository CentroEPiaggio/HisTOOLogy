function varargout = gCMYK(varargin)
% GCMYK MATLAB code for gCMYK.fig
%      GCMYK, by itself, creates a new GCMYK or raises the existing
%      singleton*.
%
%      H = GCMYK returns the handle to a new GCMYK or the handle to
%      the existing singleton*.
%
%      GCMYK('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GCMYK.M with the given input arguments.
%
%      GCMYK('Property','Value',...) creates a new GCMYK or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gCMYK_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gCMYK_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gCMYK

% Last Modified by GUIDE v2.5 29-Dec-2014 01:53:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gCMYK_OpeningFcn, ...
                   'gui_OutputFcn',  @gCMYK_OutputFcn, ...
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


% --- Executes just before gCMYK is made visible.
function gCMYK_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gCMYK (see VARARGIN)
global w;
global dm;
global a_px;
global pathn;
global oldd;
global o_image;
global col;
global im_cresc1;
global false;
global cidx1;
global stock;

% Choose default command line output for gCMYK
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gCMYK wait for user response (see UIRESUME)
% uiwait(handles.figure1);
mInputArgs = varargin;

w_image = mInputArgs{1};
dm = mInputArgs{2};
a_px = mInputArgs{3};
pathn = mInputArgs{4};
oldd = mInputArgs{5}; 
o_image = mInputArgs{6};
col = mInputArgs{7};

axes(handles.a1)
imshow(o_image), impixelinfo

falsep = zeros(size(w_image, 1), size(w_image, 2), 3);
axes(handles.a3)
imshow(falsep), impixelinfo

w = w_image;

w = imsharpen (w);
w = imsharpen (w);
w = imsharpen (w);
w = imsharpen (w);

w(:,:,1) = medfilt2(w(:,:,1), [3 3]);
w(:,:,2) = medfilt2(w(:,:,2), [3 3]);
w(:,:,3) = medfilt2(w(:,:,3), [3 3]);

righe = size(w, 1);
colonne = size(w, 2);

a = makecform('srgb2cmyk');
w = applycform(w, a);

%RGB
vett = zeros(1, righe*colonne, 4);

 for i = 1:righe
    for j = 1:colonne
    vett(1, (i-1)*colonne+j, :) = w(i, j, :);
    end;
end;

vettore = zeros(4, righe*colonne);

for i = 1:size(vett,2)
    for j = 1:4
    vettore(j, i) = vett(1, i, j);
    end;
end;

meas = double(vettore');
[cidx1,cmeans] = kmeans(meas, col,'dist','sqeuclidean'); 

%costruzione false image
stock = zeros(col, 12);

im_index = [cidx1 meas];
[im_cresc, ind] = sort(im_index, 1);
im_cresc1 = im_cresc;

for j = 1:size(im_cresc, 1)
    im_cresc1(j, 2:end) = im_index(ind(j, 1),2:end);
end;

cidx1 = cidx1';
vettore_n = zeros(4, righe*colonne);

n = 0;
for i = 1:col
    m_col = zeros(size(find(im_cresc1(:, 1) == i), 1), 4);
    for j = 1:size(m_col, 1)
        m_col(j, :) = im_cresc1(n+j, 2:end);
    end;
    
    stock(i, 1) = mean(m_col(:, 1));
    stock(i, 2) = mean(m_col(:, 2));
    stock(i, 3) = mean(m_col(:, 3));
    stock(i, 4) = mean(m_col(:, 4));
    stock(i, 5) = min(m_col(:, 1));
    stock(i, 6) = min(m_col(:, 2));
    stock(i, 7) = min(m_col(:, 3));
    stock(i, 8) = min(m_col(:, 4));
    stock(i, 9) = max(m_col(:, 1));
    stock(i, 10) = max(m_col(:, 2));
    stock(i, 11) = max(m_col(:, 3));
    stock(i, 12) = max(m_col(:, 4));

    for k = 1:righe*colonne
        if cidx1(1, k) == i
            vettore_n(1, k) = stock(i, 1);
            vettore_n(2, k) = stock(i, 2);
            vettore_n(3, k) = stock(i, 3);
            vettore_n(4, k) = stock(i, 4);
        end;
    end;
    n = n + size(m_col, 1);
end;

vett_r = zeros(1, righe*colonne, 4);
for i = 1:righe*colonne
    for j = 1:4
        vett_r(1, i, j) = vettore_n(j,i);
    end;
end;

false = zeros(righe, colonne, 4);
for i=1:righe
    for j = 1:colonne
        false(i, j, :) = vett_r(1, (i-1)*colonne+j, :);
    end;
end;

false = uint8(false);

a = makecform('cmyk2srgb');
false = applycform(false, a);

%false = uint8(false);
axes(handles.a2)
imshow(false), impixelinfo

dm1 = cell(2, 5+6*col);
dm1(:, 1:5) = dm;

dm = dm1;


% --- Outputs from this function are returned to the command line.
function varargout = gCMYK_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
global col;
global co;
global im_cresc1;
global w;
global cidx1;
global falsep;
global dm;
global stock;
global stock1;

global cyan1;
global cyan2;
global magenta1;
global magenta2;
global yellow1;
global yellow2;
global black1;
global black2;

co = str2num(get(handles.edit1, 'String'));

if co > col
    msgbox('Too many colours to detect!');
end;

vettore_n = zeros(3, size(w, 1)*size(w, 2));

m_col = zeros(size(find(im_cresc1(:, 1) == co), 1), 4);
for j = 1:size(m_col, 1)
    m_col(j, :) = im_cresc1(j, 2:end);
end;

for k = 1:size(w, 1)*size(w, 2)
    if cidx1(1, k) == co
        vettore_n(1, k) = stock(co, 1);
        vettore_n(2, k) = stock(co, 2);
        vettore_n(3, k) = stock(co, 3);
        vettore_n(4, k) = stock(co, 4);
    end;
end;

vett_r = zeros(1, size(w, 1)*size(w, 2), 4);
for i = 1:size(w, 1)*size(w, 2)
    for j = 1:4
        vett_r(1, i, j) = vettore_n(j,i);
    end;
end;

falsep = zeros(size(w, 1), size(w, 2), 4);
for i=1:size(w, 1)
    for j = 1:size(w, 2)
        falsep(i, j, :) = vett_r(1, (i-1)*size(w, 2)+j, :);
    end;
end;

falsep = uint8(falsep);
a = makecform('cmyk2srgb');
falsep = applycform(falsep, a);

for i = 1:size(w, 1)
    for j = 1:size(w, 2)
        if falsep(i,j,1) == 255 & falsep(i, j, 2) == 255 & falsep(i,j,3) == 255
            falsep(i,j,1) = 0;
            falsep(i,j,2) = 0;
            falsep(i,j,3) = 0;
        end;
    end;
end;

stock1 = unique(falsep, 'stable');
stock1 = stock1(find(stock1 ~= 0))';


axes(handles.a3)
imshow(falsep), impixelinfo

cyan1 = stock(co, 5);
cyan2 = stock(co, 9);
magenta1 = stock(co, 6);
magenta2 = stock(co, 10);
yellow1 = stock(co, 7);
yellow2 = stock(co, 11);
black1 = stock(co, 8);
black2 = stock(co, 12);

set(handles.text6, 'String', num2str(cyan1));
set(handles.text7, 'String', num2str(cyan2));
set(handles.text8, 'String', num2str(magenta1));
set(handles.text9, 'String', num2str(magenta2));
set(handles.text10, 'String', num2str(yellow1));
set(handles.text11, 'String', num2str(yellow2));
set(handles.text12, 'String', num2str(black1));
set(handles.text13, 'String', num2str(black2));

set(handles.slider1, 'Value', cyan1);
set(handles.slider2, 'Value', cyan2);
set(handles.slider3, 'Value', magenta1);
set(handles.slider4, 'Value', magenta2);
set(handles.slider5, 'Value', yellow1);
set(handles.slider6, 'Value', yellow2);
set(handles.slider7, 'Value', black1);
set(handles.slider8, 'Value', black2);

dm{1, 5+6*(co-1)+1} = ['Colour #' num2str(co)];


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global co;
global dm;

prompt = inputdlg('Insert the name of the dye detected');
dm{1, 5+(co-1)*6+1} = prompt{1, 1};


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global dm;
global count;
global co;
global falsep;

[a, count] = bwlabel(im2bw(falsep, graythresh(falsep)));

dm{1, 5+6*(co-1)+6} = 'Object count';
dm{2, 5+6*(co-1)+6} = count;

msgbox('the object count is stored!')

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global false;
global falsep;
global dm;
global co;
global a_px;
global stock;
global pathn;
global olddir;

for i = 1:size(false, 1)
    for j = 1:size(false, 2)
        if falsep(i, j, 1) ~= 0 & falsep(i, j, 2) ~= 0 & falsep(i, j, 3) ~= 0 
            false(i, j, :) = falsep(i, j, :);
        end;
    end;
end;

false = uint8(false);
axes(handles.a2)
imshow(false), impixelinfo

area = sum(sum(im2bw(falsep, graythresh(falsep))));

dm{2, 5+(co-1)*6+1} = area*a_px;

dm{1, 5+6*(co-1)+2} = 'Mean Cyan Intensity';
dm{2, 5+6*(co-1)+2} = uint8(stock(co, 1));
dm{1, 5+6*(co-1)+3} = 'Mean Magenta Intensity';
dm{2, 5+6*(co-1)+3} = uint8(stock(co, 2));
dm{1, 5+6*(co-1)+4} = 'Mean Yellow Intensity';
dm{2, 5+6*(co-1)+4} = uint8(stock(co, 3));
dm{1, 5+6*(co-1)+5} = 'Mean Black Intensity';
dm{2, 5+6*(co-1)+5} = uint8(stock(co, 4));

cd(pathn)
imwrite(falsep, ['Simplified' dm{1, 5+(co-1)*6+1} '.tif'])
cd(olddir)


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global w;
global stock1;
global falsep;

global cyan1;
global cyan2;
global magenta1;
global magenta2;
global yellow1;
global yellow2;
global black1;
global black2;

cyan1 = uint8(get(handles.slider1, 'Value'));
set(handles.text6, 'String', num2str(cyan1));

falsep = zeros(size(w, 1), size(w, 2), 3);
for i = 1:size(w, 1)
    for j = 1:size(w, 2)
        if w(i, j, 1) > cyan1 & w(i, j, 1) < cyan2 & ...
                w(i, j, 2) > magenta1 & w(i, j, 2) < magenta2 & ...
                w(i, j, 3) > yellow1 & w(i, j, 3) < yellow2 & ...
                w(i, j, 4) > black1 & w(i, j, 4) < black2
            falsep(i, j, 1) = stock1(1, 1);
            falsep(i, j, 2) = stock1(1, 2);
            falsep(i, j, 3) = stock1(1, 3);
        end;
        
    end;
end;

falsep = uint8(falsep);
axes(handles.a3)
imshow(falsep), impixelinfo


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global w;
global stock1;
global falsep;

global cyan1;
global cyan2;
global magenta1;
global magenta2;
global yellow1;
global yellow2;
global black1;
global black2;

cyan2 = uint8(get(handles.slider2, 'Value'));
set(handles.text7, 'String', num2str(cyan2));

falsep = zeros(size(w, 1), size(w, 2), 3);
for i = 1:size(w, 1)
    for j = 1:size(w, 2)
        if w(i, j, 1) > cyan1 & w(i, j, 1) < cyan2 & ...
                w(i, j, 2) > magenta1 & w(i, j, 2) < magenta2 & ...
                w(i, j, 3) > yellow1 & w(i, j, 3) < yellow2 & ...
                w(i, j, 4) > black1 & w(i, j, 4) < black2
            falsep(i, j, 1) = stock1(1, 1);
            falsep(i, j, 2) = stock1(1, 2);
            falsep(i, j, 3) = stock1(1, 3);
        end;
        
    end;
end;

falsep = uint8(falsep);
axes(handles.a3)
imshow(falsep), impixelinfo

% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global w;
global stock1;
global falsep;

global cyan1;
global cyan2;
global magenta1;
global magenta2;
global yellow1;
global yellow2;
global black1;
global black2;

magenta1 = uint8(get(handles.slider2, 'Value'));
set(handles.text8, 'String', num2str(magenta1));

falsep = zeros(size(w, 1), size(w, 2), 3);
for i = 1:size(w, 1)
    for j = 1:size(w, 2)
        if w(i, j, 1) > cyan1 & w(i, j, 1) < cyan2 & ...
                w(i, j, 2) > magenta1 & w(i, j, 2) < magenta2 & ...
                w(i, j, 3) > yellow1 & w(i, j, 3) < yellow2 & ...
                w(i, j, 4) > black1 & w(i, j, 4) < black2
            falsep(i, j, 1) = stock1(1, 1);
            falsep(i, j, 2) = stock1(1, 2);
            falsep(i, j, 3) = stock1(1, 3);
        end;
        
    end;
end;

falsep = uint8(falsep);
axes(handles.a3)
imshow(falsep), impixelinfo


% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider4_Callback(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global w;
global stock1;
global falsep;

global cyan1;
global cyan2;
global magenta1;
global magenta2;
global yellow1;
global yellow2;
global black1;
global black2;

magenta2 = uint8(get(handles.slider4, 'Value'));
set(handles.text9, 'String', num2str(magenta2));

falsep = zeros(size(w, 1), size(w, 2), 3);
for i = 1:size(w, 1)
    for j = 1:size(w, 2)
        if w(i, j, 1) > cyan1 & w(i, j, 1) < cyan2 & ...
                w(i, j, 2) > magenta1 & w(i, j, 2) < magenta2 & ...
                w(i, j, 3) > yellow1 & w(i, j, 3) < yellow2 & ...
                w(i, j, 4) > black1 & w(i, j, 4) < black2
            falsep(i, j, 1) = stock1(1, 1);
            falsep(i, j, 2) = stock1(1, 2);
            falsep(i, j, 3) = stock1(1, 3);
        end;
        
    end;
end;

falsep = uint8(falsep);
axes(handles.a3)
imshow(falsep), impixelinfo


% --- Executes during object creation, after setting all properties.
function slider4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider5_Callback(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global w;
global stock1;
global falsep;

global cyan1;
global cyan2;
global magenta1;
global magenta2;
global yellow1;
global yellow2;
global black1;
global black2;

yellow1 = uint8(get(handles.slider5, 'Value'));
set(handles.text10, 'String', num2str(yellow1));

falsep = zeros(size(w, 1), size(w, 2), 3);
for i = 1:size(w, 1)
    for j = 1:size(w, 2)
        if w(i, j, 1) > cyan1 & w(i, j, 1) < cyan2 & ...
                w(i, j, 2) > magenta1 & w(i, j, 2) < magenta2 & ...
                w(i, j, 3) > yellow1 & w(i, j, 3) < yellow2 & ...
                w(i, j, 4) > black1 & w(i, j, 4) < black2
            falsep(i, j, 1) = stock1(1, 1);
            falsep(i, j, 2) = stock1(1, 2);
            falsep(i, j, 3) = stock1(1, 3);
        end;
        
    end;
end;

falsep = uint8(falsep);
axes(handles.a3)
imshow(falsep), impixelinfo


% --- Executes during object creation, after setting all properties.
function slider5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider6_Callback(hObject, eventdata, handles)
% hObject    handle to slider6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global w;
global stock1;
global falsep;

global cyan1;
global cyan2;
global magenta1;
global magenta2;
global yellow1;
global yellow2;
global black1;
global black2;

yellow2 = uint8(get(handles.slider6, 'Value'));
set(handles.text11, 'String', num2str(yellow2));

falsep = zeros(size(w, 1), size(w, 2), 3);
for i = 1:size(w, 1)
    for j = 1:size(w, 2)
        if w(i, j, 1) > cyan1 & w(i, j, 1) < cyan2 & ...
                w(i, j, 2) > magenta1 & w(i, j, 2) < magenta2 & ...
                w(i, j, 3) > yellow1 & w(i, j, 3) < yellow2 & ...
                w(i, j, 4) > black1 & w(i, j, 4) < black2
            falsep(i, j, 1) = stock1(1, 1);
            falsep(i, j, 2) = stock1(1, 2);
            falsep(i, j, 3) = stock1(1, 3);
        end;
        
    end;
end;

falsep = uint8(falsep);
axes(handles.a3)
imshow(falsep), impixelinfo


% --- Executes during object creation, after setting all properties.
function slider6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider7_Callback(hObject, eventdata, handles)
% hObject    handle to slider7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global w;
global stock1;
global falsep;

global cyan1;
global cyan2;
global magenta1;
global magenta2;
global yellow1;
global yellow2;
global black1;
global black2;

black1 = uint8(get(handles.slider7, 'Value'));
set(handles.text12, 'String', num2str(black1));

falsep = zeros(size(w, 1), size(w, 2), 3);
for i = 1:size(w, 1)
    for j = 1:size(w, 2)
        if w(i, j, 1) > cyan1 & w(i, j, 1) < cyan2 & ...
                w(i, j, 2) > magenta1 & w(i, j, 2) < magenta2 & ...
                w(i, j, 3) > yellow1 & w(i, j, 3) < yellow2 & ...
                w(i, j, 4) > black1 & w(i, j, 4) < black2
            falsep(i, j, 1) = stock1(1, 1);
            falsep(i, j, 2) = stock1(1, 2);
            falsep(i, j, 3) = stock1(1, 3);
        end;
        
    end;
end;

falsep = uint8(falsep);
axes(handles.a3)
imshow(falsep), impixelinfo


% --- Executes during object creation, after setting all properties.
function slider7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider8_Callback(hObject, eventdata, handles)
% hObject    handle to slider8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global w;
global stock1;
global falsep;

global cyan1;
global cyan2;
global magenta1;
global magenta2;
global yellow1;
global yellow2;
global black1;
global black2;

black2 = uint8(get(handles.slider8, 'Value'));
set(handles.text13, 'String', num2str(black2));

falsep = zeros(size(w, 1), size(w, 2), 3);
for i = 1:size(w, 1)
    for j = 1:size(w, 2)
        if w(i, j, 1) > cyan1 & w(i, j, 1) < cyan2 & ...
                w(i, j, 2) > magenta1 & w(i, j, 2) < magenta2 & ...
                w(i, j, 3) > yellow1 & w(i, j, 3) < yellow2 & ...
                w(i, j, 4) > black1 & w(i, j, 4) < black2
            falsep(i, j, 1) = stock1(1, 1);
            falsep(i, j, 2) = stock1(1, 2);
            falsep(i, j, 3) = stock1(1, 3);
        end;
        
    end;
end;

falsep = uint8(falsep);
axes(handles.a3)
imshow(falsep), impixelinfo


% --- Executes during object creation, after setting all properties.
function slider8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global dm;
global pathn;
global oldd;
global false;

cd(pathn);
filename = dm{2, 1};
save(filename(1:end-4), 'dm')
q = dm{1, 2};
imwrite(false, ['Simplified' q(1:end-4) '.tif'])
cd(oldd)

close;
