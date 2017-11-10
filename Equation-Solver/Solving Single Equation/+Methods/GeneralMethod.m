classdef GeneralMethod
    %GeneralMethod Root Finder
    properties
        lowBound = -100;
        highBound = 100;
        delta = 0.01;
        eps = 0.001;
    end
    
    methods
        function obj = GeneralMethod()
        end
        
        function result = solve(obj,equationStr, handles)
            Utils.GraphPlotter.addMethodName(handles,'General Method');
            % attempting to use Birge Vieta Method first for better handling
            % of multiple roots.
            
            result = obj.attemptBirgeVieta(equationStr, handles);
            if (~isempty(result))
                return;
            end
            equation = obj.getEquation(equationStr);
            rightPointer= obj.highBound;
            leftPointer = rightPointer - obj.delta;
            while (leftPointer > obj.lowBound)
                lowValue = equation(leftPointer);
                hiValue = equation(rightPointer);
                if (obj.isCriteriaMet(lowValue, hiValue))
                    solver = Methods.TernaryMethod(equation);
                    foundRoot = solver.solve(leftPointer, rightPointer, 0.0001, 1000);
                    if (length(find(result == foundRoot)) <= 0)
                        result = [result; foundRoot];
                   end
                end
                rightPointer = leftPointer;
                leftPointer = rightPointer - obj.delta;
            end
            for i = 1:length(result)
                obj.addData(handles, result(i));
            end
        end
        
        function equation = getEquation(~,equationStr)
            symbolicEquation = sym(equationStr);
            equation = matlabFunction(symbolicEquation);
            return;
        end
        
        function checkResult = isCriteriaMet(~,lowValue, hiValue)
            checkResult = false;
            if (lowValue * hiValue <= 0)
                checkResult = true;
            end
        end
        
        function result = attemptBirgeVieta(~,equation, handles)
            solver = Methods.BirgeVietaMRMethod(equation);
            result = solver.solve(0.05, 0.001, 10, handles);
            return;
        end
        
        function addData(~,handles,root)
            data = get(handles.uitable1,'data');
            data(end+1,1) = {root};
            set(handles.uitable1,'data',data);
        end
    end
    
end

