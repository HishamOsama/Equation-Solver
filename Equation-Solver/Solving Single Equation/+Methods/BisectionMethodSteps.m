classdef BisectionMethodSteps
    %BISECTIONMETHODSTEPS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        equation;
        i,xrOld,xr,xl,xu,xlInitial,xuInitial;
    end
    
    methods
        
        function obj = BisectionMethodSteps(equation,xl,xu)
            obj.equation = equation;
            obj.i = 1;
            obj.xrOld = 0;
            obj.xr = 0;
            obj.xl = xl;
            obj.xu = xu;
            obj.xlInitial = xl;
            obj.xuInitial = xu;
        end
        
        function obj = solve(obj,handles)
            
            if(obj.evaluate(obj.xl)*obj.evaluate(obj.xu) > 0)
                obj.addErrorMessage(handles);
                return
            end
            
            obj.xr = (obj.xl+obj.xu)/2;
            ea = abs(obj.xr - obj.xrOld);
            
            obj.addData(handles,obj.i,obj.xl,obj.xu,obj.xr,ea);
            obj.updatePlot(handles,obj.xl,obj.xu,obj.xr);
            
            test = obj.evaluate(obj.xl)*obj.evaluate(obj.xr);
            if(test < 0)
                obj.xu = obj.xr;
            elseif (test > 0)
                obj.xl = obj.xr;
            else
                return
            end
            
            obj.xrOld = obj.xr;
            
            obj.i = obj.i + 1;
            
        end
        
        function y = evaluate(obj,x)
            y = obj.equation(x);
        end
        
        function addErrorMessage(~,handles)
            data = get(handles.uitable1,'data');
            data(1,1) = {'No Bracketing Method can be applied'};
            set(handles.uitable1,'data',data);
        end
        
        function addData(obj,handles,i,xl,xu,xr,ea)
            data = get(handles.uitable1,'data');
            data(i,1) = {xl};
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
        
        function updatePlot(obj,handles,xl,xu,xr)
            
            labels = {'f(x)','xl','xu','xr'};
            
            range = linspace(obj.xl,obj.xu,100);
            plot(handles.axes,range,Utils.StringParser.plotFunction(obj.equation,range));
            hold off;
            
            % Plot the equation
            range = linspace(obj.xlInitial,obj.xuInitial,100);
            plot(handles.axes2,range,Utils.StringParser.plotFunction(obj.equation,range));
            hold on;
            % Plot the vertical axis
            y = ylim;
            plot(handles.axes2,[xl xl],y,'r','LineWidth',2);
            hold on;
            plot(handles.axes2,[xu xu],y,'y','LineWidth',2);
            hold on;
            plot(handles.axes2,[xr xr],y,'g','LineWidth',2);
            legend(handles.axes2,labels);
            hold off;

            
            
        end
        
    end
    
    methods(Static)
        
        function setFields(handles,mode)
            set(handles.xBisection,'Visible',mode);
            set(handles.x1Bisection,'Visible',mode);
            set(handles.xLBisection,'Visible',mode);
            set(handles.x1LBisection,'Visible',mode);
        end
        
        function loadParameters(handles,data,iLine)
            set(handles.methodsMenu,'Value',2);
            set(handles.xBisection,'string',data{iLine});
            set(handles.x1Bisection,'string',data{iLine+1});
        end
        
    end
    
end