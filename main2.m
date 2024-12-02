function varargout = main2(varargin)
% MAIN2 MATLAB code for main2.fig
%      MAIN2, by itself, creates a new MAIN2 or raises the existing
%      singleton*.
%
%      H = MAIN2 returns the handle to a new MAIN2 or the handle to
%      the existing singleton*.
%
%      MAIN2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN2.M with the given input arguments.
%
%      MAIN2('Property','Value',...) creates a new MAIN2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before main2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to main2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help main2

% Last Modified by GUIDE v2.5 29-Dec-2022 13:09:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @main2_OpeningFcn, ...
                   'gui_OutputFcn',  @main2_OutputFcn, ...
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


% --- Executes just before main2 is made visible.
function main2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to main2 (see VARARGIN)

% Choose default command line output for main2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes main2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = main2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in laod.
function laod_Callback(hObject, eventdata, handles)
% hObject    handle to laod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global I;
[fileName,path]=uigetfile({'.jpg'},'Select an image');
if fileName==0
    disp("User Caneled");
else
I=imread(fullfile(path,fileName));
axes(handles.axes1);
imshow(I),title('original')
axes(handles.axes2);
imhist(I),title('histogram');
%imhist(I(:,:,1)),title('R histogram');
%imhist(I(:,:,2)),title('G histogram');
%imhist(I(:,:,3)),title('B histogram');

end


% --- Executes on button press in compress.
function compress_Callback(hObject, eventdata, handles)
% hObject    handle to compress (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Kmedian;
%% input the image
%% input the image
a=imresize(Kmedian,[256,256]);
b= rgb2ycbcr(a);
 
%% No. of coefficient
cf=2;

%% sampling
cb=b(1:cf:end,1:cf:end,2);
cr=b(1:cf:end,1:cf:end,3);
 
[k1,k2]=size(cb);

for i=cf:cf:cf*k1
    for j=cf:cf:cf*k2
        cbx(i-cf+1:i,j-cf+1:j)=cb(i/cf,j/cf);
        crx(i-cf+1:i,j-cf+1:j)=cr(i/cf,j/cf);
    end
end
 
b(:,:,2)=cbx;
b(:,:,3)=crx;


 Y=b(:,:,1);
%% luminance compression
bb=zeros(size(Y));
kk=1;
sizeblock=8;
k=[1 :sizeblock];
qz=8;cf=3;
kkk=1;
for i=1:(size(Y,1)/sizeblock)
    for j=1:(size(Y,2)/sizeblock)
        
     xx=Y(k +(i-1)*sizeblock, k+(j-1)*sizeblock);
     yy=dct2(xx);
     
     xy=yy;
     for ii=1:sizeblock
              for jj=1:sizeblock

     if (ii+jj)>cf
       yy(ii,jj)=0;
       yy2=yy;
     end
              end
     end
     
     yy=idct2(yy2);
     
    yc(k +(i-1)*sizeblock, k+(j-1)*sizeblock)=yy;
     kk=kk+1;
    end
end
 
b(:,:,1)=yc;
c= ycbcr2rgb(b);
axes(handles.axes7);
imshow(c),title('compress')
axes(handles.axes8);
imhist(c),title('histogram Reconstructed');



% --- Executes on button press in close.
function close_Callback(hObject, eventdata, handles)
% hObject    handle to close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(main2);



% --- Executes on button press in filter.
function filter_Callback(hObject, eventdata, handles)
% hObject    handle to filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global I;
global Kmedian;
%Kmedian = uint8(medfilt3(I));
redchannel=I(:,:,1);
greenchannel=I(:,:,2);
bluechannel=I(:,:,3);
redmf=medfilt2(redchannel,[3 3]);
greenmf=medfilt2(greenchannel,[3 3]);
bluemf=medfilt2(bluechannel,[3 3]);
Kmedian=cat(3,redmf,greenmf,bluemf);

axes(handles.axes3);
imshow(Kmedian),title('filter')
axes(handles.axes4);
imhist(Kmedian),title('histogram filter');


% --- Executes on button press in histeq.
function histeq_Callback(hObject, eventdata, handles)
% hObject    handle to histeq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global hq;
global Kmedian;
hq=histeq(Kmedian);
axes(handles.axes5)
imshow(hq),title('Image Equalization')
axes(handles.axes6)
imhist(hq),title('histogram Equalization');


% --- Executes on button press in grayscale.
function grayscale_Callback(hObject, eventdata, handles)
% hObject    handle to grayscale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(main2);
ImageCompresssed;
