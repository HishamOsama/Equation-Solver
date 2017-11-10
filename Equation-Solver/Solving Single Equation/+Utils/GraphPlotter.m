classdef GraphPlotter
    %SOLVER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods(Static)
        
        function plotCuvre(handles,stringEquation,range)
            hold(handles.axes,'off');
            cla(handles.axes2,'reset');
            plot(handles.axes,range,Utils.StringParser.plotFunction(stringEquation,range));
        end
        
        function plotShiftedCurve(handles,stringEquation,range)
            hold(handles.axes,'off');
            cla(handles.axes2,'reset');
            plot(handles.axes,range,Utils.StringParser.plotShiftedFunction(stringEquation,range));
            hold(handles.axes,'on')
            x = range;
            y = x;
            plot(handles.axes,x,y);
            hold(handles.axes,'off')
        end
        
        function plotTangentCurve(handles,stringEquation,range)
            hold(handles.axes,'off');
            cla(handles.axes2,'reset');
            plot(handles.axes,range,Utils.StringParser.plotShiftedFunction(stringEquation,range));
            hold(handles.axes,'on')
            % Calculate Tanget Line
            x1 = range(1)+5;
            slope = Utils.StringParser.getDerivative(stringEquation,x1);
            y1 = Utils.StringParser.plotFunction(stringEquation,x1);
            syms x y
            x = range;
            y = slope.*x + (y1-(slope*x1));
            plot(handles.axes,x,y);
            hold(handles.axes,'off')
        end
        
        function plot(handles,XArray,numberOfIterations,color)
            methods = {'Bisection','False Position','Fixied Point','Newton Raphson','Secant','Birge Vieta'};
            range = linspace(1,numberOfIterations,numberOfIterations);
            plot(handles.axes,range,XArray,color);
            legend(handles.axes,methods)
            hold(handles.axes,'on')
        end
        
        function plotError(handles,XArray,numberOfIterations,color)
            methods = {'Bisection','False Position','Fixied Point','Newton Raphson','Secant','Birge Vieta'};
            range = linspace(1,numberOfIterations,numberOfIterations);
            plot(handles.axes2,range,XArray,color);
            legend(handles.axes2,methods)
            hold(handles.axes2,'on')
        end
        
        function addMethodName(handles,method)
            data = get(handles.uitable1,'data');
            if(length(data) == 1)
                data(length(data) ,1) = {method};
            else
                data(end+1,1) = {method};
            end
            set(handles.uitable1,'data',data);
            
            data = get(handles.uitable2,'data');
            if(length(data) == 1)
                data(length(data) ,1) = {method};
            else
                data(end+1,1) = {method};
            end
            set(handles.uitable2,'data',data);
        end
        
        function addAnswers(handles,key,value)
            data = get(handles.uitable2,'data');
            data(end+1,1) = {key};
            data(end,2) = {value};
            set(handles.uitable2,'data',data);
        end
       
    end
    
end