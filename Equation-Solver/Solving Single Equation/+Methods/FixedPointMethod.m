classdef FixedPointMethod
    %FIXEDPOINTMETHOD Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        equation;
        xArray = [];
        eArray = [];
        iterations;
    end
    
    methods
        
        function obj = FixedPointMethod(equation)
            obj.equation = equation;
        end
        
        function solve(obj,handles,x0,maxI,es)
            
            Utils.GraphPlotter.addMethodName(handles,'Fixed Point');
            
            xrOld = x0;
            ea = 0;
            
            tic
            for i = 1 : maxI
                
                xr = (obj.evaluate(xrOld));
                obj.xArray = [obj.xArray,xr];
                obj.addData(handles,xrOld,ea,i);
                ea = abs(xr - xrOld);
                obj.eArray = [obj.eArray,xr];
                
                if(ea < es)
                    obj.iterations = i;
                    break;
                end
                
                xrOld = xr;
                
            end
            time = toc;
            
            obj.addAnswer(handles,time);
            obj.addPlot(handles);
       
        end
        
        function errorBound = calculateErrorBound(obj)
            firstError = obj.eArray(1);
            approximateRoot = obj.xArray(length(obj.xArray));
            errorBound = obj.evaluateDerivative(approximateRoot) + 1;
            errorBound = errorBound * firstError;
        end
        
        function y = evaluateDerivative(obj,x) 
            f = sym(obj.equation);
            df = diff(f);
            y = subs(df,x);
        end
        
        function y = evaluate(obj,x)
            y = obj.equation(x) + x;
        end
        
        function addData(~,handles,xrOld,ea,i)
            data = get(handles.uitable1,'data');
            data(end+1,1) = {xrOld};
            if(i == 1)
                data(end,2) = {'-------------'};
                data(end,3) = {'-------------'};
            else
                data(end,2) = {ea};
                data(end,3) = {(ea/xrOld)*100};
            end
            set(handles.uitable1,'data',data);
            set(handles.uitable1,'ColumnName',{'xi','ea','ea(%)'});
        end
        
        function addAnswer(obj,handles,time)
            Utils.GraphPlotter.addAnswers(handles,'Root',obj.xArray(length(obj.xArray)));
            Utils.GraphPlotter.addAnswers(handles,'Iterations',obj.iterations);
            Utils.GraphPlotter.addAnswers(handles,'Error',obj.eArray(length(obj.eArray)));
            Utils.GraphPlotter.addAnswers(handles,'Time',time);
            Utils.GraphPlotter.addAnswers(handles,'Error Bound',obj.calculateErrorBound);
        end
        
        function addPlot(obj,handles)
            Utils.GraphPlotter.plot(handles,obj.xArray,obj.iterations,'c');
            Utils.GraphPlotter.plotError(handles,obj.eArray,obj.iterations,'c');
        end
        
    end
    
    methods(Static)
        
        function setFields(handles,mode)
            set(handles.xFixed,'Visible',mode);
            set(handles.maxFixed,'Visible',mode);
            set(handles.eFixed,'Visible',mode);
            set(handles.xLFixed,'Visible',mode);
            set(handles.maxLFixed,'Visible',mode);
            set(handles.eLFixed,'Visible',mode);
        end
        
        function iLine = loadParameters(handles,data,iLine)
            set(handles.methodsMenu,'Value',4);
            set(handles.xFixed,'string',data{iLine});
            set(handles.maxFixed,'string',data{iLine+1});
            set(handles.eFixed,'string',data{iLine+2});
            iLine = 3;
        end
        
    end
    
end
