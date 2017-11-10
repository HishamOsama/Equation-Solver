classdef BirgeVietaMethod
    %SECANTMETHOD Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        equation;
        xArray = [];
        eArray = [];
    end
    
    methods
        
        function obj = BirgeVietaMethod(equation)
            obj.equation = equation;
        end
        
        % add handles
        function result = solve(obj,handles,x0,es,maxIt)
           
           Utils.GraphPlotter.addMethodName(handles,'Birge Vieta');
            
           iterations = 0;           
           coeff = obj.getCoeffecients();
           b0 = coeff(1);
           c0 = coeff(1);
           curX = x0;
           tic
           while (true)
                iterations = iterations + 1;
                index = 2;
                prevB = b0;
                prevC = c0;
                b = b0;
                c =c0;
                while (index <= length(coeff))
                    prevC = c;
                    b = coeff(index) + curX * prevB;
                    c = b + curX * prevC;
                    prevB = b;
                    index = index + 1;
                end
                prevX = curX;
                curX = prevX - b / prevC;
                obj.xArray = [obj.xArray,curX];
                ea = (curX - prevX) / curX;
                ea = abs(ea);
                obj.eArray = [obj.eArray;ea];
                obj.addData(handles, prevX, curX, ea);
                if (ea < es)
                    break;
                end
                if (iterations >= maxIt)
                    break;
                end
                
           end 
            time = toc;
            obj.addAnswer(handles,iterations,time);
            obj.addPlot(handles,iterations);
        end
        
        function a = getCoeffecients(obj)
            polynomial = sym(obj.equation);
            a = sym2poly(polynomial);
            return;
        end
        
        function y = evaluate(obj,x)
            fn = sym(obj.equation);
            polynomial = matlabFunction(fn);
            y = polynomial(x);
        end
        
        function addData(~,handles,xrOld,xr,ea)
            data = get(handles.uitable1,'data');
            data(end+1,1) = {xrOld};
            data(end,2) = {xr};
            data(end,3) = {ea};
            data(end,4) = {(ea/xr)*100};
            set(handles.uitable1,'data',data);
            set(handles.uitable1,'ColumnName',{'xrOld','xr','ea','ea(%)'});
        end
        
        function addAnswer(obj,handles,iterations,time)
            Utils.GraphPlotter.addAnswers(handles,'Root',obj.xArray(length(obj.xArray)));
            Utils.GraphPlotter.addAnswers(handles,'Iterations',iterations);
            Utils.GraphPlotter.addAnswers(handles,'Error',obj.eArray(length(obj.eArray)));
            Utils.GraphPlotter.addAnswers(handles,'Time',time);
        end
        
        function addPlot(obj,handles,iterations)
            Utils.GraphPlotter.plot(handles,obj.xArray,iterations,'b');
            Utils.GraphPlotter.plotError(handles,obj.eArray,iterations,'b');
        end
        
    end
    
    methods(Static)
    
        function setFields(handles,mode)
            set(handles.xVieta,'Visible',mode);
            set(handles.maxVieta,'Visible',mode);
            set(handles.eVieta,'Visible',mode);
            set(handles.xLVieta,'Visible',mode);
            set(handles.maxLVieta,'Visible',mode);
            set(handles.eLVieta,'Visible',mode);
        end
        
        function iLine = loadParameters(handles,data,iLine)
            set(handles.methodsMenu,'Value',7);
            set(handles.xVieta,'string',data{iLine});
            set(handles.maxVieta,'string',data{iLine+1});
            set(handles.eVieta,'string',data{iLine+2});
            iLine = 3;
        end
        
    end
end