function varargout = gRGB(varargin)
% GRGB MATLAB code for gRGB.fig
%      GRGB, by itself, creates a new GRGB or raises the existing
%      singleton*.
%
%      H = GRGB returns the handle to a new GRGB or the handle to
%      the existing singleton*.
%
%      GRGB('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GRGB.M with the given input arguments.
%
%      GRGB('Property','Value',...) creates a new GRGB or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gRGB_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gRGB_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gRGB

% Last Modified by GUIDE v2.5 03-Feb-2015 10:12:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gRGB_OpeningFcn, ...
                   'gui_OutputFcn',  @gRGB_OutputFcn, ...
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


% --- Executes just before gRGB is made visible.
function gRGB_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gRGB (see VARARGIN)
global w_image;
global dm;
global a_px;
global pathn;
global oldd;
global o_image;
global col;
global im_cresc1;
global false;
global cidx;
global stock;

% Choose default command line output for gRGB
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gRGB wait for user response (see UIRESUME)
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

%RGB
vett = zeros(1, righe*colonne, 3);

 for i = 1:righe
    for j = 1:colonne
    vett(1, (i-1)*colonne+j, :) = w(i, j, :);
    end;
end;

vettore = zeros(3, righe*colonne);

for i = 1:size(vett,2)
    for j = 1:3
    vettore(j, i) = vett(1, i, j);
    end;
end;

meas = double(vettore');
[cidx,cmeans] = kmeans(meas, col,'dist','sqeuclidean'); 

%costruzione false image
stock = zeros(col, 9);

im_index = [cidx meas];
[im_cresc, ind] = sort(im_index, 1);
im_cresc1 = im_cresc;

for j = 1:size(im_cresc, 1)
    im_cresc1(j, 2:end) = im_index(ind(j, 1),2:end);
end;

cidx = cidx';
vettore_n = zeros(3, righe*colonne);

n = 0;
for i = 1:col
    m_col = zeros(size(find(im_cresc1(:, 1) == i), 1), 3);
    for j = 1:size(m_col, 1)
        m_col(j, :) = im_cresc1(n+j, 2:end);
    end;
    
    stock(i, 1) = mean(m_col(:, 1));
    stock(i, 2) = mean(m_col(:, 2));
    stock(i, 3) = mean(m_col(:, 3));
    stock(i, 4) = min(m_col(:, 1));
    stock(i, 5) = min(m_col(:, 2));
    stock(i, 6) = min(m_col(:, 3));
    stock(i, 7) = max(m_col(:, 1));
    stock(i, 8) = max(m_col(:, 2));
    stock(i, 9) = max(m_col(:, 3));

    for k = 1:righe*colonne
        if cidx(1, k) == i
            vettore_n(1, k) = stock(i, 1);
            vettore_n(2, k) = stock(i, 2);
            vettore_n(3, k) = stock(i, 3);
        end;
    end;
    n = n + size(m_col, 1);
end;

vett_r = zeros(1, righe*colonne, 3);
for i = 1:righe*colonne
    for j = 1:3
        vett_r(1, i, j) = vettore_n(j,i);
    end;
end;

false = zeros(righe, colonne, 3);
for i=1:righe
    for j = 1:colonne
        false(i, j, :) = vett_r(1, (i-1)*colonne+j, :);
    end;
end;

false = uint8(false);
axes(handles.a2)
imshow(false), impixelinfo

dm1 = cell(2, 5+5*col);
dm1(:, 1:5) = dm;

dm = dm1;



% --- Outputs from this function are returned to the command line.
function varargout = gRGB_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global w_image;
global stock;
global co;
global falsep;

global red1;
global red2;
global green1;
global green2;
global blue1;
global blue2;

red1 = uint8(get(handles.slider1, 'Value'));
set(handles.text1, 'String', num2str(red1));

falsep = zeros(size(w_image, 1), size(w_image, 2), 3);
for i = 1:size(w_image, 1)
    for j = 1:size(w_image, 2)
        if w_image(i, j, 1) > red1 & w_image(i, j, 1) < red2 & ...
                w_image(i, j, 2) > green1 & w_image(i, j, 2) < green2 & ...
                w_image(i, j, 3) > blue1 & w_image(i, j, 3) < blue2
            falsep(i, j, 1) = stock(co, 1);
            falsep(i, j, 2) = stock(co, 2);
            falsep(i, j, 3) = stock(co, 3);
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
global w_image;
global stock;
global co;
global falsep;

global red1;
global red2;
global green1;
global green2;
global blue1;
global blue2;

red2 = uint8(get(handles.slider2, 'Value'));
set(handles.text2, 'String', num2str(red2));

falsep = zeros(size(w_image, 1), size(w_image, 2), 3);
for i = 1:size(w_image, 1)
    for j = 1:size(w_image, 2)
        if w_image(i, j, 1) > red1 & w_image(i, j, 1) < red2 & ...
                w_image(i, j, 2) > green1 & w_image(i, j, 2) < green2 & ...
                w_image(i, j, 3) > blue1 & w_image(i, j, 3) < blue2
            falsep(i, j, 1) = stock(co, 1);
            falsep(i, j, 2) = stock(co, 2);
            falsep(i, j, 3) = stock(co, 3);
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
global w_image;
global stock;
global co;
global falsep;

global red1;
global red2;
global green1;
global green2;
global blue1;
global blue2;

green1 = uint8(get(handles.slider3, 'Value'));
set(handles.text3, 'String', num2str(green1));

falsep = zeros(size(w_image, 1), size(w_image, 2), 3);
for i = 1:size(w_image, 1)
    for j = 1:size(w_image, 2)
        if w_image(i, j, 1) > red1 & w_image(i, j, 1) < red2 & ...
                w_image(i, j, 2) > green1 & w_image(i, j, 2) < green2 & ...
                w_image(i, j, 3) > blue1 & w_image(i, j, 3) < blue2
            falsep(i, j, 1) = stock(co, 1);
            falsep(i, j, 2) = stock(co, 2);
            falsep(i, j, 3) = stock(co, 3);
        end;
        
    end;
end;

falsep = uint8(falsep);
axes(handles.a3)
imshow(falsep)


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
global w_image;
global stock;
global co;
global falsep;

global red1;
global red2;
global green1;
global green2;
global blue1;
global blue2;

green2 = uint8(get(handles.slider4, 'Value'));
set(handles.text4, 'String', num2str(green2));

falsep = zeros(size(w_image, 1), size(w_image, 2), 3);
for i = 1:size(w_image, 1)
    for j = 1:size(w_image, 2)
        if w_image(i, j, 1) > red1 & w_image(i, j, 1) < red2 & ...
                w_image(i, j, 2) > green1 & w_image(i, j, 2) < green2 & ...
                w_image(i, j, 3) > blue1 & w_image(i, j, 3) < blue2
            falsep(i, j, 1) = stock(co, 1);
            falsep(i, j, 2) = stock(co, 2);
            falsep(i, j, 3) = stock(co, 3);
        end;
        
    end;
end;

falsep = uint8(falsep);
axes(handles.a3)
imshow(falsep)


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
global w_image;
global stock;
global co;
global falsep;

global red1;
global red2;
global green1;
global green2;
global blue1;
global blue2;

blue1 = uint8(get(handles.slider5, 'Value'));
set(handles.text5, 'String', num2str(blue1));

falsep = zeros(size(w_image, 1), size(w_image, 2), 3);
for i = 1:size(w_image, 1)
    for j = 1:size(w_image, 2)
        if w_image(i, j, 1) > red1 & w_image(i, j, 1) < red2 & ...
                w_image(i, j, 2) > green1 & w_image(i, j, 2) < green2 & ...
                w_image(i, j, 3) > blue1 & w_image(i, j, 3) < blue2
            falsep(i, j, 1) = stock(co, 1);
            falsep(i, j, 2) = stock(co, 2);
            falsep(i, j, 3) = stock(co, 3);
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
global w_image;
global stock;
global co;
global falsep;

global red1;
global red2;
global green1;
global green2;
global blue1;
global blue2;

blue2 = uint8(get(handles.slider6, 'Value'));
set(handles.text6, 'String', num2str(blue2));

falsep = zeros(size(w_image, 1), size(w_image, 2), 3);
for i = 1:size(w_image, 1)
    for j = 1:size(w_image, 2)
        if w_image(i, j, 1) > red1 & w_image(i, j, 1) < red2 & ...
                w_image(i, j, 2) > green1 & w_image(i, j, 2) < green2 & ...
                w_image(i, j, 3) > blue1 & w_image(i, j, 3) < blue2
            falsep(i, j, 1) = stock(co, 1);
            falsep(i, j, 2) = stock(co, 2);
            falsep(i, j, 3) = stock(co, 3);
        end;
        
    end;
end;

falsep = uint8(falsep);
axes(handles.a3)
imshow(falsep)


% --- Executes during object creation, after setting all properties.
function slider6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
global col;
global co;
global im_cresc1;
global w_image;
global cidx;
global falsep;
global dm;
global stock;

global red1;
global red2;
global green1;
global green2;
global blue1;
global blue2;

co = str2num(get(handles.edit1, 'String'));

if co > col
    msgbox('Too many colours to detect!');
end;

vettore_n = zeros(3, size(w_image, 1)*size(w_image, 2));

m_col = zeros(size(find(im_cresc1(:, 1) == co), 1), 3);
for j = 1:size(m_col, 1)
    m_col(j, :) = im_cresc1(j, 2:end);
end;

for k = 1:size(w_image, 1)*size(w_image, 2)
    if cidx(1, k) == co
        vettore_n(1, k) = stock(co, 1);
        vettore_n(2, k) = stock(co, 2);
        vettore_n(3, k) = stock(co, 3);
    end;
end;

vett_r = zeros(1, size(w_image, 1)*size(w_image, 2), 3);
for i = 1:size(w_image, 1)*size(w_image, 2)
    for j = 1:3
        vett_r(1, i, j) = vettore_n(j,i);
    end;
end;

falsep = zeros(size(w_image, 1), size(w_image, 2), 3);
for i=1:size(w_image, 1)
    for j = 1:size(w_image, 2)
        falsep(i, j, :) = vett_r(1, (i-1)*size(w_image, 2)+j, :);
    end;
end;

falsep = uint8(falsep);
axes(handles.a3)
imshow(falsep), impixelinfo

red1 = stock(co, 4);
red2 = stock(co, 7);
green1 = stock(co, 5);
green2 = stock(co, 8);
blue1 = stock(co, 6);
blue2 = stock(co, 9);

set(handles.text1, 'String', num2str(red1));
set(handles.text2, 'String', num2str(red2));
set(handles.text3, 'String', num2str(green1));
set(handles.text4, 'String', num2str(green2));
set(handles.text5, 'String', num2str(blue1));
set(handles.text6, 'String', num2str(blue2));

set(handles.slider1, 'Value', red1);
set(handles.slider2, 'Value', red2);
set(handles.slider3, 'Value', green1);
set(handles.slider4, 'Value', green2);
set(handles.slider5, 'Value', blue1);
set(handles.slider6, 'Value', blue2);

dm{1, 5+5*(co-1)+1} = ['Colour #' num2str(co)];


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
imshow(false)

area = sum(sum(im2bw(falsep, graythresh(falsep))));

dm{2, 5+(co-1)*5+1} = area*a_px;

dm{1, 5+5*(co-1)+2} = 'Mean Red Intensity';
dm{2, 5+5*(co-1)+2} = uint8(stock(co, 1));
dm{1, 5+5*(co-1)+3} = 'Mean Green Intensity';
dm{2, 5+5*(co-1)+3} = uint8(stock(co, 2));
dm{1, 5+5*(co-1)+4} = 'Mean Blue Intensity';
dm{2, 5+5*(co-1)+4} = uint8(stock(co, 3));

cd(pathn)
q = dm{1, 5+5*(co-1)+1};
imwrite(falsep, ['Simplified' q '.tif'])
cd(olddir)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
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

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global co;
global dm;

prompt = inputdlg('Insert the name of the dye detected');
dm{1, 5+(co-1)*5+1} = prompt{1, 1};


% --- Executes during object creation, after setting all properties.
function pushbutton1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global dm;
global count;
global co;
global falsep;

[a, count] = bwlabel(im2bw(falsep, graythresh(falsep)));

dm{1, 5+5*(co-1)+5} = 'Object count';
dm{2, 5+5*(co-1)+5} = count;

msgbox('the object count is stored!')
