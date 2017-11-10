classdef BisectionMethod
    %BISECTIONMETHOD Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        equation;
        xArray = [];
        eArray = [];
        iterations;
    end
    
    methods
        
        function obj = BisectionMethod(equation)
            obj.equation = equation;
        end
        
        function solve(obj,handles,xl,xu,maxI,es)
            
            Utils.GraphPlotter.addMethodName(handles,'Bisection');
            
            if(obj.evaluate(xl)*obj.evaluate(xu) > 0)
                obj.addErrorMessage(handles);
                return
            end
            
            maxIterations = obj.getMaxIterations(xl,xu,es);
            obj.iterations = maxI;
            
            xrOld = 0;
            
            tic
            for i = 1 : maxI
                
                xr = (xl+xu)/2;
                obj.xArray = [obj.xArray;xr];
                ea = abs(xr - xrOld);
                obj.eArray = [obj.eArray;ea];
                
                obj.addData(handles,i,xl,xu,xr,ea);
                
                test = obj.evaluate(xl)*obj.evaluate(xr);
                if(test < 0)
                    xu = xr;
                elseif (test > 0)
                    xl = xr;
                else
                    obj.iterations = i;
                    break;
                end
                
                if((i > 1) && (ea < es))
                    obj.iterations = i;
                    break;
                end
                
                xrOld = xr;
                
            end
            time = toc; 
            
            obj.addAnswer(handles,maxIterations,time);
            obj.addPlot(handles);
        end
        
        function y = evaluate(obj,x)
            y = obj.equation(x);
        end
        
        function maxIterations = getMaxIterations(~,xl,xu,es)
            l = xu-xl;
            i = (log(l) - log(es))/log(2);
            maxIterations = ceil(i);
        end
        
        function addErrorMessage(~,handles)
            data = get(handles.uitable1,'data');
            data(end+1,1) = {'No Bracketing Method can be applied'};
            set(handles.uitable1,'data',data);
        end
        
        function addData(obj,handles,i,xl,xu,xr,ea)
            data = get(handles.uitable1,'data');
            data(end+1,1) = {xl};
            data(end,2) = {xu};
            data(end,3) = {xr};
            if(i == 1)
                data(end,4) = {'-------------'};
                data(end,5) = {'-------------'};
            else
                data(end,4) = {ea};
                data(end,5) = {(ea/xr)*100};
            end
            data(end,6) = {obj.evaluate(xr)};
            set(handles.uitable1,'data',data);
            set(handles.uitable1,'ColumnName',{'xl','xu','xr','ea','ea(%)','f(xr)'});
        end
        
        function addAnswer(obj,handles,maxIterations,time)
            Utils.GraphPlotter.addAnswers(handles,'Max Iterations',maxIterations);
            Utils.GraphPlotter.addAnswers(handles,'Root',obj.xArray(length(obj.xArray)));
            Utils.GraphPlotter.addAnswers(handles,'Iterations',obj.iterations);
            Utils.GraphPlotter.addAnswers(handles,'Error',obj.eArray(length(obj.eArray)));
            Utils.GraphPlotter.addAnswers(handles,'Time',time);
        end
        
        function addPlot(obj,handles)
            Utils.GraphPlotter.plot(handles,obj.xArray,obj.iterations,'y');
            Utils.GraphPlotter.plotError(handles,obj.eArray,obj.iterations,'y');
        end
    end
    
    methods(Static)
        
        function setFields(handles,mode)
            set(handles.xBisection,'Visible',mode);
            set(handles.x1Bisection,'Visible',mode);
            set(handles.maxBisection,'Visible',mode);
            set(handles.eBisection,'Visible',mode);
            set(handles.xLBisection,'Visible',mode);
            set(handles.x1LBisection,'Visible',mode);
            set(handles.maxLBisection,'Visible',mode);
            set(handles.eLBisection,'Visible',mode);
        end
        
        function iLine = loadParameters(handles,data,iLine)
            set(handles.methodsMenu,'Value',1);
            set(handles.xBisection,'string',data{iLine});
            set(handles.x1Bisection,'string',data{iLine+1});
            set(handles.maxBisection,'string',data{iLine+2});
            set(handles.eBisection,'string',data{iLine+3});
            iLine = 4;
            return;
        end
        
    end
    
end