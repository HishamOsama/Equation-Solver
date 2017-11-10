classdef Solver
    %SOLVER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods(Static)
        
        function [range,stringEquation] = solveBisection(handles)
            % Get Data
            xl = str2double(get(handles.xBisection,'String'));
            xu = str2double(get(handles.x1Bisection,'String'));
            maxI = str2double(get(handles.maxBisection,'String'));
            es = str2double(get(handles.eBisection,'String'));
            
            % Handle Missing Data
            if (isnan(maxI))
                maxI = 50;
                set(handles.maxBisection,'String','50');
            end
            
            if (isnan(es))
                es = 0.00001;
                set(handles.eBisection,'String','0.00001');
            end
            
            % Get Equation
            stringEquation = get(handles.equation,'String');
            equation = Utils.StringParser.getFunction(stringEquation);
            
            % Get object from the method to solve
            bisectionMethod = Methods.BisectionMethod(equation);
            bisectionMethod.solve(handles,xl,xu,maxI,es);
            
            % Plot the equation
            range = linspace(xl,xu,100);
        end
        
        function solveBisectionSteps(hObject,handles)
            
            % Get Data
            xl = str2double(get(handles.xBisection,'String'));
            xu = str2double(get(handles.x1Bisection,'String'));
            
            % Get Equation
            stringEquation = get(handles.equation,'String');
            equation = Utils.StringParser.getFunction(stringEquation);
            
            % Plot the equation
            range = linspace(xl,xu,100);
            plot(handles.axes,range,Utils.StringParser.plotFunction(stringEquation,range));
            
            % Get object from the method to solve
            handles.bisectionMethodSteps = Methods.BisectionMethodSteps(equation,xl,xu);
            guidata(hObject,handles);
            set(handles.stepButton,'Visible','on');
        end
        
        function [range,stringEquation] =  solveRegular(handles)
            % Get Data
            xl = str2double(get(handles.xRegular,'String'));
            xu = str2double(get(handles.x1Regular,'String'));
            maxI = str2double(get(handles.maxRegular,'String'));
            es = str2double(get(handles.eRegular,'String'));
            
            % Handle Missing Data
            if (isnan(maxI))
                maxI = 50;
                set(handles.maxRegular,'String','50');
            end
            
            if (isnan(es))
                es = 0.00001;
                set(handles.eRegular,'String','0.00001');
            end
            
            % Get Equation
            stringEquation = get(handles.equation,'String');
            equation = Utils.StringParser.getFunction(stringEquation);
            
            % Get object from the method to solve
            falsePositionMethod = Methods.FalsePositionMethod(equation);
            falsePositionMethod.solve(handles,xl,xu,maxI,es);
            
            % Plot the equation
            range = linspace(xl,xu,100);
        end
        
        function [range,stringEquation] = solveFixed(handles)
            
            % Get Data
            x0 = str2double(get(handles.xFixed,'String'));
            maxI = str2double(get(handles.maxFixed,'String'));
            es = str2double(get(handles.eFixed,'String'));
            
            % Handle Missing Data
            if (isnan(maxI))
                maxI = 50;
                set(handles.maxFixed,'String','50');
            end
            
            if (isnan(es))
                es = 0.00001;
                set(handles.eFixed,'String','0.00001');
            end
            
            % Get Equation
            stringEquation = get(handles.equation,'String');
            equation = Utils.StringParser.getFunction(stringEquation);
            
            % Get object from the method to solve
            fixedPointMethod = Methods.FixedPointMethod(equation);
            fixedPointMethod.solve(handles,x0,maxI,es);
            
            % Plot the equation
            range = linspace(x0-5,x0+5,100);
        end
        
        function [range,stringEquation] = solveNewton(handles)
            
            % Get Data
            x0 = str2double(get(handles.xNewton,'String'));
            maxI = str2double(get(handles.maxNewton,'String'));
            es = str2double(get(handles.eNewton,'String'));
            
            % Handle Missing Data
            if (isnan(maxI))
                maxI = 50;
                set(handles.maxNewton,'String','50');
            end
            
            if (isnan(es))
                es = 0.00001;
                set(handles.eNewton,'String','0.00001');
            end
            
            % Get Equation
            stringEquation = get(handles.equation,'String');
            equation = Utils.StringParser.getFunction(stringEquation);
            
            % Get object from the method to solve
            newtonRaphsonMethod = Methods.NewtonRaphsonMethod(equation);
            newtonRaphsonMethod.solve(handles,x0,maxI,es);
            
            % Plot the equation
            range = linspace(x0-5,x0+5,100);
        end
        
        function [range,stringEquation] = solveSecant(handles)
            % Get Data
            x0 = str2double(get(handles.xSecant,'String'));
            x1 = str2double(get(handles.x1Secant,'String'));
            maxI = str2double(get(handles.maxSecant,'String'));
            es = str2double(get(handles.eSecant,'String'));
            
            if (isnan(maxI))
                maxI = 50;
                set(handles.maxSecant,'String','50');
            end
            
            if (isnan(es))
                es = 0.00001;
                set(handles.eSecant,'String','0.00001');
            end
            
            % Get Equation
            stringEquation = get(handles.equation,'String');
            equation = Utils.StringParser.getFunction(stringEquation);
            
            % Get object from the method to solve
            secantMethod = Methods.SecantMethod(equation);
            secantMethod.solve(handles,x0,x1,es,maxI);
            
            % Plot the equation
            range = linspace(x0,x1,100);
        end
        
        function [range,stringEquation] = solveVieta(handles)
            % Get Data
            x0 = str2double(get(handles.xVieta,'String'));
            maxI = str2double(get(handles.maxVieta,'String'));
            es = str2double(get(handles.eVieta,'String'));
            
            if (isnan(maxI))
                maxI = 50;
                set(handles.maxVieta,'String','50');
            end
            
            if (isnan(es))
                es = 0.00001;
                set(handles.eVieta,'String','0.00001');
            end
            
            % Get Equation
            stringEquation = get(handles.equation,'String');
            
            % Get object from the method to solve
            vietaMethod = Methods.BirgeVietaMethod(stringEquation);
            vietaMethod.solve(handles,x0,es,maxI);
            
            % Plot the equation
            range = linspace(x0-5,x0+5,100);
        end
        
        function [range,stringEquation] = solveGeneral(handles)
            
            % Get Equation
            stringEquation = get(handles.equation,'String');
            
            % Get object from the method to solve
            generalMethod = Methods.GeneralMethod();
            generalMethod.solve(stringEquation, handles);
            
            % Plot the equation
            range = linspace(-5,5,100);
        end
        
    end
end