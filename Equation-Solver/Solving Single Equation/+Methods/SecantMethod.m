classdef SecantMethod
    %SECANTMETHOD Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        equation;
        xArray = [];
        eArray = [];
    end
    
    methods
        
        function obj = SecantMethod(equation)
            obj.equation = equation;
        end
        
        % add handles
        function result = solve(obj,handles,x0,x1,es,maxIt)
            
            Utils.GraphPlotter.addMethodName(handles,'Secant');
            iterations = 0;
            xOld0 = x0;
            xOld1 = x1;
            tic
            while(true)
                iterations = iterations + 1;
                f0Value = obj.evaluate(xOld0);
                f1Value = obj.evaluate(xOld1);
                xNew = xOld1 - (f1Value * (xOld0 - xOld1)) / (f0Value - f1Value);
                obj.xArray = [obj.xArray,xNew];
                ea = (xNew - xOld1) / xNew;
                ea = abs(ea);
                obj.eArray = [obj.eArray;ea];
                obj.addData(handles, xOld0, xOld1,f0Value,f1Value,xNew, ea);
                if(ea<es)
                    break;
                end
                if(iterations >= maxIt)
                    break;
                end
                xOld0 = xOld1;
                xOld1 = xNew;
            end
            time = toc;
            obj.addAnswer(handles,iterations,time);
            obj.addPlot(handles,iterations);
            
        end
        
        function errorBound = calculateErrorBound(obj)
            approximateRoot = obj.xArray(length(obj.xArray));
            root1 = obj.xArray(1);
            root2 = obj.xArray(2);
            firstDerivative = obj.evaluateDerivative(approximateRoot);
            secondDerivative = obj.evaulateSecondDerivative(approximateRoot);
            errorBound = (-1 * secondDerivative * (approximateRoot - root1) * (approximateRoot - root2)) / (2 * firstDerivative);
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
        
        function y = evaluate(obj,x)
            y = obj.equation(x);
        end
        
        function addData(~,handles,xOld0,xOld1,f0Value,f1Value,xNew,ea)
            data = get(handles.uitable1,'data');
            data(end+1,1) = {xOld0};
            data(end,2) = {xOld1};
            data(end,3) = {f0Value};
            data(end,4) = {f1Value};
            data(end,5) = {xNew};
            data(end,6) = {ea};
            data(end,7) = {ea*100};
            set(handles.uitable1,'data',data);
            set(handles.uitable1,'ColumnName',{'x(i-1)','x(i)','f(x(i-1))','f(x(i))','x(i+1)','ea','ea(%)'});
        end
        
        function addAnswer(obj,handles,iterations,time)
            Utils.GraphPlotter.addAnswers(handles,'Root',obj.xArray(length(obj.xArray)));
            Utils.GraphPlotter.addAnswers(handles,'Iterations',iterations);
            Utils.GraphPlotter.addAnswers(handles,'Error',obj.eArray(length(obj.eArray)));
            Utils.GraphPlotter.addAnswers(handles,'Time',time);
            Utils.GraphPlotter.addAnswers(handles,'Error Bound',obj.calculateErrorBound);
        end
        
        function addPlot(obj,handles,iterations)
            Utils.GraphPlotter.plot(handles,obj.xArray,iterations,'g');
            Utils.GraphPlotter.plotError(handles,obj.eArray,iterations,'g');
        end
        
    end
    
    methods(Static)
        
        function setFields(handles,mode)
            set(handles.xSecant,'Visible',mode);
            set(handles.x1Secant,'Visible',mode);
            set(handles.maxSecant,'Visible',mode);
            set(handles.eSecant,'Visible',mode);
            set(handles.xLSecant,'Visible',mode);
            set(handles.x1LSecant,'Visible',mode);
            set(handles.maxLSecant,'Visible',mode);
            set(handles.eLSecant,'Visible',mode);
        end
        
        function iLine = loadParameters(handles,data,iLine)
            set(handles.methodsMenu,'Value',6);
            set(handles.xSecant,'string',data{iLine});
            set(handles.x1Secant,'string',data{iLine+1});
            set(handles.maxSecant,'string',data{iLine+2});
            set(handles.eSecant,'string',data{iLine+3});
            iLine = 4;
        end
        
    end
end