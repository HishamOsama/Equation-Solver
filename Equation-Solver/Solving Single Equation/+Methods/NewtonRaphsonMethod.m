classdef NewtonRaphsonMethod
    %NEWTONRAPHSONMETHOD Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        equation;
        xArray = [];
        eArray = [];
        iterations;
    end
    
    methods
        
        function obj = NewtonRaphsonMethod(equation)
            obj.equation = equation;
        end
        
        function solve(obj,handles,x0,maxI,es)
            
            Utils.GraphPlotter.addMethodName(handles,'Newton Raphson');
          
            xrOld = x0;
            
            tic
            for i = 1 : maxI
                
                xr = xrOld - (obj.evaluate(xrOld)/obj.evaluateDerivative(xrOld));
                obj.xArray = [obj.xArray,xr];
                ea = abs(xr - xrOld);
                obj.eArray = [obj.eArray;ea];
                
                obj.addData(handles,xrOld,xr,ea);
                
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
            approximateRoot = obj.xArray(length(obj.xArray));
            firstError = obj.eArray(1);
            firstDerivative = obj.evaluateDerivative(approximateRoot);
            secondDerivative = obj.evaulateSecondDerivative(approximateRoot);
            errorBound = (secondDerivative * (firstError)^2) / (2 * firstDerivative);
        end
        
        function y = evaluate(obj,x)
            y = obj.equation(x);
        end
        
        function y = evaluateDerivative(obj,x) 
            f = sym(obj.equation);
            df = diff(f);
            y = subs(df,x);
        end
        
        function y = evaulateSecondDerivative(obj,x)
             f = sym(obj.equation);
            df = diff(f);
            df2 = diff(df);
            y = subs(df2,x);
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
        
        function addAnswer(obj,handles,time)
            Utils.GraphPlotter.addAnswers(handles,'Root',obj.xArray(length(obj.xArray)));
            Utils.GraphPlotter.addAnswers(handles,'Iterations',obj.iterations);
            Utils.GraphPlotter.addAnswers(handles,'Error',obj.eArray(length(obj.eArray)));
            Utils.GraphPlotter.addAnswers(handles,'Time',time);
            Utils.GraphPlotter.addAnswers(handles,'Error Bound',obj.calculateErrorBound);
        end
        
        function addPlot(obj,handles)
            Utils.GraphPlotter.plot(handles,obj.xArray,obj.iterations,'r');
            Utils.GraphPlotter.plotError(handles,obj.eArray,obj.iterations,'r');
        end
        
    end
    
    methods(Static)
        
        function setFields(handles,mode)
            set(handles.xNewton,'Visible',mode);
            set(handles.maxNewton,'Visible',mode);
            set(handles.eNewton,'Visible',mode);
            set(handles.xLNewton,'Visible',mode);
            set(handles.maxLNewton,'Visible',mode);
            set(handles.eLNewton,'Visible',mode);
        end
        
        function iLine = loadParameters(handles,data,iLine)
            set(handles.methodsMenu,'Value',5);
            set(handles.xNewton,'string',data{iLine});
            set(handles.maxNewton,'string',data{iLine+1});
            set(handles.eNewton,'string',data{iLine+2});
            iLine = 3;
        end
        
    end
    
end