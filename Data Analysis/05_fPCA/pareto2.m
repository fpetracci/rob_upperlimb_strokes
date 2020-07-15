function [hh, ax] = pareto2(varargin)
    %PARETO Pareto chart.
    %   PARETO(Y) produces a Pareto chart where the values in the vector Y
    %   are drawn as bars in descending order.  Each bar will be labeled 
    %   with with its element index in Y.
    %
    %   PARETO(Y,NAMES) labels each bar with the associated text from the  
    %   cell array or string vector NAMES.
    %
    %   PARETO(Y,X) labels each bar of Y with the associated value from X.
    %
    %   PARETO(...,THRESHOLD) Specify the amount of the cumulative
    %   distribution displayed as a proportion between 0 and 1. The default
    %   value for THRESHOLD is .95.
    %
    %   PARETO(AX,...) plots into AX as the main axes, instead of GCA.
    %
    %   H = PARETO(...) returns the primitive Line and Bar objects created.
    %
    %   [H,AX] = PARETO(...) additionally returns the two axes objects 
    %   created.
    %
    %   See also HISTOGRAM, BAR.
    
    %   Copyright 1984-2019 The MathWorks, Inc.

    % Parse possible Axes input
    [cax, args, nargs] = axescheck(varargin{:});
    
    if isa(cax, 'matlab.ui.control.UIAxes')
        error(message('MATLAB:ui:uiaxes:general'));
    end
    
    if nargs == 0
        error(message('MATLAB:pareto:NotEnoughInputs'));
    end
    y = args{1};
    y = matlab.graphics.chart.internal.datachk(y,'numeric');
    
    cutoff = .95;
    names = compose("%d",1:numel(y));
    
    if nargs == 2 
        if isscalar(args{2})
            cutoff = args{2};
            names = compose("%d",1:numel(y));
        else
            names = args{2};
            names=string(names);
        end
    elseif nargs == 3
        names = string(args{2});
        cutoff = args{3};
    end
    
    if ~isvector(y) || isscalar(y)
        error(message('MATLAB:pareto:YMustBeVector'));
    end
    
    % If the data are complex, disregard any complex component, and warn the user.
    if (~isreal(y))
        warning(message('MATLAB:specgraph:private:specgraph:UsingOnlyRealComponentOfComplexData'));
        y = real(y);
    end
    
    if ~isnumeric(cutoff) || cutoff<0 || cutoff>1
        error(message('MATLAB:pareto:InvalidThreshold'))
    end
    
    y = y(:);
    [yy, ndx] = sort(y);
    yy = flipud(yy);
    ndx = flipud(ndx);
    
    cax = newplot(cax);
    parent = cax.Parent;
    fig = ancestor(cax, 'figure');

    % Error if AutoResizeChildren is 'on'
    if isprop(parent,'AutoResizeChildren') && strcmp(parent.AutoResizeChildren,'on')
        error(message('MATLAB:pareto:AutoResizeChildren'))
    end    
    
    hold_state = ishold(cax);
    
    h = bar(cax, 1:length(y), yy, 'BarWidth', 0.5);
    
    h = [h; line(1:length(y), cumsum(yy), 'Color', [60/255, 160/255, 120/255, 0.8] ,'LineStyle','--', 'Parent', cax,'Linewidth', 2)];
    ysum = sum(yy);
    
    if ysum == 0
        ysum = eps;
    end
    k = min(find(cumsum(yy) / ysum > cutoff, 1), 10);
    
    if isempty(k)
        k = min(length(y), 10);
    end
    
    xLim = [.5 k+.5];
    yLim = [0 ysum];
    set(cax, 'XLim', xLim);
    set(cax, 'XTick', 1:k, 'XTickLabel', names(ndx(1:k)), 'YLim', yLim);
    
    % Hittest should be off for the transparent axes so that click and
    % mouse motion events are attributed to the opaque axes.
    raxis = axes('Color', 'none', 'XGrid', 'off', 'YGrid', 'off', ...
        'YAxisLocation', 'right', 'XLim', xLim, 'YLim', yLim, ...
        'HitTest', 'off', 'HandleVisibility', get(cax, 'HandleVisibility'), ...
        'Parent', parent);
    if isa(parent,'matlab.graphics.layout.Layout')
        set(raxis,'Layout', get(cax, 'Layout'))
    else
        set(raxis,'Position', get(cax, 'Position'))
    end
    
    yticks = get(cax, 'YTick');
    if max(yticks) < .9 * ysum
        yticks = unique([yticks, ysum]);
    end
    set(cax, 'YTick', yticks)
    yticklabels=compose("%0.0f%%",100*yticks/ysum);
    %set(raxis, 'YTick', yticks, 'YTickLabel', yticklabels, 'XTick', []);
	set(raxis, 'YTick', yticks, 'XTick', []);
    set(fig, 'CurrentAxes', cax);
	linkaxes([raxis, cax],'xy');
    
    
    if isa(parent,'matlab.graphics.layout.Layout')
        addlistener(cax, 'MarkedClean', @(~,~) retilePareto(cax.Layout, raxis));
    else
        addlistener(cax, 'MarkedClean', @(~,~) resizePareto(cax.Position, raxis));
    end
    
    if ~hold_state && ~isa(parent,'matlab.graphics.layout.Layout')
        hold(cax, 'off');
        try %#ok<TRYNC> % Putting this in a try block because replacechildren is not supported with uifigure.
            set(fig, 'NextPlot', 'replacechildren');
        end
    end
    
    if nargout > 0
        hh = h;
        ax = [cax raxis];
    end
end

function [] = resizePareto(caxPos, raxis)
if isvalid(raxis) && ~isequal(raxis.Position, caxPos)
    raxis.Position = caxPos;
end
end

function [] = retilePareto(layout, raxis)
if isvalid(raxis) && ~isequal(raxis.Layout, layout)
    raxis.Layout = layout;
end
end
