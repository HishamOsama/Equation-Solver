classdef TernaryMethod
    %SECANTMETHOD Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        equation;
    end
    
    methods
        
        function obj = TernaryMethod(equation)
            obj.equation = equation;
        end
        
        %add handles
        function result = solve(obj,x0,x1,es,maxIt)
            
            %data = get(handles.uitable1,'data');
            %data(end+1,:) = {1};
            %set(handles.uitable1,'data',data);
           iterations = 0; 
           xLow = x0;
           xHigh = x1;
            while(true)
                iterations = iterations + 1;
                if (abs(xLow - xHigh) < es)
                    result = (xLow + xHigh) / 2;
                end;
                x13 = xLow + (xHigh - xLow) / 3;
                x23 = xLow + 2 * (xHigh - xLow) / 3;
                f13 = obj.evaluate(x13);
                f23 = obj.evaluate(x23);
                
                if (f13 < f23)
                    xLow = x13;
                else
                    xHigh = x23;
                end;
                if(iterations >= maxIt)
                    result =(xLow + xHigh) / 2;
                    return
                end
            end
            
        end
        
        
        function y = evaluate(obj,x)
            y = abs(obj.equation(x));
            y = y * -1;
        end
        
        function addData(obj,handles,i,xl,xu,xr,ea)
            data = get(handles.uitable1,'data');
            data(end+1,1) = {xl};
            data(end,2) = {xu};
            data(end,3) = {xr};
            if(i == 1)
                dashes = string('-----');
                data(end,4) = {dashes};
                data(end,5) = {dashes};
            else
                data(end,4) = {ea};
                data(end,5) = {(ea/xr)*100};
            end
            data(end,6) = {obj.evaluate(xr)};
            set(handles.uitable1,'data',data);
        end
        
    end
    
    methods(Static)
    
        function setFieldsOn(handles)
            set(handles.xTernary,'Visible','on');
            set(handles.x1Ternary,'Visible','on');
            set(handles.maxTernary,'Visible','on');
            set(handles.eTernary,'Visible','on');
            set(handles.xLTernary,'Visible','on');
            set(handles.x1Ternary,'Visible','on');
            set(handles.maxLTernary,'Visible','on');
            set(handles.eLTernary,'Visible','on');
        end
        
        function setFieldsOff(handles)
            set(handles.xTernary,'Visible','off');
            set(handles.x1Ternary,'Visible','off');
            set(handles.maxTernary,'Visible','off');
            set(handles.eTernary,'Visible','off');
            set(handles.xLTernary,'Visible','off');
            set(handles.x1Ternary,'Visible','off');
            set(handles.maxLTernary,'Visible','off');
            set(handles.eLTernary,'Visible','off');
        end
        
    end
end