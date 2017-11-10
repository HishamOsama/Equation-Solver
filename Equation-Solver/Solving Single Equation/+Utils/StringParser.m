classdef StringParser
    %SOLVER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods(Static)
        
        function [y] = plotFunction(f,x)
            f = sym(f);
            g = matlabFunction(f);
            y = g(x);
        end
        
        function [y] = plotShiftedFunction(f,x)
            f = sym(f);
            g = matlabFunction(f);
            y = g(x) + x;
        end
        
        function [g] = getFunction(f)
            f = sym(f);
            g = matlabFunction(f);
        end
        
        function y = getDerivative(f,x)
            f = sym(f);
            g = matlabFunction(f);
            f = sym(g);
            df = diff(f);
            y = subs(df,x);
        end
        
        function checkSymbolicFunction(handles)
            try
                 stringEquation = get(handles.equation,'String');
                sym(stringEquation);
            catch ME
                %printf('%s \nIllegal Expression\n', ME.identifier);
                set(handles.errorLabel, 'String', 'Illegal Expression');
            end
        end
    end
    
end