classdef BirgeVietaMRMethod
    %SECANTMETHOD Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        equation;
    end
    
    methods
        
        function obj = BirgeVietaMRMethod(equation)
            obj.equation = equation;
        end
        
        %add handles
        function result = solve(obj,x0,es,maxIt, handles)
           iterations = 0;
           result = [];
           coeff = obj.getCoeffecients();
           disp(coeff)
           if (isempty(coeff))
               return;
           end;
           while (true)
               bArray = [];
               if (length(coeff) <= 1)
                    return;
               end
               b0 = coeff(1);
               c0 = coeff(1);
               curX = x0;
               while (true)
                    iterations = iterations + 1;
                    index = 2;
                    bAux = [b0];
                    prevB = b0;
                    prevC = c0;
                    b = b0;
                    c =c0;
                    while (index <= length(coeff))
                        prevC = c;
                        b = coeff(index) + curX * prevB;
                        bAux = [bAux, b];
                        c = b + curX * prevC;
                        prevB = b;
                        index = index + 1;
                    end
                    prevX = curX;
                    curX = prevX - b / prevC;
                    ea = (curX - prevX) / curX;
                    ea = abs(ea);
                    if (ea < es)
                        bArray = bAux;
                        result = [result ; curX];
                        break;
                    end
                    if (iterations >= maxIt)
                        result = [result ; curX];
                        bArray = bAux;
                        break;
                    end
               end
               obj.addData(handles, curX);
               coeff = bArray(1:end - 1);
           end
        end
        
        function a = getCoeffecients(obj)
            try
                polynomial = sym(obj.equation);
                a = sym2poly(polynomial);
            catch ME
                disp(ME.identifier);
                a = [];
            end
            return;
        end
        
        function y = evaluate(obj,x)
            fn = sym(obj.equation);
            polynomial = matlabFunction(fn);
            y = polynomial(x);
        end
        
        function addData(~,handles,root)
            data = get(handles.uitable1,'data');
            data(end+1,1) = {root};
            set(handles.uitable1,'data',data);
        end
        
    end
    
    methods(Static)
    
        function setFieldsOn(handles)
            set(handles.xVieta,'Visible','on');
            set(handles.maxVieta,'Visible','on');
            set(handles.eVieta,'Visible','on');
            set(handles.xLVieta,'Visible','on');
            set(handles.maxLVieta,'Visible','on');
            set(handles.eLVieta,'Visible','on');
        end
        
        function setFieldsOff(handles)
            set(handles.xVieta,'Visible','off');
            set(handles.maxVieta,'Visible','off');
            set(handles.eVieta,'Visible','off');
            set(handles.xLVieta,'Visible','off');
            set(handles.maxLVieta,'Visible','off');
            set(handles.eLVieta,'Visible','off');        
        end
        
    end
end