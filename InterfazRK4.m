function varargout = InterfazRK4(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @InterfazRK4_OpeningFcn, ...
                   'gui_OutputFcn',  @InterfazRK4_OutputFcn, ...
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

function InterfazRK4_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;

guidata(hObject, handles);

function varargout = InterfazRK4_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


function buttonCargar_Callback(hObject, eventdata, handles)
    condicion = [1;1.4;2.1];
    [X Y] = rk4(handles.a,handles.b,condicion,handles.h,handles.orden);
    y = Y(1,:);
    axes(handles.grafica);
    newplot,
    plot(X,y,'r*');
    axis([-1 1.5 -0.5 5]);
    axh = gca; % use current axes
    color = 'k'; % black, or [0 0 0]
    linestyle = ':'; % dotted
    line(get(axh,'XLim'), [0 0], 'Color', color, 'LineStyle', linestyle);
    line([0 0], get(axh,'YLim'), 'Color', color, 'LineStyle', linestyle);
    
    xlabel('x')
    ylabel('y')
    title('Graficando puntos de RK4', 'FontSize',12)

function txtBoxPtoInicial_Callback(hObject, eventdata, handles)
    a = get(hObject,'String');
    handles.a = str2double(a);
    guidata(hObject,handles);

function txtBoxPtoInicial_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function txtBoxPtoFinal_Callback(hObject, eventdata, handles)
    b = get(hObject,'String');
    handles.b = str2double(b);
    guidata(hObject,handles);

function txtBoxPtoFinal_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function txtBoxTamPaso_Callback(hObject, eventdata, handles)
    h = get(hObject,'String');
    handles.h = str2double(h);
    guidata(hObject,handles);

function txtBoxTamPaso_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function txtBoxOrden_Callback(hObject, eventdata, handles)
    orden = get(hObject,'String');
    handles.orden = str2double(orden);
    guidata(hObject,handles);

function txtBoxOrden_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btAproximar.
function btAproximar_Callback(hObject, eventdata, handles)
% hObject    handle to btAproximar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    syms x
    condicion = [1;1.4;2.1];
    [X Y] = rk4(handles.a,handles.b,condicion,handles.h,handles.orden);
    
    %fam = [1 x x^2];
    %fam = [sqrt(1) sqrt(x) sqrt(x^2)]
    %fam = [1/(1+x^2) x/(1+x^2) x^2/(1+x^2)];
    fam = [1/(x+1) x/(x+1) x^2/(x+1)]
    
    A=getMatrixA(fam,X);
    res(x)=aproxDiscreta(A,Y);
    axes(handles.grafica);
    hold on
    plot(X,res(X));

    axis([-1 1.5 -0.5 5]);
    axh = gca; % use current axes
    color = 'k'; % black, or [0 0 0]
    linestyle = ':'; % dotted
    line(get(axh,'XLim'), [0 0], 'Color', color, 'LineStyle', linestyle);
    line([0 0], get(axh,'YLim'), 'Color', color, 'LineStyle', linestyle);
    
    xlabel('x')
    ylabel('y')


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over btAproximar.
function btAproximar_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to btAproximar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
